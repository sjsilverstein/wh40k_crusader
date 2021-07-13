import 'package:flutter/material.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';

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

  Widget _getIconFromBattleFieldRole() {
    Image image;
    switch (unit.battleFieldRole) {
      case 'HQ':
        image = Image(
          image: AssetImage('assets/icons/hq.png'),
        );
        break;
      case 'Elite':
        image = Image(
          image: AssetImage('assets/icons/elites.png'),
        );
        break;
      case 'Troop':
        image = Image(
          image: AssetImage('assets/icons/troop.png'),
        );
        break;
      case 'Flyer':
        image = Image(
          image: AssetImage('assets/icons/flyer.png'),
        );
        break;
      case 'Lord of War':
        image = Image(
          image: AssetImage('assets/icons/lordOfWar.png'),
        );
        break;
      case 'Heavy Support':
        image = Image(
          image: AssetImage('assets/icons/heavy-support.png'),
        );
        break;
      case 'Fast Attack':
        image = Image(
          image: AssetImage('assets/icons/fast-attack.png'),
        );
        break;
      case 'Transport':
        image = Image(
          image: AssetImage('assets/icons/transport.png'),
        );
        break;
      case 'Supreme Commander':
        image = Image(
          image: AssetImage('assets/icons/supremeCmd.png'),
        );
        break;
      default:
        return Text(unit.battleFieldRole);
    }
    return SizedBox(
      width: 75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: image,
          ),
          VerticalSpace.tiny,
          Text(
            unit.battleFieldRole,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text('${unit.unitName} - ${unit.unitType}'),
        leading: _getIconFromBattleFieldRole(),
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
