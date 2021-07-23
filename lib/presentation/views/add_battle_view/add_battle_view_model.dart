import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/battle_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/services/crusade_roster_service.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

enum AddBattleViewModelState { initial, roster, honors }

class AddBattleViewModel extends MultipleStreamViewModel {
  final _db = locator<FirestoreService>();

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

  List<CrusadeUnitDataModel>? battleRoster;
  List<CrusadeUnitBattlePerformanceDataModel>? rosterPerformance;

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

  // _recordBattle() {
  //   BattleDataModel battle;
  //
  //   battle = BattleDataModel(
  //     battleDate: battleDate!,
  //     battlePowerLevel: battlePowerLevel!,
  //     battleSize: battleSize!,
  //     opponentName: opponentName!,
  //     opponentFaction: opponentFaction!,
  //     score: score!,
  //     opponentScore: opponentScore!,
  //     mission: mission,
  //     notes: notes,
  //   );
  //
  //   battle.roster = battleRoster;
  //   battle.rosterPerformance = rosterPerformance;
  // }
}
