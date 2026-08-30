import '../storage/local_cache_service.dart';

/// Persists the user's language choice across restarts. Hive box is opened on demand so Core
/// stays free of a mandatory locale dependency at init time.
abstract class LocaleSettingsStore {
  Future<String?> readLocaleCode();

  Future<void> writeLocaleCode(String languageCode);
}

class HiveLocaleSettingsStore implements LocaleSettingsStore {
  static const boxName = 'app_settings';
  static const localeKey = 'localeCode';

  @override
  Future<String?> readLocaleCode() async {
    final box = await LocalCacheService.openBox<String>(boxName);
    return box.get(localeKey);
  }

  @override
  Future<void> writeLocaleCode(String languageCode) async {
    final box = await LocalCacheService.openBox<String>(boxName);
    await box.put(localeKey, languageCode);
  }
}
