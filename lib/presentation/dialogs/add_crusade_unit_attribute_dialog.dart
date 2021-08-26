import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';

class AddCrusadeUnitAttributeDialog extends StatefulWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const AddCrusadeUnitAttributeDialog(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  _AddCrusadeUnitAttributeDialogState createState() =>
      _AddCrusadeUnitAttributeDialogState();
}

class _AddCrusadeUnitAttributeDialogState
    extends State<AddCrusadeUnitAttributeDialog> {
  TextEditingController _attributeTitleController = TextEditingController();
  TextEditingController _attributeDescriptionController =
      TextEditingController();

  DialogResponse? response;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidthPercentage(context, percentage: .04),
      ),
      padding: EdgeInsets.only(top: 32, left: 16, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VerticalSpace.small,
          Text('Custom Form'),
          Text('${widget.request.title ?? 'No Title Provided'}'),
          VerticalSpace.small,
          Text('${widget.request.description ?? 'No Description Provided'}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (widget.request.secondaryButtonTitle != null)
                TextButton(
                  onPressed: () =>
                      widget.completer(DialogResponse(confirmed: false)),
                  child: Text(widget.request.secondaryButtonTitle!),
                ),
              TextButton(
                onPressed: () =>
                    widget.completer(DialogResponse(confirmed: true)),
                child: Text(
                    widget.request.mainButtonTitle ?? 'No Main Button Title'),
              )
            ],
          )
        ],
      ),
    ));
  }
}
