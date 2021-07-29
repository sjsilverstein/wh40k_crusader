import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/crusade_view/crusade_view_model.dart';

class EditCrusadeForm extends ViewModelWidget<CrusadeViewModel> {
  @override
  Widget build(BuildContext context, CrusadeViewModel model) {
    return Card(
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
              children: [],
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidthPercentage(context, percentage: .3),
                  child: FormBuilderTextField(
                    name: kRequisition,
                    validator: FormBuilderValidators.required(context),
                    decoration: InputDecoration(labelText: 'Requisition'),
                  ),
                ),
                SizedBox(
                  width: screenWidthPercentage(context, percentage: .3),
                  child: FormBuilderTextField(
                    name: kSupplyLimit,
                    validator: FormBuilderValidators.required(context),
                    decoration: InputDecoration(labelText: 'Supply Limit'),
                  ),
                ),
                SizedBox(
                  width: screenWidthPercentage(context, percentage: .3),
                  child: FormBuilderTextField(
                    name: kSupplyUsed,
                    validator: FormBuilderValidators.required(context),
                    decoration: InputDecoration(labelText: 'Supply Used'),
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
    );
  }
}
