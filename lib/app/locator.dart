import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirebaseAuthenicationService());
  locator.registerLazySingleton(() => FirestoreService());
}
