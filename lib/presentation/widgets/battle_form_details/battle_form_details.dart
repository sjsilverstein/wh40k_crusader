import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/battle_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/styles.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/add_battle_view/add_battle_view_model.dart';

class BattleFormDetails extends ViewModelWidget<AddBattleViewModel> {
  @override
  Widget build(BuildContext context, AddBattleViewModel model) {
    // TODO: implement build
    return Card(
      child: FormBuilder(
        key: model.formKey,
        child: Column(
          children: [
// Battle Date
            FormBuilderDateTimePicker(
              name: kBattleDate,
              initialValue: DateTime.now(),
              format: DateFormat('MM-dd-yyyy'),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              inputType: InputType.date,
              decoration: InputDecoration(labelText: 'Battle Date'),
              validator: FormBuilderValidators.required(context),
            ),
// required this.battleSize,
            FormBuilderDropdown(
                name: kBattleSize,
                validator: FormBuilderValidators.required(context),
                decoration: InputDecoration(
                  labelText: 'Battle Size',
                ),
                items: BattleDataModel.battleSizes
                    .map((size) =>
                        DropdownMenuItem(value: size, child: Text('$size')))
                    .toList()),
// required this.battlePowerLevel,
            SizedBox(
              width: screenWidthPercentage(context, percentage: .3),
              child: FormBuilderDropdown(
                  name: kBattlePowerLevel,
                  decoration: InputDecoration(
                    labelText: 'Your Army Power Level',
                  ),
                  initialValue: 50,
                  items: List<int>.generate(300, (i) => i)
                      .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
                      .toList()),
            ),
// required this.opponentName,
            FormBuilderTextField(
              name: kOpponentName,
              validator: FormBuilderValidators.required(context),
              decoration: InputDecoration(labelText: 'Opponent\'s Name'),
            ),
// required this.opponentFaction,
            FormBuilderDropdown(
                name: kOpponentFaction,
                validator: FormBuilderValidators.required(context),
                decoration: InputDecoration(
                  labelText: 'Opponent\'s Faction',
                ),
                items: CrusadeDataModel.factions
                    .map((faction) => DropdownMenuItem(
                        value: faction, child: Text('$faction')))
                    .toList()),
// required this.score,
            Row(
              children: [
                SizedBox(
                  width: screenWidthPercentage(context, percentage: .3),
                  child: FormBuilderTextField(
                    name: kScore,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.numeric(context)
                    ]),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Score'),
                  ),
                ),
                HorizontalSpace.medium,
                SizedBox(
                  width: screenWidthPercentage(context, percentage: .3),
                  child: FormBuilderTextField(
                    name: kOpponentScore,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.numeric(context)
                    ]),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Opponent\'s Score',
                    ),
                  ),
                ),
              ],
            ),
            FormBuilderTextField(
              name: kMission,
              decoration: InputDecoration(
                labelText: 'Mission',
              ),
              initialValue: '',
            ),
            FormBuilderTextField(
              name: kNotes,
              decoration: InputDecoration(
                labelText: 'Notes',
              ),
              initialValue: '',
              maxLines: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: kcPrimaryColor),
              child: Text('Select Army Roster'),
              onPressed: () {
                model.selectRoster();
              },
            ),
          ],
        ),
      ),
    );
  }
}
