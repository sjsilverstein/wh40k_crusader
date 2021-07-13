import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/routing/routes.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

class HomeViewModel extends StreamViewModel<List<CrusadeDataModel>> {
  final NavigationService _navigationService = locator<NavigationService>();
  final _firebaseAuth = locator<FirebaseAuthenicationService>();
  final FirestoreService _db = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  Stream<List<CrusadeDataModel>> get stream => _db.listenToCrusadesRealTime();

  final String _title = 'Warhammer 40K Crusader';
  String get title => _title;

  @override
  void onData(List<CrusadeDataModel>? data) {
    notifyListeners();
    // TODO: implement onData
    super.onData(data);
  }

  logoff() async {
    logger.i("Logging Out");
    await _firebaseAuth.logout();
    _navigationService.replaceWith(rNavigationRoutes.LoginRoute);
  }

  void pushCrusadeRoute(CrusadeDataModel crusade) {
    logger.wtf('Pushing Route: ${crusade.documentUID}');
    _navigationService.navigateTo(rNavigationRoutes.CrusadeRoute,
        arguments: crusade);
  }

  navigateToNewCrusadeForm() {
    _navigationService.navigateTo(rNavigationRoutes.NewCrusade);
  }

  // TODO Consider Dialog Form / Response Path

}
