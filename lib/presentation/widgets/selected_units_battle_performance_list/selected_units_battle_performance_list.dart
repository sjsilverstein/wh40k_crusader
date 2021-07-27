import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/add_battle_view/add_battle_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battle_roster_unit_performance_card/battle_roster_unit_performance_card.dart';

class SelectedUnitsBattlePerformanceList
    extends ViewModelWidget<AddBattleViewModel> {
  @override
  Widget build(BuildContext context, AddBattleViewModel model) {
    return Center(
      child: Column(
        children: [
          Text('Unit Battle Performance'),
          SizedBox(
            width: screenWidthPercentage(context, percentage: .6),
            height: screenHeightPercentage(context, percentage: .8),
            child: FormBuilder(
              key: model.formKey,
              child: ListView.builder(
                itemCount: model.battleRoster.length,
                itemBuilder: (context, index) =>
                    BattleRosterUnitPerformanceCard(
                  model.battleRoster[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
