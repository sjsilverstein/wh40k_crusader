import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/battle_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_battle_performance_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/presentation/views/update_battle_and_unit_performance_view/update_battle_and_unit_performance_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battlefield_role_icon/battlefield_role_icon.dart';
import 'package:wh40k_crusader/presentation/widgets/faction_icon/faction_icon.dart';

class UpdateBattleAndUnitPerformanceView extends StatelessWidget {
  final CrusadeDataModel crusade;
  final BattleDataModel battle;
  final List<CrusadeUnitDataModel> roster;

  UpdateBattleAndUnitPerformanceView({
    required this.crusade,
    required this.battle,
    required this.roster,
  });

  _buildBattleDetailsForm(
      BuildContext context, UpdateBattleAndUnitPerformanceViewModel model) {
    String battleResult;
    Color color;

    if (battle.score > battle.opponentScore) {
      battleResult = 'Victory';
      color = Colors.green;
    } else if (battle.score != battle.opponentScore) {
      battleResult = 'Defeat';
      color = Colors.red;
    } else {
      battleResult = 'Draw';
      color = Colors.white;
    }

    return Card(
      child: ExpansionTile(
        leading: FactionIcon(battle.opponentFaction),
        title: Text(
            '${model.battle.opponentName} - ${model.battle.opponentFaction}'),
        subtitle: Text(
          battleResult,
          style: TextStyle(color: color),
        ),
        children: [
          Text('Opp Name ${battle.opponentName} '),
          Text('Opp Faction ${battle.opponentFaction} '),
          Text('Battle Size ${battle.battleSize} '),
          Text('Power Level: ${battle.battlePowerLevel}'),
          Text('Score ${battle.score}'),
          Text('Opp Score: ${battle.opponentScore}'),
          Text('Mission: ${battle.mission}'),
          Text('Notes: ${battle.notes}'),
        ],
      ),
    );
  }

  _buildUnitPerformanceCards(
      BuildContext context, UpdateBattleAndUnitPerformanceViewModel model) {
    return Column(
      children: model.unitPerformanceList.map((e) {
        if (model.currentRoster.indexWhere(
                (element) => element.documentUID == e.documentUID) ==
            -1) {
          return _UnitNolongerExistCard(e);
        }
        return _CurrentUnitPerformanceFormCard(
          model.currentRoster
              .firstWhere((element) => element.documentUID == e.documentUID),
          e,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateBattleAndUnitPerformanceViewModel>.reactive(
      viewModelBuilder: () =>
          UpdateBattleAndUnitPerformanceViewModel(crusade, battle, roster),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('${model.crusade.name} Update Battle'),
        ),
        body: FormBuilder(
          key: model.formKey,
          child: Column(
            children: [
              _buildBattleDetailsForm(context, model),
              _buildUnitPerformanceCards(context, model),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnitNolongerExistCard extends StatelessWidget {
  final CrusadeUnitBattlePerformanceDataModel performance;

  _UnitNolongerExistCard(this.performance);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.warning),
        title: Text(
          'This unit no longer exists!',
          style: TextStyle(color: Colors.red),
        ),
        children: [
          Text('United Destroyed: ${performance.unitsDestroyed}'),
          Text('Bonus XP: ${performance.bonusXP}'),
          Text('Was Destroyed: ${performance.wasDestroyed}'),
          Text('Marked For Greatness: ${performance.markedForGreatness}'),
        ],
      ),
    );
  }
}

class _CurrentUnitPerformanceFormCard
    extends ViewModelWidget<UpdateBattleAndUnitPerformanceViewModel> {
  final CrusadeUnitBattlePerformanceDataModel performance;
  final CrusadeUnitDataModel unit;

  _CurrentUnitPerformanceFormCard(this.unit, this.performance);

  @override
  Widget build(
      BuildContext context, UpdateBattleAndUnitPerformanceViewModel model) {
    // TODO: implement build
    return Card(
      child: ExpansionTile(
        leading: BattleFieldRoleIcon(unit.battleFieldRole),
        title: Text('${unit.unitName}'),
        subtitle: Text(unit.unitType),
        children: [
          Text('United Destroyed: ${performance.unitsDestroyed}'),
          Text('Bonus XP: ${performance.bonusXP}'),
          Text('Was Destroyed: ${performance.wasDestroyed}'),
          Text('Marked For Greatness: ${performance.markedForGreatness}'),
        ],
      ),
    );
  }
}
