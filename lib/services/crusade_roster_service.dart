import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';

class CrusadeRosterService {
  static orderRoster(List<CrusadeUnitDataModel> roster) {
    List<CrusadeUnitDataModel> hqs = [];
    List<CrusadeUnitDataModel> elites = [];
    List<CrusadeUnitDataModel> troops = [];
    List<CrusadeUnitDataModel> transport = [];
    List<CrusadeUnitDataModel> fastAttack = [];
    List<CrusadeUnitDataModel> heavySupport = [];
    List<CrusadeUnitDataModel> flyer = [];
    List<CrusadeUnitDataModel> low = [];
    // Sort in Descending Experience Order
    roster.sort((b, a) => a.experience.compareTo(b.experience));

    roster.forEach((element) {
      if (element.battleFieldRole == CrusadeUnitDataModel.battleFieldRoles[0]) {
        hqs.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[1]) {
        elites.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[2]) {
        troops.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[3]) {
        transport.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[4]) {
        fastAttack.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[5]) {
        heavySupport.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[6]) {
        flyer.add(element);
      } else if (element.battleFieldRole ==
          CrusadeUnitDataModel.battleFieldRoles[7]) {
        low.add(element);
      } else {
        logger.wtf("We have a unit with an unknown battlefield role");
      }
    });

    roster.clear();
    hqs.forEach((element) => roster.add(element));
    elites.forEach((element) => roster.add(element));
    troops.forEach((element) => roster.add(element));
    transport.forEach((element) => roster.add(element));
    fastAttack.forEach((element) => roster.add(element));
    heavySupport.forEach((element) => roster.add(element));
    flyer.forEach((element) => roster.add(element));
    low.forEach((element) => roster.add(element));
  }
}
