import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/styles.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/create_crusade_unit_view/create_crusade_unit_view_model.dart';

class CreateUnitView extends StatelessWidget {
  final CrusadeDataModel crusade;
  CreateUnitView(this.crusade);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateUnitViewModel>.reactive(
      viewModelBuilder: () => CreateUnitViewModel(crusade),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Create Unit View"),
        ),
        body: Container(
          child: Center(
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
                          // FormBuilderTextField(
                          //   name: model.formUnitTypeField,
                          //   validator: FormBuilderValidators.required(context),
                          //   decoration: InputDecoration(
                          //       labelText: 'Unit Type (ex. Warriors)'),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     SizedBox(
                          //       width: screenWidthPercentage(context,
                          //           percentage: .3),
                          //       child: FormBuilderDropdown(
                          //           name: model.formPowerRatingField,
                          //           decoration: InputDecoration(
                          //             labelText: 'Power Rating',
                          //           ),
                          //           hint: Text('Power Rating'),
                          //           initialValue: 0,
                          //           items: List<int>.generate(100, (i) => i)
                          //               .map((i) => DropdownMenuItem(
                          //                   value: i, child: Text('$i')))
                          //               .toList()),
                          //     ),
                          //     SizedBox(
                          //       width: screenWidthPercentage(context,
                          //           percentage: .3),
                          //       child: FormBuilderDropdown(
                          //           name: model.formExperienceField,
                          //           decoration: InputDecoration(
                          //             labelText: 'Experience',
                          //           ),
                          //           hint: Text('Experience'),
                          //           initialValue: 0,
                          //           items: List<int>.generate(100, (i) => i)
                          //               .map((i) => DropdownMenuItem(
                          //                   value: i, child: Text('$i')))
                          //               .toList()),
                          //     ),
                          //   ],
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     SizedBox(
                          //       width: screenWidthPercentage(context,
                          //           percentage: .3),
                          //       child: FormBuilderDropdown(
                          //           name: model.formBattlePlayedField,
                          //           decoration: InputDecoration(
                          //             labelText: 'Battles Played',
                          //           ),
                          //           hint: Text('Battles Played'),
                          //           initialValue: 0,
                          //           items: List<int>.generate(255, (i) => i)
                          //               .map((i) => DropdownMenuItem(
                          //                   value: i, child: Text('$i')))
                          //               .toList()),
                          //     ),
                          //     SizedBox(
                          //       width: screenWidthPercentage(context,
                          //           percentage: .3),
                          //       child: FormBuilderDropdown(
                          //           name: model.formBattlesSurvivedField,
                          //           decoration: InputDecoration(
                          //             labelText: 'Battles Survived',
                          //           ),
                          //           hint: Text('Battles Survived'),
                          //           initialValue: 0,
                          //           items: List<int>.generate(255, (i) => i)
                          //               .map((i) => DropdownMenuItem(
                          //                   value: i, child: Text('$i')))
                          //               .toList()),
                          //     ),
                          //   ],
                          // ),
                          // Row(
                          //   children: [
                          //     FormBuilderTextField(
                          //       name: model.formEquipmentField,
                          //       validator:
                          //           FormBuilderValidators.required(context),
                          //       decoration:
                          //           InputDecoration(labelText: 'Equipment'),
                          //       initialValue: 'Default Equipment',
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
                VerticalSpace.small,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: kcPrimaryColor),
                  child: Text('Add Unit To Roster'),
                  onPressed: model.createUnitForCrusadeAndPop(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
