import 'package:wh40k_crusader/data_models/battle_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';

class UpdateCrusadeUnitRouteArgs {
  final CrusadeDataModel crusade;
  final CrusadeUnitDataModel unit;

  UpdateCrusadeUnitRouteArgs(this.crusade, this.unit);
}

class UpdateBattleAndUnitPerformanceRouteArgs {
  final CrusadeDataModel crusade;
  final BattleDataModel battle;
  final List<CrusadeUnitDataModel> roster;
  UpdateBattleAndUnitPerformanceRouteArgs(
      this.crusade, this.battle, this.roster);
}
