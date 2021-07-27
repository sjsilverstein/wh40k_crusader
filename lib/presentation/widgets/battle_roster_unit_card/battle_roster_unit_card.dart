import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/add_battle_view/add_battle_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battlefield_role_icon/battlefield_role_icon.dart';

class BattleRosterUnitCard extends ViewModelWidget<AddBattleViewModel> {
  final int index;
  BattleRosterUnitCard(this.index);

  @override
  Widget build(BuildContext context, AddBattleViewModel model) {
    CrusadeUnitDataModel unit = model.battleRoster[index];
    return Card(
      child: ListTile(
        title: Text('${unit.unitName} - ${unit.unitType}'),
        leading: BattleFieldRoleIcon(unit.battleFieldRole),
        subtitle: Row(
          children: [
            Text(
              unit.getRank(),
              style: TextStyle(
                color: GetColorFrom.unitRank(unit.getRank()),
              ),
            ),
            HorizontalSpace.small,
            Text('Exp: ${unit.experience}')
          ],
        ),
      ),
    );
  }
}
