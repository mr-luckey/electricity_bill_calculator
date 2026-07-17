import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/calculation_record.dart';

class HistoryRepository {
  HistoryRepository(this._box);

  static const boxName = 'calculation_history';
  static const _recordsKey = 'records';
  static const _maxRecords = 20;

  final Box<String> _box;

  List<CalculationRecord> get records {
    final raw = _box.get(_recordsKey);
    if (raw == null) return const [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => CalculationRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  CalculationRecord? get lastCalculation {
    final items = records;
    return items.isEmpty ? null : items.first;
  }

  Future<void> saveCalculation(CalculationRecord record) async {
    final updated = [record, ...records];
    if (updated.length > _maxRecords) {
      updated.removeRange(_maxRecords, updated.length);
    }

    final encoded = jsonEncode(updated.map((e) => e.toJson()).toList());
    await _box.put(_recordsKey, encoded);
  }

  Future<void> clear() => _box.delete(_recordsKey);
}
