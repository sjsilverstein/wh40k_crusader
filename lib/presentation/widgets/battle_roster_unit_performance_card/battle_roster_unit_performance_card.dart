import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/add_battle_view/add_battle_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battlefield_role_icon/battlefield_role_icon.dart';

class BattleRosterUnitPerformanceCard
    extends ViewModelWidget<AddBattleViewModel> {
  final CrusadeUnitDataModel unit;

  BattleRosterUnitPerformanceCard(this.unit);
  @override
  Widget build(BuildContext context, AddBattleViewModel model) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: ExpansionTile(
          leading: BattleFieldRoleIcon(unit.battleFieldRole),
          title: model.markedForGreatnessUnitUID == unit.documentUID
              ? Text('${unit.unitName} - Marked for Greatness')
              : Text('${unit.unitName}'),
          subtitle: Text('${unit.unitType}'),
          children: [
            SizedBox(
              width: screenWidthPercentage(context, percentage: .4),
              child: FormBuilderDropdown(
                  name: '${unit.documentUID}unitsDestroyed',
                  decoration: InputDecoration(
                    labelText: 'Units Destroyed',
                  ),
                  initialValue: 0,
                  items: List<int>.generate(50, (i) => i)
                      .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
                      .toList()),
            ),
            SizedBox(
              width: screenWidthPercentage(context, percentage: .4),
              child: FormBuilderDropdown(
                  name: '${unit.documentUID}bonusXP',
                  decoration: InputDecoration(
                    labelText: 'Agenda XP / Bonus XP',
                  ),
                  initialValue: 0,
                  items: List<int>.generate(50, (i) => i)
                      .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
                      .toList()),
            ),
            SizedBox(
              width: screenWidthPercentage(context, percentage: .4),
              child: FormBuilderCheckbox(
                name: '${unit.documentUID}wasDestroyed',
                title: Text('Was Destroyed'),
                initialValue: false,
                tristate: false,
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: (value) {},
              ),
            ),
            SizedBox(
              width: screenWidthPercentage(context, percentage: .4),
              child: FormBuilderCheckbox(
                name: '${unit.documentUID}markedForGreatness',
                title: Text('Marked For Greatness '),
                initialValue: false,
                tristate: false,
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: (value) {
                  model.markedForGreatness(value!, unit.documentUID!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
