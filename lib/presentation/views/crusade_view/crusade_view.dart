import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/crusade_view/crusade_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/crusade_unit_roster/crusade_unit_roster.dart';

class CrusadeView extends StatelessWidget {
  final CrusadeDataModel crusade;

  CrusadeView(this.crusade);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CrusadeViewModel>.reactive(
      viewModelBuilder: () => CrusadeViewModel(crusade),
      onModelReady: (model) async => await model.getCrusadeInfo(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(crusade.name),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              child: Icon(Icons.delete),
              onPressed: () async {
                await model.showConfirmDeleteDialog();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Card(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Name: ${model.crusade.name}'),
                      Text('Faction: ${model.crusade.faction}'),
                      Text('Document: ${model.crusade.documentUID}'),
                      Text(
                        'Supply Used: ${model.crusade.supplyUsed}',
                        style: TextStyle(
                            color: model.crusade.supplyUsed >
                                    model.crusade.supplyLimit
                                ? Colors.red
                                : Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
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
                      children: [
                        SizedBox(
                          width: screenWidthPercentage(context, percentage: .3),
                          child: FormBuilderTextField(
                            name: kRequisition,
                            validator: FormBuilderValidators.required(context),
                            decoration:
                                InputDecoration(labelText: 'Requisition'),
                          ),
                        ),
                        SizedBox(
                          width: screenWidthPercentage(context, percentage: .3),
                          child: FormBuilderTextField(
                            name: kSupplyLimit,
                            validator: FormBuilderValidators.required(context),
                            decoration:
                                InputDecoration(labelText: 'Supply Limit'),
                          ),
                        ),
                        SizedBox(
                          width: screenWidthPercentage(context, percentage: .3),
                          child: FormBuilderTextField(
                            name: kSupplyUsed,
                            validator: FormBuilderValidators.required(context),
                            decoration:
                                InputDecoration(labelText: 'Supply Used'),
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
            ),
            VerticalSpace.small,
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          model.createGenericUnitForCrusade();
                        },
                        child: Text('Create Generic Unit'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await model.deleteRoster();
                        },
                        child: Text('Delete Roster'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            CrusadeUnitRoster(model.roster),
          ],
        ),
      ),
    );
  }
}
