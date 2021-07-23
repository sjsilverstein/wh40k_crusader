import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/crusade_view/crusade_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/crusade_unit_roster/crusade_unit_roster.dart';
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
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
                      ? Row(
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

class EditCrusadeForm extends ViewModelWidget<CrusadeViewModel> {
  @override
  Widget build(BuildContext context, CrusadeViewModel model) {
    return Card(
      child: FormBuilder(
        key: model.editCrusadeValuesFormKey,
        initialValue: {
          kRequisition: model.crusade.requisition.toString(),
          kSupplyLimit: model.crusade.supplyLimit.toString(),
          kSupplyUsed: model.crusade.supplyUsed.toString(),
        },
        child: Column(
          children: [
            Row(
              children: [],
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidthPercentage(context, percentage: .3),
                  child: FormBuilderTextField(
                    name: kRequisition,
                    validator: FormBuilderValidators.required(context),
                    decoration: InputDecoration(labelText: 'Requisition'),
                  ),
                ),
                SizedBox(
                  width: screenWidthPercentage(context, percentage: .3),
                  child: FormBuilderTextField(
                    name: kSupplyLimit,
                    validator: FormBuilderValidators.required(context),
                    decoration: InputDecoration(labelText: 'Supply Limit'),
                  ),
                ),
                SizedBox(
                  width: screenWidthPercentage(context, percentage: .3),
                  child: FormBuilderTextField(
                    name: kSupplyUsed,
                    validator: FormBuilderValidators.required(context),
                    decoration: InputDecoration(labelText: 'Supply Used'),
                  ),
                ),
              ],
            ),
            VerticalSpace.small,
            ElevatedButton(
                onPressed: () async {
                  await model.updateCrusadeWithData();
                },
                child: Text('Update'))
          ],
        ),
      ),
    );
  }
}

class BattleHistory extends ViewModelWidget<CrusadeViewModel> {
  @override
  Widget build(BuildContext context, CrusadeViewModel viewModel) {
    // TODO: implement build
    return Center(
      child: Text('Battle History View'),
    );
  }
}
