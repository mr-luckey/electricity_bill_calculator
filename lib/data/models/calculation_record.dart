import '../../core/constants/app_constants.dart';
import 'tariff_model.dart';

class CalculationRecord {
  const CalculationRecord({
    required this.disco,
    required this.category,
    required this.units,
    required this.energyCharges,
    required this.fixedCharges,
    required this.gst,
    required this.fpa,
    required this.electricityDuty,
    required this.total,
    required this.lastUpdated,
    required this.ratesStale,
    required this.calculatedAt,
  });

  final String disco;
  final ConsumerCategory category;
  final int units;
  final double energyCharges;
  final double fixedCharges;
  final double gst;
  final double fpa;
  final double electricityDuty;
  final double total;
  final String lastUpdated;
  final bool ratesStale;
  final DateTime calculatedAt;

  factory CalculationRecord.fromBillBreakdown(BillBreakdown breakdown) {
    return CalculationRecord(
      disco: breakdown.disco,
      category: breakdown.category,
      units: breakdown.units,
      energyCharges: breakdown.energyCharges,
      fixedCharges: breakdown.fixedCharges,
      gst: breakdown.gst,
      fpa: breakdown.fpa,
      electricityDuty: breakdown.electricityDuty,
      total: breakdown.total,
      lastUpdated: breakdown.lastUpdated,
      ratesStale: breakdown.ratesStale,
      calculatedAt: DateTime.now(),
    );
  }

  BillBreakdown toBillBreakdown() {
    return BillBreakdown(
      disco: disco,
      category: category,
      units: units,
      energyCharges: energyCharges,
      fixedCharges: fixedCharges,
      gst: gst,
      fpa: fpa,
      electricityDuty: electricityDuty,
      total: total,
      lastUpdated: lastUpdated,
      ratesStale: ratesStale,
    );
  }

  Map<String, dynamic> toJson() => {
    'disco': disco,
    'category': category.key,
    'units': units,
    'energyCharges': energyCharges,
    'fixedCharges': fixedCharges,
    'gst': gst,
    'fpa': fpa,
    'electricityDuty': electricityDuty,
    'total': total,
    'lastUpdated': lastUpdated,
    'ratesStale': ratesStale,
    'calculatedAt': calculatedAt.toIso8601String(),
  };

  factory CalculationRecord.fromJson(Map<String, dynamic> json) {
    return CalculationRecord(
      disco: json['disco'] as String,
      category: json['category'] == 'protected'
          ? ConsumerCategory.protected
          : ConsumerCategory.unprotected,
      units: (json['units'] as num).toInt(),
      energyCharges: (json['energyCharges'] as num).toDouble(),
      fixedCharges: (json['fixedCharges'] as num).toDouble(),
      gst: (json['gst'] as num).toDouble(),
      fpa: (json['fpa'] as num).toDouble(),
      electricityDuty: (json['electricityDuty'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      lastUpdated: json['lastUpdated'] as String,
      ratesStale: json['ratesStale'] as bool,
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
    );
  }
}
