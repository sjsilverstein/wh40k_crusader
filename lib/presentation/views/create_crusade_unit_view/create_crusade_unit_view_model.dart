import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/app/setup_dialog_ui.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/services/firestore_service.dart';

class CreateUnitViewModel extends BaseViewModel {
  final FirestoreService _db = locator<FirestoreService>();

  final NavigationService _navigationService = locator<NavigationService>();

  final formKey = GlobalKey<FormBuilderState>();
  final _dialogService = locator<DialogService>();

  final String formNameField = kName;
  final String formBattleFieldRoleField = kBattleFieldRole;
  final String formUnitTypeField = kUnitType;
  final String formPowerRatingField = kPowerRating;
  final String formExperienceField = kExperience;
  final String formBattlePlayedField = kBattlesPlayed;
  final String formBattlesSurvivedField = kBattlesSurvived;
  final String formEquipmentField = kEquipment;

  List<Power> _unitPowers = [];
  List<Power> get unitPowers => List.unmodifiable(_unitPowers);

  List<WarlordTrait> _warlordTraits = [];
  List<WarlordTrait> get warlordTraits => List.unmodifiable(_warlordTraits);

  List<Relic> _relics = [];
  List<Relic> get relics => List.unmodifiable(_relics);

  List<BattleHonor> _battleHonors = [];
  List<BattleHonor> get battleHonors => List.unmodifiable(_battleHonors);

  List<BattleScar> _battleScars = [];
  List<BattleScar> get battleScars => List.unmodifiable(_battleScars);

  String get name => formKey.currentState!.fields[formNameField]!.value;

  CrusadeDataModel _crusade;
  CrusadeDataModel get crusade => _crusade;

  CreateUnitViewModel(this._crusade);
  createUnitForCrusadeAndPop() async {
    if (formKey.currentState!.saveAndValidate()) {
      CrusadeUnitDataModel genericUnit = CrusadeUnitDataModel(
        unitName: formKey.currentState!.fields[formNameField]!.value,
        battleFieldRole:
            formKey.currentState!.fields[formBattleFieldRoleField]!.value,
        crusadeFaction: crusade.faction,
        unitType: formKey.currentState!.fields[formUnitTypeField]!.value,
        powerRating: formKey.currentState!.fields[formPowerRatingField]!.value,
        experience: formKey.currentState!.fields[formExperienceField]!.value,
        battlesPlayed:
            formKey.currentState!.fields[formBattlePlayedField]!.value,
        battlesSurvived:
            formKey.currentState!.fields[formBattlesSurvivedField]!.value,
        battleHonors: _battleHonors,
        battleScars: _battleScars,
        psychicPowers: _unitPowers,
        warlordTraits: _warlordTraits,
        relics: _relics,
        equipment: formKey.currentState!.fields[formEquipmentField]!.value,
      );

      await _db.addUnitToCrusadeRoster(crusade, genericUnit);

      // after complete update the view with new crusade values and roster units available.
      // Update the generic unit to a form which adds the unit to the crusade.
      pop();
    }
  }

  unitPowersRemoveIndex(int index) {
    _unitPowers.removeAt(index);
    notifyListeners();
  }

  unitWarlordTraitsRemoveIndex(int index) {
    _warlordTraits.removeAt(index);
    notifyListeners();
  }

  createBasicDialog() async {
    DialogResponse? response = await _dialogService.showCustomDialog(
      variant: DialogType.AddCrusadeUnitAttribute,
      title: 'Some Tittle',
      description: 'Some Description',
      mainButtonTitle: 'Main Button Title',
      secondaryButtonTitle: 'Secondary Button',
    );

    if (response != null) {
      logger.wtf('We have Dialog Response! Value : ${response.confirmed}');
    }
  }

  addPowerAttribute() async {
    DialogResponse? response = await _dialogService.showCustomDialog(
      variant: DialogType.AddCrusadeUnitAttribute,
      title: 'New Unit Power',
      description: 'Some Description',
      mainButtonTitle: 'Add Power',
      secondaryButtonTitle: 'Cancel',
    );

    if (response != null) {
      logger.wtf('We have Dialog Response! Value : ${response.confirmed}');
      if (response.confirmed) {
        _unitPowers.add(Power.fromJson(response.data));
      }
    }
    notifyListeners();
  }

  addWarlordTraitAttribute() async {
    DialogResponse? response = await _dialogService.showCustomDialog(
      variant: DialogType.AddCrusadeUnitAttribute,
      title: 'New Warlord Trait',
      description: 'Some Description',
      mainButtonTitle: 'Add Warlord Trait',
      secondaryButtonTitle: 'Cancel',
    );

    if (response != null) {
      logger.wtf('We have Dialog Response! Value : ${response.confirmed}');
      if (response.confirmed) {
        _warlordTraits.add(WarlordTrait.fromJson(response.data));
      }
    }
    notifyListeners();
  }

  pop() {
    _navigationService.back();
  }
}
