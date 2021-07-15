import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

class CreateCrusadeViewModel extends BaseViewModel {
  final FirebaseAuthenicationService _authentication =
      locator<FirebaseAuthenicationService>();
  final FirestoreService _db = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final formKey = GlobalKey<FormBuilderState>();
  final String formNameField = kName;
  final String formFactionField = kFaction;
  final String formBattleTallyField = kBattleTally;
  final String formRequisitionField = kRequisition;
  final String formSupplyLimitField = kSupplyLimit;
  final String formSupplyUsedField = kSupplyUsed;
  final String formVictoriesField = kVictories;

  String get name => formKey.currentState!.fields[formNameField]!.value;
  String get faction => formKey.currentState!.fields[formFactionField]!.value;

  createCrusade() async {
    CrusadeDataModel crusade = CrusadeDataModel(
      userUID: _authentication.currentUser!.uid,
      name: formKey.currentState!.fields[formNameField]!.value,
      faction: formKey.currentState!.fields[formFactionField]!.value,
      requisition: formKey.currentState!.fields[formRequisitionField]!.value,
      supplyLimit: formKey.currentState!.fields[formSupplyLimitField]!.value,
      supplyUsed: formKey.currentState!.fields[formSupplyUsedField]!.value,
      battleTally: formKey.currentState!.fields[formBattleTallyField]!.value,
      victories: formKey.currentState!.fields[formVictoriesField]!.value,
    );

    await _db.createNewCrusade(crusade);
    pop();
  }

  pop() {
    _navigationService.back();
  }
}
