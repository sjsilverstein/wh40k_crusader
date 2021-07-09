import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

class CrusadeViewModel extends BaseViewModel {
  final CrusadeDataModel crusade;

  final _db = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  CrusadeViewModel(this.crusade);

  Future _deleteCrusadeDocument() async {
    await _db.deleteCrusade(crusade);
    _navigationService.back();
  }

  showConfirmDeleteDialog() async {
    DialogResponse? response = await _dialogService.showConfirmationDialog(
      title: 'Delete Crusade',
      description: 'Are you sure you want to delete this crusade?',
      confirmationTitle: 'Cancel',
      cancelTitle: 'Delete',
    );

    logger.i('Dialog Response ${response?.confirmed}');

    if (!response!.confirmed) {
      _deleteCrusadeDocument();
    }
  }
}
