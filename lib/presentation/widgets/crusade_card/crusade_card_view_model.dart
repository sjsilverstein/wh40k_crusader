import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/routing/routes.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

class CrusaderCardModel extends BaseViewModel {
  final CrusadeDataModel crusade;

  final _db = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();

  CrusaderCardModel(this.crusade);

  Future deleteCrusadeDocumentByUID(CrusadeDataModel crusade) async {
    await _db.deleteCrusade(crusade);
  }

  void pushCrusadeRoute() {
    _navigationService.navigateTo(rNavigationRoutes.CrusadeRoute,
        arguments: crusade);
  }
}
