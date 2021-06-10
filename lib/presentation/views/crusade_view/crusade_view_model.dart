import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

class CrusadeViewModel extends BaseViewModel {
  final CrusadeDataModel crusade;

  final _db = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();

  CrusadeViewModel(this.crusade);

  Future deleteCrusadeDocumentByUID(CrusadeDataModel crusade) async {
    await _db.deleteCrusade(crusade);
    _navigationService.back();
  }
}
