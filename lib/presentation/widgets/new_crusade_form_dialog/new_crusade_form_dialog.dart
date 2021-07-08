import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';

class NewCrusadeFormDialogModel extends BaseViewModel {
  final formKey = GlobalKey<FormBuilderState>();
  final NavigationService _navigationService = locator<NavigationService>();
  final String formNameField = kName;
  final String formFactionField = kFaction;
  final String formBattleTallyField = kBattleTally;
  final String formRequisitionField = kRequisition;
  final String formSupplyLimitField = kSupplyLimit;
  final String formSupplyUsedField = kSupplyUsed;
  final String formVictoriesField = kVictories;
  final List<int> valueRange = kCrusadeFormValueRange;

  String get name => formKey.currentState!.fields[formNameField]!.value;
  String get faction => formKey.currentState!.fields[formFactionField]!.value;

  pop() {
    _navigationService.back();
  }
}

class NewCrusadeFormDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const NewCrusadeFormDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewCrusadeFormDialogModel>.reactive(
      viewModelBuilder: () => NewCrusadeFormDialogModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('New Crusade'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
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
                            width:
                                screenWidthPercentage(context, percentage: .3),
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
                            width:
                                screenWidthPercentage(context, percentage: .3),
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
                            width:
                                screenWidthPercentage(context, percentage: .3),
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
                            width:
                                screenWidthPercentage(context, percentage: .3),
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
                            width:
                                screenWidthPercentage(context, percentage: .3),
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
              ElevatedButton(onPressed: () {}, child: Text('Create Crusade'))
            ],
          ),
        ),
      ),
    );
  }
}
