import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';

class NewCrusadeFormDialogModel extends BaseViewModel {
  final formKey = GlobalKey<FormBuilderState>();
  final NavigationService _navigationService = locator<NavigationService>();
  final String formNameField = 'name';
  final String formFactionField = 'faction';

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
        body: FormBuilder(
          key: model.formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            children: [
              FormBuilderDropdown(
                  name: model.formFactionField,
                  items: CrusadeDataModel.factions
                      .map((faction) => DropdownMenuItem(
                          value: faction, child: Text('$faction')))
                      .toList()),
            ],
          ),
        ),
      ),
    );
  }
}
