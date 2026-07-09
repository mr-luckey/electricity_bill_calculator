import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  /// Try each ID in order until one loads. Add your real unit IDs here.
  static const bannerAdUnitIds = [
    'ca-app-pub-5561438827097019/2042222866',
    'ca-app-pub-5561438827097019/8836685752',
    'ca-app-pub-5561438827097019/9767870881',
    'ca-app-pub-5561438827097019/8029046711',
    'ca-app-pub-5561438827097019/3699909144',
    // 'ca-app-pub-XXXXXXXX/BBBBBBBBBB',
    // 'ca-app-pub-XXXXXXXX/CCCCCCCCCC',
  ];

  static const interstitialAdUnitIds = [
    'ca-app-pub-5561438827097019/4089801709',
    'ca-app-pub-5561438827097019/3637576800',
    'ca-app-pub-5561438827097019/8416059521',
    'ca-app-pub-5561438827097019/3749257442',
    'ca-app-pub-5561438827097019/8754172110',
    // 'ca-app-pub-XXXXXXXX/IIIIIIIIII',
    // 'ca-app-pub-XXXXXXXX/JJJJJJJJJJ',
  ];

  static const interstitialShowDelay = Duration(seconds: 30);

  InterstitialAd? _interstitialAd;
  bool _isInterstitialReady = false;
  Timer? _interstitialTimer;
  bool _interstitialShownThisSession = false;
  bool _isLoadingInterstitial = false;

  // ─── Initialize ───────────────────────────────────────────────
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitial(index: 0);
  }

  // ─── Banner (load all, show first success) ────────────────────
  void loadBanner({
    required void Function(BannerAd ad) onLoaded,
    VoidCallback? onAllFailed,
  }) {
    if (bannerAdUnitIds.isEmpty) {
      onAllFailed?.call();
      return;
    }

    var loaded = false;
    var pending = bannerAdUnitIds.length;

    for (final adUnitId in bannerAdUnitIds) {
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

  // ─── Interstitial (try IDs until one loads) ───────────────────
  void _loadInterstitial({required int index}) {
    if (_isLoadingInterstitial || _isInterstitialReady) return;
    if (index >= interstitialAdUnitIds.length) {
      Future.delayed(interstitialShowDelay, () => _loadInterstitial(index: 0));
      return;
    }

    _isLoadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitIds[index],
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoadingInterstitial = false;
          _interstitialAd = ad;
          _isInterstitialReady = true;
          ad.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          _isLoadingInterstitial = false;
          _loadInterstitial(index: index + 1);
        },
      ),
    );
  }

  bool get isInterstitialReady => _isInterstitialReady;

  /// Shows interstitial 30 seconds after this is called (once per session).
  void startInterstitialTimer() {
    if (_interstitialShownThisSession) return;

    _interstitialTimer?.cancel();
    _interstitialTimer = Timer(interstitialShowDelay, () {
      if (_interstitialShownThisSession) return;
      showInterstitial();
    });
  }

  void cancelInterstitialTimer() {
    _interstitialTimer?.cancel();
    _interstitialTimer = null;
  }

  void showInterstitial({VoidCallback? onDismissed}) {
    if (_interstitialShownThisSession) {
      onDismissed?.call();
      return;
    }

    if (!_isInterstitialReady || _interstitialAd == null) {
      onDismissed?.call();
      return;
    }

    _interstitialShownThisSession = true;
    _interstitialTimer?.cancel();

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isInterstitialReady = false;
        _interstitialAd = null;
        _loadInterstitial(index: 0);
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _isInterstitialReady = false;
        _interstitialAd = null;
        _interstitialShownThisSession = false;
        _loadInterstitial(index: 0);
        onDismissed?.call();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
    _isInterstitialReady = false;
  }

  void dispose() {
    cancelInterstitialTimer();
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
