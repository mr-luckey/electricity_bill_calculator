/// Central place for all AdMob unit IDs.
/// Add more IDs to any list — the app tries each ID in order until an ad loads/shows.
class AdUnitIds {
  AdUnitIds._();

  static const banner = [
    'ca-app-pub-5561438827097019/4742739521',
    'ca-app-pub-5561438827097019/5810233015',
    'ca-app-pub-5561438827097019/9803494514',
    'ca-app-pub-5561438827097019/5564866604',
    'ca-app-pub-5561438827097019/7454487173',
    // Add more banner IDs below:
    // 'ca-app-pub-XXXXXXXX/BBBBBBBBBB',
  ];

  static const interstitial = [
    'ca-app-pub-5561438827097019/4828323831',
    'ca-app-pub-5561438827097019/1684532587',
    'ca-app-pub-5561438827097019/4034116918',
    'ca-app-pub-5561438827097019/2726151516',
    'ca-app-pub-5561438827097019/1925004498',
    // Add more interstitial IDs below:
    // 'ca-app-pub-XXXXXXXX/IIIIIIIIII',
  ];

  static const rewarded = [
    // Add your rewarded ad unit IDs here (replace with real rewarded IDs):
    // 'ca-app-pub-5561438827097019/RRRRRRRRRR',
    // 'ca-app-pub-5561438827097019/SSSSSSSSSS',
    // Google test rewarded ID (works in debug):
    'ca-app-pub-5561438827097019/8631837476',
    'ca-app-pub-5561438827097019/9099988170',
    'ca-app-pub-5561438827097019/2806042560',
    'ca-app-pub-5561438827097019/6473824838',
    'ca-app-pub-5561438827097019/8575997150',
  ];
}
