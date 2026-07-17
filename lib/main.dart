import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/ads/ad_service.dart';
import 'core/providers/app_providers.dart';
import 'data/repositories/history_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize AdMob
  await AdService.instance.initialize();

  await Hive.initFlutter();
  final historyBox = await Hive.openBox<String>(HistoryRepository.boxName);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        historyBoxProvider.overrideWithValue(historyBox),
      ],
      child: const ElectricityBillApp(),
    ),
  );
}
