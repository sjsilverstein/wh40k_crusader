import 'package:flutter/widgets.dart';
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
import 'package:wh40k_crusader/services/crusade_roster_service.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

enum AddBattleViewModelState {
  initial,
  roster,
  honors,
}

class AddBattleViewModel extends MultipleStreamViewModel {
  final _db = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();

  CrusadeDataModel crusade;

  AddBattleViewModelState _state = AddBattleViewModelState.initial;
  AddBattleViewModelState get state => _state;

  final formKey = GlobalKey<FormBuilderState>();

  DateTime? battleDate;
  int? battlePowerLevel;
  String? battleSize;
  String? opponentName;
  String? opponentFaction;
  int? score;
  int? opponentScore;
  String? mission;
  String? notes;

  List<CrusadeUnitDataModel> battleRoster = [];
  List<CrusadeUnitBattlePerformanceDataModel> rosterPerformance = [];

  String? _markedForGreatnessUnitUID;
  String? get markedForGreatnessUnitUID => _markedForGreatnessUnitUID;

  AddBattleViewModel(this.crusade);

  @override
  Map<String, StreamData> get streamsMap => {
        kCrusadeStream: StreamData<CrusadeDataModel>(
            _db.listenToCrusadeRealTime(crusadeUID: crusade.documentUID!),
            onData: (data) => crusade = data),
        kRosterStream: StreamData<List<CrusadeUnitDataModel>>(
            _db.listenToCrusadeRoster(crusadeUID: crusade.documentUID!),
            transformData: CrusadeRosterService.orderRoster),
      };

  addUnitToBattleRoster(CrusadeUnitDataModel unit, bool isChecked) {
    logger.i('${unit.unitName} isChecked : $isChecked');

    if (isChecked) {
      // Add unit to Battle Roster

      battleRoster.add(unit);
    } else {
      // remove unit from Battle Roster
      battleRoster.remove(unit);
    }

    CrusadeRosterService.orderRoster(battleRoster);
    notifyListeners();
  }

  markedForGreatness(bool value, String unitUID) {
    if (!value && _markedForGreatnessUnitUID == unitUID) {
      _markedForGreatnessUnitUID = null;
    }
    if (value) {
      _markedForGreatnessUnitUID = unitUID;
    }
    notifyListeners();
  }

  _changeViewState(AddBattleViewModelState state) {
    busy(true);
    switch (state) {
      case AddBattleViewModelState.initial:
        _state = AddBattleViewModelState.initial;
        break;
      case AddBattleViewModelState.roster:
        _state = AddBattleViewModelState.roster;
        break;
      case AddBattleViewModelState.honors:
        _state = AddBattleViewModelState.honors;
        break;
      default:
        logger.wtf('Some Unknown State');
        break;
    }
    busy(false);
    notifyListeners();
  }

  battleDetailsForm() {
    _changeViewState(AddBattleViewModelState.initial);
  }

  selectHonours() {
    _changeViewState(AddBattleViewModelState.honors);
  }

  recordBattle() async {
    BattleDataModel battle;
    List<CrusadeUnitBattlePerformanceDataModel> battleRosterPerformance = [];
    List<CrusadeUnitDataModel> battleRosterUpdatedUnitData = [];

    formKey.currentState?.saveAndValidate();
    //Get unit performance from form data
    battleRoster.forEach((element) {
      int unitsDestroyed = formKey
          .currentState!.fields['${element.documentUID}unitsDestroyed']!.value;
      int bonusXP =
          formKey.currentState!.fields['${element.documentUID}bonusXP']!.value;
      bool wasDestroyed = formKey
          .currentState!.fields['${element.documentUID}wasDestroyed']!.value;
      bool markedForGreatness =
          markedForGreatnessUnitUID == element.documentUID ? true : false;

      battleRosterPerformance.add(CrusadeUnitBattlePerformanceDataModel(
          unit: element,
          unitsDestroyed: unitsDestroyed,
          bonusXP: bonusXP,
          wasDestroyed: wasDestroyed,
          markedForGreatness: markedForGreatness));
    });

    // Adjust units based on performance

    battleRosterPerformance.forEach((element) {
      battleRosterUpdatedUnitData.add(element.unit!.copyWith(
        battlesPlayed: element.unit!.battlesPlayed + 1,
        battlesSurvived: element.wasDestroyed
            ? element.unit!.battlesSurvived + 1
            : element.unit!.battlesSurvived,
        experience: element.markedForGreatness
            ? element.unit!.experience +
                4 +
                (element.unitsDestroyed % 3) +
                element.bonusXP
            : element.unit!.experience + 1,
      ));
    });

    battle = BattleDataModel(
      battleDate: battleDate!,
      battleSize: battleSize!,
      battlePowerLevel: battlePowerLevel!,
      opponentName: opponentName!,
      opponentFaction: opponentFaction!,
      score: score!,
      opponentScore: opponentScore!,
      mission: mission,
      notes: notes,
    );

    // Write to firebase new units values
    battleRosterUpdatedUnitData.forEach((unit) async {
      await _db.updateCrusadeUnit(crusade: crusade, unit: unit);
    });

    // Write to firebase the battle record
    await _db.recordBattle(
      crusade: crusade,
      battle: battle,
      unitPerformanceList: battleRosterPerformance,
    );

    // Pop form off stack and navigate to show units updated stats.
    _navigationService.back();
  }

  selectRoster() {
    formKey.currentState!.save();
    bool isValid = formKey.currentState!.saveAndValidate();

    if (isValid) {
      FormBuilderState currentState = formKey.currentState!;
      battleDate = currentState.fields[kBattleDate]!.value;
      battlePowerLevel = currentState.fields[kBattlePowerLevel]!.value;
      battleSize = currentState.fields[kBattleSize]!.value;
      opponentName = currentState.fields[kOpponentName]!.value;
      opponentFaction = currentState.fields[kOpponentFaction]!.value;
      score = int.parse(currentState.fields[kScore]!.value);
      opponentScore = int.parse(currentState.fields[kOpponentScore]!.value);
      mission = currentState.fields[kMission]!.value;
      notes = currentState.fields[kNotes]!.value;
      _changeViewState(AddBattleViewModelState.roster);
    }
  }
}
