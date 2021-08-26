import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/presentation/dialogs/basic_dialog.dart';

enum DialogType { Basic, AddCrusadeUnitAttribute }

void setupDialogUi() {
  DialogService dialogService = locator<DialogService>();

  final builders = {
    DialogType.Basic: (BuildContext context, DialogRequest request,
            Function(DialogResponse) completer) =>
        BasicDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
