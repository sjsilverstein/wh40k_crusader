import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
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
          child: SingleChildScrollView(
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
                          FormBuilderTextField(
                            name: model.formUnitTypeField,
                            validator: FormBuilderValidators.required(context),
                            decoration: InputDecoration(
                                labelText: 'Unit Type (ex. Warriors)'),
                          ),
                          FormBuilderDropdown(
                              name: model.formBattleFieldRoleField,
                              validator:
                                  FormBuilderValidators.required(context),
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
                                width: screenWidthPercentage(context,
                                    percentage: .3),
                                child: FormBuilderDropdown(
                                    name: model.formPowerRatingField,
                                    decoration: InputDecoration(
                                      labelText: 'Power Rating',
                                    ),
                                    hint: Text('Power Rating'),
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
                                    name: model.formExperienceField,
                                    decoration: InputDecoration(
                                      labelText: 'Experience',
                                    ),
                                    hint: Text('Experience'),
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
                                    name: model.formBattlePlayedField,
                                    decoration: InputDecoration(
                                      labelText: 'Battles Played',
                                    ),
                                    hint: Text('Battles Played'),
                                    initialValue: 0,
                                    items: List<int>.generate(255, (i) => i)
                                        .map((i) => DropdownMenuItem(
                                            value: i, child: Text('$i')))
                                        .toList()),
                              ),
                              SizedBox(
                                width: screenWidthPercentage(context,
                                    percentage: .3),
                                child: FormBuilderDropdown(
                                    name: model.formBattlesSurvivedField,
                                    decoration: InputDecoration(
                                      labelText: 'Battles Survived',
                                    ),
                                    hint: Text('Battles Survived'),
                                    initialValue: 0,
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
                            initialValue: 'Default Equipment',
                          ),
                          // TODO Massive refactor out list tiles to widget
                          ListTile(
                            title: Text('Powers'),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kcPrimaryColor),
                              child: Icon(Icons.add),
                              onPressed: () async {
                                await model.addPowerAttribute();
                              },
                            ),
                            subtitle: Column(
                              children: [
                                ListView.builder(
                                  itemCount: model.unitPowers.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      subtitle: Text(
                                          'Title: ${model.unitPowers[index].title} Description: ${model.unitPowers[index].description}'),
                                      trailing: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: kcWarningColor),
                                        child: Icon(Icons.remove),
                                        onPressed: () {
                                          model.unitPowersRemoveIndex(index);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Text('Warlord Traits'),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kcPrimaryColor),
                              child: Icon(Icons.add),
                              onPressed: () async {
                                await model.addWarlordTraitAttribute();
                              },
                            ),
                            subtitle: Column(
                              children: [
                                ListView.builder(
                                  itemCount: model.warlordTraits.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      subtitle: Text(
                                          'Title: ${model.warlordTraits[index].title} Description: ${model.warlordTraits[index].description}'),
                                      trailing: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: kcWarningColor),
                                        child: Icon(Icons.remove),
                                        onPressed: () {
                                          model.unitWarlordTraitsRemoveIndex(
                                              index);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Text('Relics'),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kcPrimaryColor),
                              child: Icon(Icons.add),
                              onPressed: () async {
                                await model.addRelicAttribute();
                              },
                            ),
                            subtitle: Column(
                              children: [
                                ListView.builder(
                                  itemCount: model.relics.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      subtitle: Text(
                                          'Title: ${model.relics[index].title} Description: ${model.relics[index].description}'),
                                      trailing: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: kcWarningColor),
                                        child: Icon(Icons.remove),
                                        onPressed: () {
                                          model.unitRelicRemoveByIndex(index);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ListTile(
                            title: Text('Battle Honor'),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kcPrimaryColor),
                              child: Icon(Icons.add),
                              onPressed: () async {
                                await model.addBattleHonorAttribute();
                              },
                            ),
                            subtitle: Column(
                              children: [
                                ListView.builder(
                                  itemCount: model.battleHonors.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      subtitle: Text(
                                          'Title: ${model.battleHonors[index].title} Description: ${model.battleHonors[index].description}'),
                                      trailing: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: kcWarningColor),
                                        child: Icon(Icons.remove),
                                        onPressed: () {
                                          model.unitBattleHonorRemoveByIndex(
                                              index);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Text('Battle Scar'),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kcPrimaryColor),
                              child: Icon(Icons.add),
                              onPressed: () async {
                                await model.addBattleScarAttribute();
                              },
                            ),
                            subtitle: Column(
                              children: [
                                ListView.builder(
                                  itemCount: model.battleScars.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      subtitle: Text(
                                          'Title: ${model.battleScars[index].title} Description: ${model.battleScars[index].description}'),
                                      trailing: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: kcWarningColor),
                                        child: Icon(Icons.remove),
                                        onPressed: () {
                                          model.unitBattleScarRemoveByIndex(
                                              index);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                VerticalSpace.small,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: kcPrimaryColor),
                  child: Text('Add Unit To Roster'),
                  onPressed: model.createUnitForCrusadeAndPop,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
