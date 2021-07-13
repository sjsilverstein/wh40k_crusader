import 'package:flutter/material.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/presentation/widgets/crusade_unit_card/crusade_unit_card.dart';

class CrusadeUnitRoster extends StatelessWidget {
  final List<CrusadeUnitDataModel> roster;

  CrusadeUnitRoster(this.roster);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView.builder(
        itemCount: roster.length,
        itemBuilder: (context, index) => CrusadeUnitCard(roster[index]),
      ),
    );
  }
}
