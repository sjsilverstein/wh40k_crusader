import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

class CrusaderCardModel extends BaseViewModel {
  final _db = locator<FirestoreService>();

  deleteCrusadeDocumentByUID(CrusadeDataModel crusade) async {
    await _db.deleteCrusade(crusade);
  }
}
