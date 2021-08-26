import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';

class BasicDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const BasicDialog({Key? key, required this.request, required this.completer})
      : super(key: key);

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
          Text('${request.title ?? 'No Title Provided'}'),
          VerticalSpace.small,
          Text('${request.description ?? 'No Description Provided'}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (request.secondaryButtonTitle != null)
                TextButton(
                  onPressed: () => completer(DialogResponse(confirmed: false)),
                  child: Text(request.secondaryButtonTitle!),
                ),
              TextButton(
                onPressed: () => completer(DialogResponse(confirmed: true)),
                child: Text(request.mainButtonTitle ?? 'No Main Button Title'),
              )
            ],
          )
        ],
      ),
    ));
  }
}
