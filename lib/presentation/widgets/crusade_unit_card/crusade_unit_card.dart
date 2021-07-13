import 'package:flutter/material.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battlefield_role_icon/battlefield_role_icon.dart';

class CrusadeUnitCard extends StatelessWidget {
  final CrusadeUnitDataModel unit;
  CrusadeUnitCard(this.unit);

  Color getColorFromRank() {
    switch (unit.getRank()) {
      case kUnitRankBattleReady:
        return Colors.green;
      case kUnitRankBlooded:
        return Colors.redAccent;
      case kUnitRankBattleHardened:
        return Colors.blueAccent;
      case kUnitRankHeroic:
        return Colors.purple;
      case kUnitRankLegendary:
        return Colors.orange;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text('${unit.unitName} - ${unit.unitType}'),
        leading: BattleFieldRoleIcon(unit.battleFieldRole),
        subtitle: Text(
          unit.getRank(),
          style: TextStyle(
            color: getColorFromRank(),
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Experience: ${unit.experience.toString()}'),
              Text('Power Rating: ${unit.powerRating.toString()}'),
              Text('Crusade Points: ${unit.crusadePoints.toString()}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Battles Played: ${unit.battlesPlayed.toString()}'),
              Text('Battles Survived: ${unit.battlesSurvived.toString()}'),
            ],
          ),
          Row(
            children: [
              Text(unit.equipment),
            ],
          ),
        ],
      ),
    );
  }
}
