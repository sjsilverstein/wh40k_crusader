import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/battle_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_battle_performance_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

class UpdateBattleAndUnitPerformanceViewModel extends BaseViewModel {
  final CrusadeDataModel crusade;
  final BattleDataModel battle;
  final formKey = GlobalKey<FormBuilderState>();
  final _db = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final List<CrusadeUnitDataModel> _currentRoster;
  List<CrusadeUnitDataModel> get currentRoster => _currentRoster;

  List<CrusadeUnitBattlePerformanceDataModel>? unitPerformanceList;

  bool _unitIsMarkedForGreatness = true;
  bool get unitIsMarkedForGreatness => _unitIsMarkedForGreatness;

  String? _unitUIDIsMarkedForGreatness;
  String? get unitUIDIsMarkedForGreatness => _unitUIDIsMarkedForGreatness;

  UpdateBattleAndUnitPerformanceViewModel(
      this.crusade, this.battle, this._currentRoster);

  init() async {
    setBusy(true);
    unitPerformanceList = await _db.getBattleUnitPerformances(crusade, battle);
    _findMarkedForGlory();
    setBusy(false);
    notifyListeners();
  }

  _findMarkedForGlory() {
    unitPerformanceList!.forEach((element) {
      if (element.markedForGreatness == true) {
        _unitUIDIsMarkedForGreatness = element.documentUID;
      }
    });
  }

  changeMarkedForGreatness(bool value, String performanceDocumentUID) {
    if (_unitIsMarkedForGreatness == false) {
      _unitIsMarkedForGreatness = value;
      _unitUIDIsMarkedForGreatness = performanceDocumentUID;
    } else {
      _unitIsMarkedForGreatness = false;
      _unitUIDIsMarkedForGreatness = '';
    }
    notifyListeners();
  }

  validateAndSubmit() async {
    BattleDataModel newBattleData;
    List<CrusadeUnitBattlePerformanceDataModel> newUnitPerformanceList = [];

    bool isValid = formKey.currentState!.saveAndValidate();

    if (isValid) {
      newBattleData = battle.copyWith(
        battleSize: formKey.currentState!.fields[kBattleSize]!.value,
        battlePowerLevel:
            formKey.currentState!.fields[kBattlePowerLevel]!.value,
        opponentName: formKey.currentState!.fields[kOpponentName]!.value,
        score: int.parse(formKey.currentState!.fields[kScore]!.value),
        opponentScore:
            int.parse(formKey.currentState!.fields[kOpponentScore]!.value),
        mission: formKey.currentState!.fields[kMission]!.value,
        notes: formKey.currentState!.fields[kNotes]!.value,
      );

      bool updateVictories =
          battle.isVictory() == newBattleData.isVictory() ? false : true;

      List<CrusadeUnitBattlePerformanceDataModel> activeUnitPerformanceList =
          [];

      unitPerformanceList!.forEach((e) {
        if (currentRoster.indexWhere(
                (element) => element.documentUID == e.documentUID) !=
            -1) {
          activeUnitPerformanceList.add(e);
        }
      });
      logger.wtf(
          'Unit PerformanceList List Length ${unitPerformanceList!.length}');
      logger.wtf('Roster  List Length ${currentRoster.length}');

      logger.wtf('ActiveUnit List Length ${activeUnitPerformanceList.length}');

      activeUnitPerformanceList.forEach((element) async {
        CrusadeUnitDataModel? unit = _currentRoster.firstWhere(
          (unit) => unit.documentUID == element.documentUID,
        );

        CrusadeUnitBattlePerformanceDataModel newPerformance = element.copyWith(
          unitsDestroyed: int.parse(formKey.currentState!
              .fields['${element.documentUID}$kUnitsDestroyed']!.value),
          bonusXP: int.parse(formKey
              .currentState!.fields['${element.documentUID}$kBonusXP']!.value),
          wasDestroyed: formKey.currentState!
              .fields['${element.documentUID}$kWasDestroyed']!.value,
          markedForGreatness:
              _unitUIDIsMarkedForGreatness == element.documentUID
                  ? true
                  : false,
        );

        newUnitPerformanceList.add(newPerformance);
        int unitDestroyedExpDif =
            (newPerformance.unitsDestroyed % 3) - (element.unitsDestroyed % 3);
        int bonusXPDif = newPerformance.bonusXP - element.bonusXP;
        int experienceDif =
            element.markedForGreatness == newPerformance.markedForGreatness
                ? (0 + unitDestroyedExpDif + bonusXPDif)
                : newPerformance.markedForGreatness
                    ? (3 + unitDestroyedExpDif + bonusXPDif)
                    : (-3 + unitDestroyedExpDif + bonusXPDif);

        int survivalDif = element.wasDestroyed == newPerformance.wasDestroyed
            ? 0
            : newPerformance.wasDestroyed
                ? -1
                : 1;

        await _db.updateCrusadeUnit(
            crusade: crusade,
            unit: unit.copyWith(
              battlesSurvived: unit.battlesSurvived + survivalDif,
              experience: unit.experience + experienceDif,
            ));
      });

      await _db.updateBattle(
        crusade: crusade.copyWith(
            victories: updateVictories == true
                ? newBattleData.isVictory()
                    ? crusade.victories + 1
                    : crusade.victories - 1
                : 0),
        battle: newBattleData,
        performanceList: newUnitPerformanceList,
      );
    }
    notifyListeners();
    _navigationService.back();
  }
}
