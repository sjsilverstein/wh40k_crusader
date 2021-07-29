import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/battle_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/crusade_view/crusade_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/faction_icon/faction_icon.dart';

class BattleRecordCard extends ViewModelWidget<CrusadeViewModel> {
  final BattleDataModel battle;
  BattleRecordCard(this.battle);

  _buildSubTitle(BuildContext context) {
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

    double _subtitleItemWidth = 150;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: _subtitleItemWidth,
          child: Text(
            battleResult,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
        SizedBox(width: _subtitleItemWidth, child: Text(battle.battleSize)),
        SizedBox(
            width: _subtitleItemWidth, child: Text('Score: ${battle.score}')),
        SizedBox(
            width: _subtitleItemWidth,
            child: Text('Opponents Score: ${battle.opponentScore}')),
      ],
    );
  }

  @override
  Widget build(BuildContext context, CrusadeViewModel model) {
    return Card(
      child: ExpansionTile(
        leading: FactionIcon(battle.opponentFaction),
        title: Text('${battle.opponentName} - ${battle.opponentFaction}'),
        subtitle: _buildSubTitle(context),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  model.showDeleteBattleConfirmationDialog(battle);
                },
                child: Icon(Icons.delete),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
              ),
              HorizontalSpace.large,
            ],
          ),
          Row(
            children: [
              HorizontalSpace.large,
              Text('Battle Power Level: ${battle.battlePowerLevel}'),
            ],
          ),
          Row(
            children: [
              HorizontalSpace.large,
              Text('Mission: ${battle.mission}'),
            ],
          ),
          Row(
            children: [
              HorizontalSpace.large,
              Text('Notes: ${battle.notes}'),
            ],
          ),
        ],
      ),
    );
  }
}
