import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

class UpdateCrusadeUnitViewModel extends BaseViewModel {
  final _db = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final formKey = GlobalKey<FormBuilderState>();

  final String formNameField = kName;
  final String formBattleFieldRoleField = kBattleFieldRole;
  final String formUnitTypeField = kUnitType;
  final String formPowerRatingField = kPowerRating;
  final String formExperienceField = kExperience;
  final String formBattlePlayedField = kBattlesPlayed;
  final String formBattlesSurvivedField = kBattlesSurvived;
  final String formEquipmentField = kEquipment;

  CrusadeDataModel crusade;
  CrusadeUnitDataModel unit;

  UpdateCrusadeUnitViewModel(this.crusade, this.unit);

  updateUnitWithNewValuesAndPop() async {
    int unitPowerRatingDif;

    CrusadeUnitDataModel updatedUnit;

    updatedUnit = unit.copyWith(
      unitName: formKey.currentState!.fields[formNameField]!.value,
      battleFieldRole:
          formKey.currentState!.fields[formBattleFieldRoleField]!.value,
      unitType: formKey.currentState!.fields[formUnitTypeField]!.value,
      powerRating: formKey.currentState!.fields[formPowerRatingField]!.value,
      experience: formKey.currentState!.fields[formExperienceField]!.value,
      battlesPlayed: formKey.currentState!.fields[formBattlePlayedField]!.value,
      battlesSurvived:
          formKey.currentState!.fields[formBattlesSurvivedField]!.value,
      equipment: formKey.currentState!.fields[formEquipmentField]!.value,
    );

    unitPowerRatingDif = unit.powerRating - updatedUnit.powerRating;
    CrusadeDataModel updatedCrusadeValue = crusade.copyWith(
      supplyUsed: (crusade.supplyUsed - unitPowerRatingDif),
    );

    await _db.updateCrusadeUnit(
        crusade: updatedCrusadeValue, unit: updatedUnit);

    _navigationService.back();
  }
}
