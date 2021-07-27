import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/battle_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/styles.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/add_battle_view/add_battle_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battlefield_role_icon/battlefield_role_icon.dart';

class AddBattleView extends StatelessWidget {
  final CrusadeDataModel crusade;

  AddBattleView(this.crusade);

  _buildFormChildBaseOnModelState(AddBattleViewModel model) {
    switch (model.state) {
      case AddBattleViewModelState.initial:
        return BattleFormDetails();
      case AddBattleViewModelState.roster:
        return BattleFormRoster();
      case AddBattleViewModelState.honors:
        return SelectUnitsBattlePerformanceList();
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

class BattleFormRoster extends ViewModelWidget<AddBattleViewModel> {
  Widget _buildCrusadeRoster(BuildContext context, AddBattleViewModel model) {
    return FormBuilder(
      key: model.formKey,
      child: Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Crusade Roster'),
            model.dataMap?[kRosterStream] != null
                ? model.dataMap![kRosterStream].length != 0
                    ? SizedBox(
                        height: screenHeightPercentage(context, percentage: .9),
                        child: ListView.builder(
                          itemCount: model.dataMap?[kRosterStream].length,
                          itemBuilder: (context, index) => BattleUnitRosterCard(
                              model.dataMap?[kRosterStream][index]),
                        ),
                      )
                    : Container(
                        child: Text('No Units in Roster'),
                      )
                : Container(
                    child: Text('No Units in Roster'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBattleRoster(BuildContext context, AddBattleViewModel model) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('Battle Roster'),
          model.battleRoster.length != 0
              ? SizedBox(
                  height: screenHeightPercentage(context, percentage: .5),
                  child: ListView.builder(
                      itemCount: model.battleRoster.length,
                      itemBuilder: (context, index) =>
                          BattleRosterUnitCard(index)),
                )
              : Container(
                  child: Text('No Units in Roster'),
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, AddBattleViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        model.dataMap?[kRosterStream] != null
            ? model.dataMap![kRosterStream].length != 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCrusadeRoster(context, model),
                      _buildBattleRoster(context, model),
                    ],
                  )
                : Center(
                    child: Container(
                      child: Text(
                          'No Units in Roster, try adding units to the crusade.'),
                    ),
                  )
            : Container(),
      ],
    );
  }
}

class BattleRosterUnitCard extends ViewModelWidget<AddBattleViewModel> {
  final int index;
  BattleRosterUnitCard(this.index);

  @override
  Widget build(BuildContext context, AddBattleViewModel model) {
    CrusadeUnitDataModel unit = model.battleRoster[index];
    return Card(
      child: ListTile(
        title: Text('${unit.unitName} - ${unit.unitType}'),
        leading: BattleFieldRoleIcon(unit.battleFieldRole),
        subtitle: Row(
          children: [
            Text(
              unit.getRank(),
              style: TextStyle(
                color: GetColorFrom.unitRank(unit.getRank()),
              ),
            ),
            HorizontalSpace.small,
            Text('Exp: ${unit.experience}')
          ],
        ),
      ),
    );
  }
}

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

class SelectUnitsBattlePerformanceList
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
                itemBuilder: (context, index) => BattleUnitRosterHonoursCard(
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

class BattleUnitRosterCard extends ViewModelWidget<AddBattleViewModel> {
  final CrusadeUnitDataModel unit;

  BattleUnitRosterCard(this.unit);
  @override
  Widget build(BuildContext context, AddBattleViewModel model) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: FormBuilderCheckbox(
          name: 'addUnitToBattleRoster${unit.documentUID}',
          title: Text('${unit.unitName} - ${unit.unitType}'),
          subtitle: Text(unit.battleFieldRole),
          initialValue: false,
          tristate: false,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (value) {
            model.addUnitToBattleRoster(unit, value!);
          },
        ),
      ),
    );
  }
}

class BattleUnitRosterHonoursCard extends ViewModelWidget<AddBattleViewModel> {
  final CrusadeUnitDataModel unit;

  BattleUnitRosterHonoursCard(this.unit);
  @override
  Widget build(BuildContext context, AddBattleViewModel model) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: ExpansionTile(
          leading: BattleFieldRoleIcon(unit.battleFieldRole),
          title: model.markedForGreatnessUnitUID == unit.documentUID
              ? Text('${unit.unitName} - Marked for Greatness')
              : Text('${unit.unitName}'),
          subtitle: Text('${unit.unitType}'),
          children: [
            SizedBox(
              width: screenWidthPercentage(context, percentage: .4),
              child: FormBuilderDropdown(
                  name: '${unit.documentUID}unitsDestroyed',
                  decoration: InputDecoration(
                    labelText: 'Units Destroyed',
                  ),
                  initialValue: 0,
                  items: List<int>.generate(50, (i) => i)
                      .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
                      .toList()),
            ),
            SizedBox(
              width: screenWidthPercentage(context, percentage: .4),
              child: FormBuilderDropdown(
                  name: '${unit.documentUID}bonusXP',
                  decoration: InputDecoration(
                    labelText: 'Agenda XP / Bonus XP',
                  ),
                  initialValue: 0,
                  items: List<int>.generate(50, (i) => i)
                      .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
                      .toList()),
            ),
            SizedBox(
              width: screenWidthPercentage(context, percentage: .4),
              child: FormBuilderCheckbox(
                name: '${unit.documentUID}wasDestroyed',
                title: Text('Was Destroyed'),
                initialValue: false,
                tristate: false,
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: (value) {},
              ),
            ),
            SizedBox(
              width: screenWidthPercentage(context, percentage: .4),
              child: FormBuilderCheckbox(
                name: '${unit.documentUID}markedForGreatness',
                title: Text('Marked For Greatness '),
                initialValue: false,
                tristate: false,
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: (value) {
                  model.markedForGreatness(value!, unit.documentUID!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
