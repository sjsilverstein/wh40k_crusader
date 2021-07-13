import 'package:flutter/material.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';

class CrusadeUnitCard extends StatelessWidget {
  final CrusadeUnitDataModel unit;
  CrusadeUnitCard(this.unit);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(unit.unitName),
        subtitle: Text(unit.battleFieldRole),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(unit.getRank())],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
          )
        ],
      ),
    );
  }
}
