import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/local_storage_service.dart';
import '../../infrastructure/services/shared_preferences_local_storage.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return SharedPreferencesLocalStorage();
});