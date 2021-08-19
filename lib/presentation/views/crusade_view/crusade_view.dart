import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/crusade_view/crusade_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battle_history/battle_history.dart';
import 'package:wh40k_crusader/presentation/widgets/crusade_unit_roster/crusade_unit_roster.dart';
import 'package:wh40k_crusader/presentation/widgets/edit_crusade_form/edit_crusade_form.dart';
import 'package:wh40k_crusader/presentation/widgets/faction_icon/faction_icon.dart';

class CrusadeView extends StatelessWidget {
  final CrusadeDataModel crusade;

  CrusadeView(this.crusade);

  Widget _buildFloatingActionButton(CrusadeViewModel model) {
    switch (model.state) {
      case CrusadeViewModelState.showRoster:
        return FloatingActionButton(
          onPressed: () {
            model.navigateToCreateNewUnitForm();
          },
          child: Icon(Icons.add),
        );
      case CrusadeViewModelState.showBattleHistory:
        return FloatingActionButton(
          onPressed: () {
            model.navigateToAddNewBattleForm();
          },
          child: Icon(Icons.warning_amber_outlined),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CrusadeViewModel>.reactive(
      viewModelBuilder: () => CrusadeViewModel(crusade),
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FactionIcon(crusade.faction),
              HorizontalSpace.regular,
              Text(crusade.name),
              HorizontalSpace.regular,
              FactionIcon(crusade.faction),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Icon(Icons.delete),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () async {
                await model.showConfirmDeleteDialog();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Core Crusade Information
            Card(
              child: Column(
                children: [
                  model.dataMap?[kCrusadeStream] != null
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Requisition: ${model.dataMap?[kCrusadeStream].requisition}',
                                  style: TextStyle(
                                      color: model.dataMap?[kCrusadeStream]
                                                  .requisition >
                                              5
                                          ? Colors.red
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color),
                                ),
                                Text(
                                    'Supply Limit: ${model.dataMap?[kCrusadeStream].supplyLimit}'),
                                Text(
                                  'Supply Used: ${model.dataMap?[kCrusadeStream].supplyUsed}',
                                  style: TextStyle(
                                      color: model.dataMap?[kCrusadeStream]
                                                  .supplyUsed >
                                              model.dataMap?[kCrusadeStream]
                                                  .supplyLimit
                                          ? Colors.red
                                          : Colors.green),
                                ),
                              ],
                            ),
                            VerticalSpace.medium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Victories: ${model.dataMap?[kCrusadeStream].victories}',
                                ),
                                HorizontalSpace.large,
                                Text(
                                    'Battle Tally: ${model.dataMap?[kCrusadeStream].battleTally}'),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                model
                                    .setState(CrusadeViewModelState.showRoster);
                              },
                              child: Text('Show Roster Form')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                model.setState(
                                    CrusadeViewModelState.showEditForm);
                              },
                              child: Text('Show Edit Form')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                model.setState(
                                    CrusadeViewModelState.showBattleHistory);
                              },
                              child: Text('Show Battle History')),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // EditCrusadeForm(),
            VerticalSpace.small,

            if (model.state == CrusadeViewModelState.showRoster)
              CrusadeUnitRoster(),
            if (model.state == CrusadeViewModelState.showEditForm)
              EditCrusadeForm(),
            if (model.state == CrusadeViewModelState.showBattleHistory)
              BattleHistory(),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(model),
      ),
    );
  }
}
