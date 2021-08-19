import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/battle_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_battle_performance_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/presentation/views/update_battle_and_unit_performance_view/update_battle_and_unit_performance_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battlefield_role_icon/battlefield_role_icon.dart';
import 'package:wh40k_crusader/presentation/widgets/faction_icon/faction_icon.dart';

class UpdateBattleAndUnitPerformanceView extends StatelessWidget {
  final CrusadeDataModel crusade;
  final BattleDataModel battle;
  final List<CrusadeUnitDataModel> roster;

  UpdateBattleAndUnitPerformanceView({
    required this.crusade,
    required this.battle,
    required this.roster,
  });

  Widget _buildBattleDetailsForm(
      BuildContext context, UpdateBattleAndUnitPerformanceViewModel model) {
    String battleResult;
    Color color;

    if (battle.score > battle.opponentScore) {
      battleResult = 'Victory';
      color = Colors.green;
    } else if (battle.score != battle.opponentScore) {
      battleResult = 'Defeat';
      color = Colors.red;
    } else {
      battleResult = 'Draw';
      color = Colors.white;
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: FactionIcon(battle.opponentFaction),
            title: Text(
                '${model.battle.opponentName} - ${model.battle.opponentFaction}'),
            subtitle: Text(
              battleResult,
              style: TextStyle(color: color),
            ),
          ),
          FormBuilderTextField(
            name: kOpponentName,
            initialValue: battle.opponentName,
            decoration: InputDecoration(labelText: 'Opp Name'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
            ]),
          ),
          FormBuilderDropdown(
              name: kOpponentFaction,
              validator: FormBuilderValidators.required(context),
              initialValue: battle.opponentFaction,
              decoration: InputDecoration(
                labelText: 'Opponent\'s Faction',
              ),
              items: CrusadeDataModel.factions
                  .map((faction) =>
                      DropdownMenuItem(value: faction, child: Text('$faction')))
                  .toList()),
          FormBuilderDropdown(
            name: kBattleSize,
            validator: FormBuilderValidators.required(context),
            initialValue: battle.battleSize,
            decoration: InputDecoration(
              labelText: 'Battle Size',
            ),
            items: BattleDataModel.battleSizes
                .map((size) =>
                    DropdownMenuItem(value: size, child: Text('$size')))
                .toList(),
          ),
          FormBuilderDropdown(
            name: kBattlePowerLevel,
            decoration: InputDecoration(
              labelText: 'Your Army Power Level',
            ),
            initialValue: battle.battlePowerLevel,
            items: List<int>.generate(300, (i) => i)
                .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
                .toList(),
          ),
          FormBuilderTextField(
            name: kScore,
            initialValue: battle.score.toString(),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
              FormBuilderValidators.numeric(context)
            ]),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Score'),
          ),
          FormBuilderTextField(
            name: kOpponentScore,
            initialValue: battle.opponentScore.toString(),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
              FormBuilderValidators.numeric(context)
            ]),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Opp Score'),
          ),
          FormBuilderTextField(
            name: kMission,
            decoration: InputDecoration(
              labelText: 'Mission',
            ),
            initialValue: battle.mission,
          ),
          FormBuilderTextField(
            name: kNotes,
            decoration: InputDecoration(
              labelText: 'Notes',
            ),
            initialValue: battle.notes,
            maxLines: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildUnitPerformanceCards(
      BuildContext context, UpdateBattleAndUnitPerformanceViewModel model) {
    return Column(
      children: model.unitPerformanceList != null
          ? model.unitPerformanceList!.map((e) {
              if (model.currentRoster.indexWhere(
                      (element) => element.documentUID == e.documentUID) ==
                  -1) {
                return _UnitNoLongerExistCard(e);
              }
              return _CurrentUnitPerformanceFormCard(
                model.currentRoster.firstWhere(
                    (element) => element.documentUID == e.documentUID),
                e,
              );
            }).toList()
          : [
              Text('No Battle Performance Data'),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateBattleAndUnitPerformanceViewModel>.reactive(
      viewModelBuilder: () =>
          UpdateBattleAndUnitPerformanceViewModel(crusade, battle, roster),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('${model.crusade.name} Update Battle'),
        ),
        body: FormBuilder(
          key: model.formKey,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildBattleDetailsForm(context, model),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildUnitPerformanceCards(context, model),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () async {
            await model.validateAndSubmit();
          },
        ),
      ),
    );
  }
}

class _UnitNoLongerExistCard extends StatelessWidget {
  final CrusadeUnitBattlePerformanceDataModel performance;

  _UnitNoLongerExistCard(this.performance);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.warning),
        title: Text(
          'This unit no longer exists!',
          style: TextStyle(color: Colors.red),
        ),
        children: [
          Text('United Destroyed: ${performance.unitsDestroyed}'),
          Text('Bonus XP: ${performance.bonusXP}'),
          Text('Was Destroyed: ${performance.wasDestroyed}'),
          Text('Marked For Greatness: ${performance.markedForGreatness}'),
        ],
      ),
    );
  }
}

class _CurrentUnitPerformanceFormCard
    extends ViewModelWidget<UpdateBattleAndUnitPerformanceViewModel> {
  final CrusadeUnitBattlePerformanceDataModel performance;
  final CrusadeUnitDataModel unit;

  _CurrentUnitPerformanceFormCard(this.unit, this.performance);

  @override
  Widget build(
      BuildContext context, UpdateBattleAndUnitPerformanceViewModel model) {
    // TODO: implement build
    return Card(
      child: ExpansionTile(
        leading: BattleFieldRoleIcon(unit.battleFieldRole),
        title: Text('${unit.unitName}'),
        subtitle: Text(unit.unitType),
        children: [
          FormBuilderTextField(
            name: '${performance.documentUID}$kUnitsDestroyed',
            decoration: InputDecoration(labelText: 'Units Destroyed'),
            initialValue: performance.unitsDestroyed.toString(),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.numeric(context),
              FormBuilderValidators.required(context),
            ]),
          ),
          FormBuilderTextField(
            name: '${performance.documentUID}$kBonusXP',
            decoration: InputDecoration(labelText: 'Bonus XP'),
            initialValue: performance.bonusXP.toString(),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.numeric(context),
              FormBuilderValidators.required(context),
            ]),
          ),
          FormBuilderCheckbox(
            name: '${performance.documentUID}$kWasDestroyed',
            title: Text('Was Destroyed'),
            initialValue: performance.wasDestroyed,
            tristate: false,
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: (value) {},
          ),
          model.unitIsMarkedForGreatness == true
              ? performance.documentUID == model.unitUIDIsMarkedForGreatness
                  ? FormBuilderCheckbox(
                      name: '${performance.documentUID}$kMarkedForGreatness',
                      title: Text('Marked For Greatness'),
                      initialValue: performance.markedForGreatness,
                      tristate: false,
                      controlAffinity: ListTileControlAffinity.trailing,
                      onChanged: (value) {
                        model.changeMarkedForGreatness(
                            value!, performance.documentUID!);
                      },
                    )
                  : Container(
                      child: Text('Another Unit is MarkedForGreatness'),
                    )
              : FormBuilderCheckbox(
                  name: '${performance.documentUID}$kMarkedForGreatness',
                  title: Text('Marked For Greatness'),
                  initialValue: performance.markedForGreatness,
                  tristate: false,
                  controlAffinity: ListTileControlAffinity.trailing,
                  onChanged: (value) {
                    model.changeMarkedForGreatness(
                        value!, performance.documentUID!);
                  },
                ),
        ],
      ),
    );
  }
}
