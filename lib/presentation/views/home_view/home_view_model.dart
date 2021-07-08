import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/app/setup_dialog_ui.dart';
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
  //
  // List<CrusadeDataModel>? _crusades;
  // List<CrusadeDataModel>? get crusades => _crusades;

  final String _title = 'Warhammer 40K Crusader Home';
  String get title => _title;

  @override
  void onData(List<CrusadeDataModel>? data) {
    // _crusades = data;
    notifyListeners();
    // TODO: implement onData
    super.onData(data);
  }

  // void listenToCrusades() async {
  //   setBusy(true);
  //   // _crusades = await _db.getCrusadeDataOneTime();
  //
  //   _db.listenToCrusadesRealTime().listen((crusadeData) {
  //     List<CrusadeDataModel> updatedCrusadeData = crusadeData;
  //     if (updatedCrusadeData.length > 0) {
  //       _crusades = updatedCrusadeData;
  //       notifyListeners();
  //     }
  //   });
  //
  //   setBusy(false);
  //   notifyListeners();
  // }

  // initialization() async {
  //   setBusy(true);
  //   // do Some async work
  //
  //   setBusy(false);
  //   notifyListeners();
  // }

  logoff() async {
    logger.i("Logging Out");
    await _firebaseAuth.logout();
    _navigationService.replaceWith(rNavigationRoutes.LoginRoute);
  }

  navigateToNewCrusadeForm() {
    _navigationService.navigateTo(rNavigationRoutes.NewCrusade);
  }

  createNewCrusade() async {
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.newCrusadeForm,
        title: 'New Crusade',
        mainButtonTitle: 'Begin Crusade');

    if (response != null) {
      if (response.confirmed) {
        print(response.responseData);
      }
    }

    // CrusadeDataModel fakeCrusade = CrusadeDataModel(
    //   userUID: 'Fake UID',
    //   name: 'Fake Name',
    //   faction: 'No Faction',
    //   battleTally: -1,
    //   requisition: -1,
    //   supplyLimit: -1,
    //   supplyUsed: -1,
    //   victories: -1,
    // );
    //
    // await _db.createNewCrusade(fakeCrusade);
  }
}
