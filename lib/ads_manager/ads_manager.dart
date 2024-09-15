import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NerdAdManager extends StatefulWidget {
  final VoidCallback onAdClosed;

  NerdAdManager({required this.onAdClosed});

  static int lastShownQuizCount = 0;
  static int lastShownShotsCount = 0;

  @override
  _NerdAdManagerState createState() => _NerdAdManagerState();
}

class _NerdAdManagerState extends State<NerdAdManager> {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      //adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ad unit ID
      adUnitId: 'ca-app-pub-2387993758213203/5359988212',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              widget.onAdClosed();
              ad.dispose();
            },
          );
          _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdLoaded = false;
          widget.onAdClosed();
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdLoaded) {
      _interstitialAd!.show();
    }
  }

  @override
  void dispose() {
    //_interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AdMob Integration'),
      ),
      body: Center(
        child: Text('Loading ad...'),
      ),
    );
  }
}