import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/crusade_view/crusade_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battlefield_role_icon/battlefield_role_icon.dart';

class CrusadeUnitCard extends ViewModelWidget<CrusadeViewModel> {
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

  _buildBattleHonors() {
    List<Widget> widgetList = [];
    unit.battleHonors.forEach((element) {
      widgetList.add(
          Text('Title: ${element.title} Description: ${element.description}'));
    });
    return ExpansionTile(
      title: Text('Battle Honors'),
      children: widgetList,
    );
  }

  _buildPowers() {
    List<Widget> widgetList = [];
    unit.psychicPowers.forEach((element) {
      widgetList.add(
          Text('Title: ${element.title} Description: ${element.description}'));
    });
    return ExpansionTile(
      title: Text('Powers'),
      children: widgetList,
    );
  }

  _buildBattleScars() {
    List<Widget> widgetList = [];
    unit.battleScars.forEach((element) {
      widgetList.add(
          Text('Title: ${element.title} Description: ${element.description}'));
    });
    return ExpansionTile(
      title: Text('Battle Scars'),
      children: widgetList,
    );
  }

  @override
  Widget build(BuildContext context, CrusadeViewModel model) {
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  // model.dropUnitFromCrusadeRoster(unit);
                  model.navigateToUpdateCrusadeUnitView(unit);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: Icon(Icons.edit),
              ),
              HorizontalSpace.small,
              ElevatedButton(
                onPressed: () {
                  model.dropUnitFromCrusadeRoster(unit);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: Icon(Icons.delete),
              )
            ],
          ),
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
          unit.psychicPowers.length > 0 ? _buildPowers() : Container(),
          unit.battleHonors.length > 0 ? _buildBattleHonors() : Container(),
          unit.battleScars.length > 0 ? _buildBattleScars() : Container(),
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
