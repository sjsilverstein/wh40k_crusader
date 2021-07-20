import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/styles.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/update_crusade_unit_view/update_crusade_unit_view_model.dart';

class UpdateCrusadeUnitView extends StatelessWidget {
  final CrusadeDataModel crusade;
  final CrusadeUnitDataModel unit;

  UpdateCrusadeUnitView({
    required this.crusade,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateCrusadeUnitViewModel>.reactive(
      viewModelBuilder: () => UpdateCrusadeUnitViewModel(crusade, unit),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Update : ${model.unit.unitName}'),
        ),
        body: Center(
          child: Card(
            child: FormBuilder(
              key: model.formKey,
              initialValue: {
                model.formNameField: model.unit.unitName,
                model.formUnitTypeField: model.unit.unitType,
                model.formPowerRatingField: model.unit.powerRating,
                model.formBattlePlayedField: model.unit.battlesPlayed,
                model.formBattlesSurvivedField: model.unit.battlesSurvived,
                model.formExperienceField: model.unit.experience,
                model.formBattlesSurvivedField: model.unit.battlesSurvived,
                model.formBattleFieldRoleField: model.unit.battleFieldRole,
                model.formEquipmentField: model.unit.equipment,
              },
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: kName,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  FormBuilderTextField(
                    name: model.formUnitTypeField,
                    validator: FormBuilderValidators.required(context),
                    decoration:
                        InputDecoration(labelText: 'Unit Type (ex. Warriors)'),
                  ),
                  FormBuilderDropdown(
                      name: model.formBattleFieldRoleField,
                      decoration: InputDecoration(
                        labelText: 'Battle Field Role',
                      ),
                      hint: Text('Select Role'),
                      items: CrusadeUnitDataModel.battleFieldRoles
                          .map((faction) => DropdownMenuItem(
                              value: faction, child: Text('$faction')))
                          .toList()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: screenWidthPercentage(context, percentage: .3),
                        child: FormBuilderDropdown(
                            name: model.formPowerRatingField,
                            decoration: InputDecoration(
                              labelText: 'Power Rating',
                            ),
                            hint: Text('Power Rating'),
                            items: List<int>.generate(100, (i) => i)
                                .map((i) => DropdownMenuItem(
                                    value: i, child: Text('$i')))
                                .toList()),
                      ),
                      SizedBox(
                        width: screenWidthPercentage(context, percentage: .3),
                        child: FormBuilderDropdown(
                            name: model.formExperienceField,
                            decoration: InputDecoration(
                              labelText: 'Experience',
                            ),
                            hint: Text('Experience'),
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
                        width: screenWidthPercentage(context, percentage: .3),
                        child: FormBuilderDropdown(
                            name: model.formBattlePlayedField,
                            decoration: InputDecoration(
                              labelText: 'Battles Played',
                            ),
                            hint: Text('Battles Played'),
                            items: List<int>.generate(255, (i) => i)
                                .map((i) => DropdownMenuItem(
                                    value: i, child: Text('$i')))
                                .toList()),
                      ),
                      SizedBox(
                        width: screenWidthPercentage(context, percentage: .3),
                        child: FormBuilderDropdown(
                            name: model.formBattlesSurvivedField,
                            decoration: InputDecoration(
                              labelText: 'Battles Survived',
                            ),
                            hint: Text('Battles Survived'),
                            items: List<int>.generate(255, (i) => i)
                                .map((i) => DropdownMenuItem(
                                    value: i, child: Text('$i')))
                                .toList()),
                      ),
                    ],
                  ),
                  FormBuilderTextField(
                    name: model.formEquipmentField,
                    validator: FormBuilderValidators.required(context),
                    decoration: InputDecoration(labelText: 'Equipment'),
                  ),
                  VerticalSpace.small,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: kcPrimaryColor),
                    child: Text('Update Unit'),
                    onPressed: () async {
                      await model.updateUnitWithNewValuesAndPop();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
