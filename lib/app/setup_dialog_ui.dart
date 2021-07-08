import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/presentation/widgets/new_crusade_form_dialog/new_crusade_form_dialog.dart';

enum DialogType { newCrusadeForm }

void setupDialogUi() {
  DialogService dialogService = locator<DialogService>();

  final builders = {
    DialogType.newCrusadeForm: (context, sheetRequest, completer) =>
        NewCrusadeFormDialog(request: sheetRequest, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
