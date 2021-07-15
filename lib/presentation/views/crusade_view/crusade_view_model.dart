import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/routing/routes.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

enum CrusadeViewModelState { showRoster, showEditForm }

class CrusadeViewModel extends BaseViewModel {
  CrusadeDataModel crusade;

  final _db = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final editCrusadeValuesFormKey = GlobalKey<FormBuilderState>();

  List<CrusadeUnitDataModel> roster = [];
  CrusadeViewModelState _state = CrusadeViewModelState.showRoster;
  CrusadeViewModelState get state => _state;
  CrusadeViewModel(this.crusade);

  setState(CrusadeViewModelState state) {
    setBusy(true);
    switch (state) {
      case CrusadeViewModelState.showRoster:
        logger.i('State Change: Show Roster');
        break;
      case CrusadeViewModelState.showEditForm:
        logger.i('State Change: Show Form');
        break;
      default:
        break;
    }
    setBusy(false);
    _state = state;
    notifyListeners();
  }

  getCrusadeInfo() async {
    // TODO consider why the form doesn't update on unit added to roster.
    logger.i("Getting new data for Crusade: ${crusade.documentUID}");
    CrusadeDataModel? newData = await _db.getCrusadeByUID(crusade.documentUID!);
    roster = await _db.getRoster(crusadeUID: crusade.documentUID!);

    if (newData != null) {
      logger.i("New data for Crusade: ${crusade.documentUID}");
      logger.wtf("${newData.toJSONString()}");
      crusade = newData;
      // _updateCrusadeFormFieldsValues();
    }
    _orderRoster();
    notifyListeners();
  }

  dropUnitFromCrusadeRoster(CrusadeUnitDataModel unitToDrop) async {
    await _db.deleteRemoveUnitFromRoster(
        crusade: crusade, unitToDelete: unitToDrop);
    await getCrusadeInfo();
  }

  _deleteRoster() async {
    await _db.deleteRoster(crusade);
    await getCrusadeInfo();
  }

  Future _deleteCrusadeDocument() async {
    await _deleteRoster();
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

  showDropRosterDialog() async {
    DialogResponse? response = await _dialogService.showConfirmationDialog(
      title: 'Drop Roster',
      description: 'Are you sure you want to drop this roster?',
      confirmationTitle: 'Cancel',
      cancelTitle: 'Delete',
    );

    logger.i('Dialog Response ${response?.confirmed}');

    if (!response!.confirmed) {
      _deleteRoster();
    }
  }

  updateCrusadeWithData() async {
    logger.wtf(
        'req: ${editCrusadeValuesFormKey.currentState!.fields[kRequisition]!.value}');
    logger.wtf(
        'Limit: ${editCrusadeValuesFormKey.currentState!.fields[kSupplyLimit]!.value}');
    logger.wtf(
        'Used: ${editCrusadeValuesFormKey.currentState!.fields[kSupplyUsed]!.value}');

    CrusadeDataModel updatedData = crusade.copyWith(
      requisition: int.parse(
          editCrusadeValuesFormKey.currentState!.fields[kRequisition]!.value),
      supplyLimit: int.parse(
          editCrusadeValuesFormKey.currentState!.fields[kSupplyLimit]!.value),
      supplyUsed: int.parse(
          editCrusadeValuesFormKey.currentState!.fields[kSupplyUsed]!.value),
    );

    await _db.updateCrusade(updatedData);
    await getCrusadeInfo();
  }

  navigateToCreateNewUnitForm() {
    _navigationService.navigateTo(rNavigationRoutes.CreateUnitRoute,
        arguments: crusade);
  }

  _orderRoster() {
    List<CrusadeUnitDataModel> hqs = [];
    List<CrusadeUnitDataModel> elites = [];
    List<CrusadeUnitDataModel> troops = [];
    List<CrusadeUnitDataModel> transport = [];
    List<CrusadeUnitDataModel> fastAttack = [];
    List<CrusadeUnitDataModel> heavySupport = [];
    List<CrusadeUnitDataModel> flyer = [];
    List<CrusadeUnitDataModel> low = [];
    List<CrusadeUnitDataModel> sc = [];
    // Sort in Descending Experience Order
    roster.sort((b, a) => a.experience.compareTo(b.experience));

    roster.forEach((element) {
      if (element.battleFieldRole == CrusadeUnitDataModel.battleFieldRoles[0]) {
        hqs.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[1]) {
        elites.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[2]) {
        troops.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[3]) {
        transport.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[4]) {
        fastAttack.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[5]) {
        heavySupport.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[6]) {
        flyer.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[7]) {
        low.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[8]) {
        sc.add(element);
      } else {
        logger.wtf("We have a unit with an unknown battlefield role");
      }
    });

    List<CrusadeUnitDataModel> orderedRoster = [];
    sc.forEach((element) => orderedRoster.add(element));
    hqs.forEach((element) => orderedRoster.add(element));
    elites.forEach((element) => orderedRoster.add(element));
    troops.forEach((element) => orderedRoster.add(element));
    transport.forEach((element) => orderedRoster.add(element));
    fastAttack.forEach((element) => orderedRoster.add(element));
    heavySupport.forEach((element) => orderedRoster.add(element));
    flyer.forEach((element) => orderedRoster.add(element));
    low.forEach((element) => orderedRoster.add(element));

    roster = orderedRoster;
  }
}
