import 'package:flutter/material.dart';

import 'ad_service.dart';

/// Starts the global interstitial timer for the entire app lifecycle.
class GlobalInterstitialHost extends StatefulWidget {
  const GlobalInterstitialHost({super.key, required this.child});

  final Widget child;

  @override
  State<GlobalInterstitialHost> createState() => _GlobalInterstitialHostState();
}

class _GlobalInterstitialHostState extends State<GlobalInterstitialHost> {
  @override
  void dispose() {
    AdService.instance.stopGlobalInterstitialTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
