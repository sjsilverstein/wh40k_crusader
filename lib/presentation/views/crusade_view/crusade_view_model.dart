import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/battle_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/routing/routes.dart';
import 'package:wh40k_crusader/routing/routing_args.dart';
import 'package:wh40k_crusader/services/crusade_roster_service.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

enum CrusadeViewModelState { showRoster, showEditForm, showBattleHistory }

class CrusadeViewModel extends MultipleStreamViewModel {
  CrusadeDataModel crusade;

  final _db = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final editCrusadeValuesFormKey = GlobalKey<FormBuilderState>();

  CrusadeViewModelState _state = CrusadeViewModelState.showRoster;
  CrusadeViewModelState get state => _state;
  CrusadeViewModel(this.crusade);

  @override
  Map<String, StreamData> get streamsMap => {
        kCrusadeStream: StreamData<CrusadeDataModel>(
            _db.listenToCrusadeRealTime(crusadeUID: crusade.documentUID!),
            onData: (data) => crusade = data),
        kRosterStream: StreamData<List<CrusadeUnitDataModel>>(
            _db.listenToCrusadeRoster(crusadeUID: crusade.documentUID!),
            transformData: CrusadeRosterService.orderRoster),
        kBattleStream: StreamData<List<BattleDataModel>>(
          _db.listenToCrusadesBattles(crusadeUID: crusade.documentUID!),
          onSubscribed: () {
            logger.wtf('Sub to battles');
          },
          onError: (error) {
            logger.wtf('Error on battles: $error');
          },
          onData: (data) {
            logger.wtf('WE HAVE DATA?!?!?!');
            return data;
          },
        ),
      };

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

  dropUnitFromCrusadeRoster(CrusadeUnitDataModel unitToDrop) async {
    DialogResponse? response = await _dialogService.showConfirmationDialog(
      title: 'Delete Unit',
      description: 'Are you sure you want to delete this unit?',
      confirmationTitle: 'Cancel',
      cancelTitle: 'Delete',
    );

    logger.i('Dialog Response ${response?.confirmed}');

    if (!response!.confirmed) {
      await _db.deleteRemoveUnitFromRoster(
          crusade: crusade, unitToDelete: unitToDrop);
    }

    // await getCrusadeInfo();
  }

  _deleteRoster() async {
    await _db.deleteRoster(crusade);
    // await getCrusadeInfo();
  }

  _deleteCrusadeDocument() async {
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

  showDeleteBattleConfirmationDialog(BattleDataModel battle) async {
    DialogResponse? response = await _dialogService.showConfirmationDialog(
      title: 'Delete Battle',
      description:
          'Deleting a battle may cause unit cards to fall out of sync. '
          'Do so at your own risk. '
          'Are you sure you would still like to delete this battle?',
      confirmationTitle: 'Cancel',
      cancelTitle: 'Delete',
    );

    logger.i('Dialog Response ${response?.confirmed}');

    if (!response!.confirmed) {
      // Delete the specific battle and all unit performances
      await _db.deleteBattle(crusade: crusade, battle: battle);
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
      victories: int.parse(
          editCrusadeValuesFormKey.currentState!.fields[kVictories]!.value),
      battleTally: int.parse(
          editCrusadeValuesFormKey.currentState!.fields[kBattleTally]!.value),
    );

    await _db.updateCrusade(updatedData);
    // await getCrusadeInfo();
  }

  navigateToCreateNewUnitForm() {
    _navigationService.navigateTo(rNavigationRoutes.CreateUnitRoute,
        arguments: crusade);
  }

  navigateToAddNewBattleForm() {
    _navigationService.navigateTo(rNavigationRoutes.AddBattleRoute,
        arguments: crusade);
  }

  navigateToUpdateCrusadeUnitView(CrusadeUnitDataModel unit) {
    _navigationService.navigateTo(
      rNavigationRoutes.UpdateUnitRoute,
      arguments: UpdateCrusadeUnitRouteArgs(crusade, unit),
    );
  }

  navigateToUpdateBattleAndUnitPerformanceView(BattleDataModel battle) {
    _navigationService.navigateTo(
      rNavigationRoutes.UpdateBattleAndUnitPerformanceRoute,
      arguments: UpdateBattleAndUnitPerformanceRouteArgs(crusade, battle,
          dataMap![kRosterStream] as List<CrusadeUnitDataModel>),
    );
  }
}
