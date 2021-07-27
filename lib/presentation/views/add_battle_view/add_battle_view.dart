import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/views/add_battle_view/add_battle_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battle_form_details/battle_form_details.dart';
import 'package:wh40k_crusader/presentation/widgets/battle_roster/battle_roster.dart';
import 'package:wh40k_crusader/presentation/widgets/selected_units_battle_performance_list/selected_units_battle_performance_list.dart';

class AddBattleView extends StatelessWidget {
  final CrusadeDataModel crusade;

  AddBattleView(this.crusade);

  _buildFormChildBaseOnModelState(AddBattleViewModel model) {
    switch (model.state) {
      case AddBattleViewModelState.initial:
        return BattleFormDetails();
      case AddBattleViewModelState.roster:
        return BattleRoster();
      case AddBattleViewModelState.honors:
        return SelectedUnitsBattlePerformanceList();
      default:
        return Text('Some Unkown State');
    }
  }

  Widget _buildFloatingActionButton(AddBattleViewModel model) {
    switch (model.state) {
      case AddBattleViewModelState.roster:
        if (model.battleRoster.length > 0) {
          return FloatingActionButton(
            onPressed: () {
              model.selectHonours();
            },
            child: Icon(Icons.navigate_next),
          );
        }
        return Container();
      case AddBattleViewModelState.honors:
        if (model.markedForGreatnessUnitUID != null) {
          return FloatingActionButton(
            onPressed: () {
              model.recordBattle();
            },
            child: Icon(Icons.edit),
          );
        }
        return Container();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddBattleViewModel>.reactive(
      viewModelBuilder: () => AddBattleViewModel(crusade),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text('Add Battle'),
          ),
          body: SingleChildScrollView(
              child: _buildFormChildBaseOnModelState(model)),
          floatingActionButton: _buildFloatingActionButton(model)),
    );
  }
}
