import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/add_battle_view/add_battle_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battle_roster_unit_card/battle_roster_unit_card.dart';
import 'package:wh40k_crusader/presentation/widgets/battle_roster_unit_check_card/battle_roster_unit_check_card.dart';

class BattleRoster extends ViewModelWidget<AddBattleViewModel> {
  Widget _buildCrusadeRoster(BuildContext context, AddBattleViewModel model) {
    return FormBuilder(
      key: model.formKey,
      child: Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Crusade Roster'),
            model.dataMap?[kRosterStream] != null
                ? model.dataMap![kRosterStream].length != 0
                    ? SizedBox(
                        height: screenHeightPercentage(context, percentage: .9),
                        child: ListView.builder(
                          itemCount: model.dataMap?[kRosterStream].length,
                          itemBuilder: (context, index) =>
                              BattleRosterUnitCheckCard(
                                  model.dataMap?[kRosterStream][index]),
                        ),
                      )
                    : Container(
                        child: Text('No Units in Roster'),
                      )
                : Container(
                    child: Text('No Units in Roster'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBattleRoster(BuildContext context, AddBattleViewModel model) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('Battle Roster'),
          model.battleRoster.length != 0
              ? SizedBox(
                  height: screenHeightPercentage(context, percentage: .5),
                  child: ListView.builder(
                      itemCount: model.battleRoster.length,
                      itemBuilder: (context, index) =>
                          BattleRosterUnitCard(index)),
                )
              : Container(
                  child: Text('No Units in Roster'),
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, AddBattleViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        model.dataMap?[kRosterStream] != null
            ? model.dataMap![kRosterStream].length != 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCrusadeRoster(context, model),
                      _buildBattleRoster(context, model),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'No Units in Roster, try adding units to the crusade.'),
                  )
            : Container(),
      ],
    );
  }
}
