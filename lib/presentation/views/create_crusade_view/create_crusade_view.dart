import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/styles.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/create_crusade_view/create_crusade_view_model.dart';

class CreateCrusadeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateCrusadeViewModel>.reactive(
      viewModelBuilder: () => CreateCrusadeViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('New Crusade'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilder(
                    key: model.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: model.formNameField,
                          validator: FormBuilderValidators.required(context),
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        FormBuilderDropdown(
                            name: model.formFactionField,
                            validator: FormBuilderValidators.required(context),
                            decoration: InputDecoration(
                              labelText: 'Faction',
                            ),
                            hint: Text('Select Faction'),
                            items: CrusadeDataModel.factions
                                .map((faction) => DropdownMenuItem(
                                    value: faction, child: Text('$faction')))
                                .toList()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: screenWidthPercentage(context,
                                  percentage: .3),
                              child: FormBuilderDropdown(
                                  name: model.formBattleTallyField,
                                  decoration: InputDecoration(
                                    labelText: 'Battle Tally',
                                  ),
                                  hint: Text('Battle Tally'),
                                  initialValue: 0,
                                  items: List<int>.generate(100, (i) => i)
                                      .map((i) => DropdownMenuItem(
                                          value: i, child: Text('$i')))
                                      .toList()),
                            ),
                            SizedBox(
                              width: screenWidthPercentage(context,
                                  percentage: .3),
                              child: FormBuilderDropdown(
                                  name: model.formVictoriesField,
                                  decoration: InputDecoration(
                                    labelText: 'Victories',
                                  ),
                                  hint: Text('Victories'),
                                  initialValue: 0,
                                  items: List<int>.generate(100, (i) => i)
                                      .map((i) => DropdownMenuItem(
                                          value: i, child: Text('$i')))
                                      .toList()),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: screenWidthPercentage(context,
                                  percentage: .3),
                              child: FormBuilderDropdown(
                                  name: model.formRequisitionField,
                                  decoration: InputDecoration(
                                    labelText: 'Requisition',
                                  ),
                                  hint: Text('Requisition'),
                                  initialValue: 5,
                                  items: List<int>.generate(20, (i) => i)
                                      .map((i) => DropdownMenuItem(
                                          value: i, child: Text('$i')))
                                      .toList()),
                            ),
                            SizedBox(
                              width: screenWidthPercentage(context,
                                  percentage: .3),
                              child: FormBuilderDropdown(
                                  name: model.formSupplyLimitField,
                                  decoration: InputDecoration(
                                    labelText: 'Supply Limit',
                                  ),
                                  hint: Text('Supply Limit'),
                                  initialValue: 50,
                                  items: List<int>.generate(150, (i) => i + 50)
                                      .map((i) => DropdownMenuItem(
                                          value: i, child: Text('$i')))
                                      .toList()),
                            ),
                            SizedBox(
                              width: screenWidthPercentage(context,
                                  percentage: .3),
                              child: FormBuilderDropdown(
                                  name: model.formSupplyUsedField,
                                  decoration: InputDecoration(
                                    labelText: 'Supply Used',
                                  ),
                                  hint: Text('Supply Used'),
                                  initialValue: 0,
                                  items: List<int>.generate(50, (i) => i)
                                      .map((i) => DropdownMenuItem(
                                          value: i, child: Text('$i')))
                                      .toList()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              VerticalSpace.small,
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: kcPrimaryColor),
                child: Text('Create Crusade'),
                onPressed: model.createCrusade,
              )
            ],
          ),
        ),
      ),
    );
  }
}
