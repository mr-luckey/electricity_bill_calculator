class DiscoInfo {
  const DiscoInfo({
    required this.id,
    required this.fullName,
    required this.assetLogo,
    required this.logoUrl,
  });

  final String id;
  final String fullName;
  final String assetLogo;
  final String logoUrl;

  static const all = [
    DiscoInfo(
      id: 'LESCO',
      fullName: 'Lahore Electric Supply',
      assetLogo: 'assets/images/discos/lesco.png',
      logoUrl: 'https://bill.pitc.com.pk/images/companies/lesco/lescoLogo.png',
    ),
    DiscoInfo(
      id: 'PESCO',
      fullName: 'Peshawar Electric Supply',
      assetLogo: 'assets/images/discos/pesco.png',
      logoUrl: 'https://bill.pitc.com.pk/images/companies/pesco/pescoLogo.png',
    ),
    DiscoInfo(
      id: 'IESCO',
      fullName: 'Islamabad Electric Supply',
      assetLogo: 'assets/images/discos/iesco.png',
      logoUrl: 'https://bill.pitc.com.pk/images/companies/iesco/iescoLogo.png',
    ),
    DiscoInfo(
      id: 'MEPCO',
      fullName: 'Multan Electric Power',
      assetLogo: 'assets/images/discos/mepco.png',
      logoUrl: 'https://bill.pitc.com.pk/images/companies/mepco/mepcoLogo.png',
    ),
    DiscoInfo(
      id: 'GEPCO',
      fullName: 'Gujranwala Electric Power',
      assetLogo: 'assets/images/discos/gepco.png',
      logoUrl: 'https://bill.pitc.com.pk/images/companies/gepco/gepcoLogo.png',
    ),
    DiscoInfo(
      id: 'FESCO',
      fullName: 'Faisalabad Electric Supply',
      assetLogo: 'assets/images/discos/fesco.png',
      logoUrl: 'https://bill.pitc.com.pk/images/companies/fesco/fescoLogo.png',
    ),
    DiscoInfo(
      id: 'HESCO',
      fullName: 'Hyderabad Electric Supply',
      assetLogo: 'assets/images/discos/hesco.png',
      logoUrl: 'https://bill.pitc.com.pk/images/companies/hesco/hescoLogo.png',
    ),
    DiscoInfo(
      id: 'SEPCO',
      fullName: 'Sukkur Electric Power',
      assetLogo: 'assets/images/discos/sepco.png',
      logoUrl: 'https://bill.pitc.com.pk/images/companies/sepco/sepcoLogo.png',
    ),
    DiscoInfo(
      id: 'QESCO',
      fullName: 'Quetta Electric Supply',
      assetLogo: 'assets/images/discos/qesco.png',
      logoUrl: 'https://bill.pitc.com.pk/images/companies/qesco/qescoLogo.png',
    ),
    DiscoInfo(
      id: 'TESCO',
      fullName: 'Tribal Area Electric Supply',
      assetLogo: 'assets/images/discos/tesco.png',
      logoUrl: 'https://bill.pitc.com.pk/images/companies/tesco/tescoLogo.png',
    ),
    DiscoInfo(
      id: 'HAZECO',
      fullName: 'Hazara Electric Supply',
      assetLogo: 'assets/images/discos/hazeco.png',
      logoUrl: 'https://bill.pitc.com.pk/images/companies/hazeco/hazecoLogo.png',
    ),
    DiscoInfo(
      id: 'K-Electric',
      fullName: 'Karachi Electric Supply',
      assetLogo: 'assets/images/discos/k_electric.webp',
      logoUrl: 'https://ke.com.pk/wp-content/uploads/2025/05/kelogo.webp',
    ),
  ];

  static DiscoInfo? byId(String id) {
    for (final disco in all) {
      if (disco.id == id) return disco;
    }
    return null;
  }
}
