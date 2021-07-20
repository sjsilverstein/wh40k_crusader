import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';

class UpdateCrusadeUnitRouteArgs {
  final CrusadeDataModel crusade;
  final CrusadeUnitDataModel unit;

  UpdateCrusadeUnitRouteArgs(this.crusade, this.unit);
}
