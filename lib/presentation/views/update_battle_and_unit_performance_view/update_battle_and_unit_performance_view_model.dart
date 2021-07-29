import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
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
  final List<CrusadeUnitDataModel> _currentRoster;
  List<CrusadeUnitDataModel> get currentRoster => _currentRoster;

  List<CrusadeUnitBattlePerformanceDataModel> unitPerformanceList = [];

  UpdateBattleAndUnitPerformanceViewModel(
      this.crusade, this.battle, this._currentRoster);

  init() async {
    // Get the list of unit performances
    setBusy(true);
    unitPerformanceList = await _db.getBattleUnitPerformances(crusade, battle);
    setBusy(false);
    notifyListeners();
  }
}
