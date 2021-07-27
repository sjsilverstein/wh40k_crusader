import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/presentation/views/add_battle_view/add_battle_view_model.dart';

class BattleRosterUnitCheckCard extends ViewModelWidget<AddBattleViewModel> {
  final CrusadeUnitDataModel unit;

  BattleRosterUnitCheckCard(this.unit);
  @override
  Widget build(BuildContext context, AddBattleViewModel model) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: FormBuilderCheckbox(
          name: 'addUnitToBattleRoster${unit.documentUID}',
          title: Text('${unit.unitName} - ${unit.unitType}'),
          subtitle: Text(unit.battleFieldRole),
          initialValue: false,
          tristate: false,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (value) {
            model.addUnitToBattleRoster(unit, value!);
          },
        ),
      ),
    );
  }
}
