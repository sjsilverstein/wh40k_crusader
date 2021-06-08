import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/routing/routes.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final _firebaseAuth = locator<FirebaseAuthenicationService>();
  final FirestoreService _db = locator<FirestoreService>();

  List<CrusadeDataModel> _crusades = [];
  List<CrusadeDataModel>? get crusades => _crusades;

  final String _title = 'Warhammer 40K Crusader Home';
  String get title => _title;

  void listenToCrusades() async {
    setBusy(true);
    _crusades = await _db.getCrusadeDataOneTime();
    setBusy(false);
    notifyListeners();
  }

  // initialization() async {
  //   setBusy(true);
  //   // do Some async work
  //
  //   setBusy(false);
  //   notifyListeners();
  // }

  logoff() async {
    await _firebaseAuth.logout();
    _navigationService.replaceWith(rNavigationRoutes.LoginRoute);
  }

  createNewCrusade() async {
    CrusadeDataModel fakeCrusade = CrusadeDataModel(
      userUID: 'Fake UID',
      name: 'Fake Name',
      faction: 'No Faction',
      battleTally: -1,
      requisition: -1,
      supplyLimit: -1,
      supplyUsed: -1,
      victories: -1,
    );

    await _db.createNewCrusade(fakeCrusade);

    listenToCrusades();
  }
}
