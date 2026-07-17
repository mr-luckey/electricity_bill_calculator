/// Central place for all AdMob unit IDs.
/// Add more IDs to any list — the app tries each ID in order until an ad loads/shows.
class AdUnitIds {
  AdUnitIds._();

  static const banner = [
    'ca-app-pub-5561438827097019/2042222866',
    'ca-app-pub-5561438827097019/8836685752',
    'ca-app-pub-5561438827097019/9767870881',
    'ca-app-pub-5561438827097019/8029046711',
    'ca-app-pub-5561438827097019/3699909144',
    // Add more banner IDs below:
    // 'ca-app-pub-XXXXXXXX/BBBBBBBBBB',
  ];

  static const interstitial = [
    'ca-app-pub-5561438827097019/4089801709',
    'ca-app-pub-5561438827097019/3637576800',
    'ca-app-pub-5561438827097019/8416059521',
    'ca-app-pub-5561438827097019/3749257442',
    'ca-app-pub-5561438827097019/8754172110',
    // Add more interstitial IDs below:
    // 'ca-app-pub-XXXXXXXX/IIIIIIIIII',
  ];

  static const rewarded = [
    // Add your rewarded ad unit IDs here (replace with real rewarded IDs):
    // 'ca-app-pub-5561438827097019/RRRRRRRRRR',
    // 'ca-app-pub-5561438827097019/SSSSSSSSSS',
    // Google test rewarded ID (works in debug):
    'ca-app-pub-3940256099942544/5224354917',
  ];
}
