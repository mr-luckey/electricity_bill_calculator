import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_unit_ids.dart';

enum RewardAdOutcome { earned, dismissed, unavailable }

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  static const interstitialInterval = Duration(seconds: 30);
  static const retryAfterAllFailed = Duration(seconds: 15);

  // ─── Interstitial state ───────────────────────────────────────
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  bool _isInterstitialReady = false;
  bool _shouldPrefetchInterstitial = true;
  Timer? _globalInterstitialTimer;
  bool _isShowingInterstitial = false;

  // ─── Rewarded state ───────────────────────────────────────────
  bool _isShowingRewarded = false;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _prefetchInterstitial();
    startGlobalInterstitialTimer();
  }

  // ─── Banner ───────────────────────────────────────────────────
  void loadBanner({
    required void Function(BannerAd ad) onLoaded,
    VoidCallback? onAllFailed,
  }) {
    final ids = AdUnitIds.banner;
    if (ids.isEmpty) {
      onAllFailed?.call();
      return;
    }

    var loaded = false;
    var pending = ids.length;

    for (final adUnitId in ids) {
      BannerAd(
        adUnitId: adUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (loaded) {
              ad.dispose();
              return;
            }
            loaded = true;
            onLoaded(ad as BannerAd);
          },
          onAdFailedToLoad: (ad, _) {
            ad.dispose();
            pending--;
            if (!loaded && pending == 0) {
              onAllFailed?.call();
            }
          },
        ),
      ).load();
    }
  }

  // ─── Global interstitial (every 30s on all screens) ───────────
  void startGlobalInterstitialTimer() {
    _globalInterstitialTimer?.cancel();
    _globalInterstitialTimer = Timer.periodic(interstitialInterval, (_) {
      showInterstitialIfReady();
    });
  }

  void stopGlobalInterstitialTimer() {
    _globalInterstitialTimer?.cancel();
    _globalInterstitialTimer = null;
  }

  void _prefetchInterstitial() {
    if (!_shouldPrefetchInterstitial ||
        _isInterstitialLoading ||
        _isInterstitialReady ||
        _isShowingInterstitial) {
      return;
    }
    _loadInterstitialFromIndex(0);
  }

  void _loadInterstitialFromIndex(int index) {
    final ids = AdUnitIds.interstitial;
    if (ids.isEmpty) return;

    if (index >= ids.length) {
      _isInterstitialLoading = false;
      Future.delayed(retryAfterAllFailed, () {
        _shouldPrefetchInterstitial = true;
        _prefetchInterstitial();
      });
      return;
    }

    _isInterstitialLoading = true;
    InterstitialAd.load(
      adUnitId: ids[index],
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isInterstitialLoading = false;
          _interstitialAd = ad;
          _isInterstitialReady = true;
          _shouldPrefetchInterstitial = false;
          ad.setImmersiveMode(true);
        },
        onAdFailedToLoad: (_) {
          _isInterstitialLoading = false;
          _loadInterstitialFromIndex(index + 1);
        },
      ),
    );
  }

  void showInterstitialIfReady({VoidCallback? onComplete}) {
    if (_isShowingInterstitial || _isShowingRewarded) {
      onComplete?.call();
      return;
    }

    if (!_isInterstitialReady || _interstitialAd == null) {
      onComplete?.call();
      _prefetchInterstitial();
      return;
    }

    final ad = _interstitialAd!;
    _interstitialAd = null;
    _isInterstitialReady = false;
    _isShowingInterstitial = true;
    _shouldPrefetchInterstitial = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (dismissedAd) {
        dismissedAd.dispose();
        _isShowingInterstitial = false;
        _shouldPrefetchInterstitial = true;
        _prefetchInterstitial();
        onComplete?.call();
      },
      onAdFailedToShowFullScreenContent: (failedAd, _) {
        failedAd.dispose();
        _isShowingInterstitial = false;
        _shouldPrefetchInterstitial = true;
        _tryShowInterstitialFromIndex(1, onComplete: onComplete);
      },
    );

    ad.show();
  }

  void _tryShowInterstitialFromIndex(int index, {VoidCallback? onComplete}) {
    final ids = AdUnitIds.interstitial;
    if (index >= ids.length) {
      _prefetchInterstitial();
      onComplete?.call();
      return;
    }

    if (_isInterstitialLoading) {
      onComplete?.call();
      return;
    }

    _isInterstitialLoading = true;
    InterstitialAd.load(
      adUnitId: ids[index],
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isInterstitialLoading = false;
          _interstitialAd = ad;
          _isInterstitialReady = true;
          showInterstitialIfReady(onComplete: onComplete);
        },
        onAdFailedToLoad: (_) {
          _isInterstitialLoading = false;
          _tryShowInterstitialFromIndex(index + 1, onComplete: onComplete);
        },
      ),
    );
  }

  // ─── Rewarded (on Calculate Bill click) ─────────────────────
  Future<RewardAdOutcome> showRewardedAdForCalculation() async {
    if (_isShowingRewarded || _isShowingInterstitial) {
      return RewardAdOutcome.unavailable;
    }

    final ids = AdUnitIds.rewarded.where((id) => id.isNotEmpty).toList();
    if (ids.isEmpty) {
      return RewardAdOutcome.unavailable;
    }

    final completer = Completer<RewardAdOutcome>();
    _loadAndShowRewardedFromIndex(0, ids, completer);
    return completer.future;
  }

  void _loadAndShowRewardedFromIndex(
    int index,
    List<String> ids,
    Completer<RewardAdOutcome> completer,
  ) {
    if (completer.isCompleted) return;

    if (index >= ids.length) {
      completer.complete(RewardAdOutcome.unavailable);
      return;
    }

    RewardedAd.load(
      adUnitId: ids[index],
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (completer.isCompleted) {
            ad.dispose();
            return;
          }

          _isShowingRewarded = true;
          var rewardEarned = false;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (dismissedAd) {
              dismissedAd.dispose();
              _isShowingRewarded = false;
              if (!completer.isCompleted) {
                completer.complete(
                  rewardEarned
                      ? RewardAdOutcome.earned
                      : RewardAdOutcome.dismissed,
                );
              }
            },
            onAdFailedToShowFullScreenContent: (failedAd, _) {
              failedAd.dispose();
              _isShowingRewarded = false;
              _loadAndShowRewardedFromIndex(index + 1, ids, completer);
            },
          );

          ad.show(
            onUserEarnedReward: (_, __) {
              rewardEarned = true;
            },
          );
        },
        onAdFailedToLoad: (_) {
          _loadAndShowRewardedFromIndex(index + 1, ids, completer);
        },
      ),
    );
  }

  void dispose() {
    stopGlobalInterstitialTimer();
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
