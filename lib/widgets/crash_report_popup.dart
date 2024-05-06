import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/private_mode_provider.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Pop-up window shown when the app crashes
// Shows information about the error and the option to share it outside the app

showCrashReport(BuildContext context, String errorMessage, String stack) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Theme.of(context).colorScheme.background,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Crash report",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Oops. It looks like the app had a problem."),
                      Text("Error message:"),
                      Text(errorMessage),
                      Text("Stack trace:"),
                      Text(stack),
                      Text(
                          "If you want to help me solve this issue, please share this crash report with me!"),
                    ]),
              ),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text(
                    'Not now',
                    style: TextStyle(
                        color:
                            context.read<PrivateModeProvider>().privateModeEnabled
                                ? Colors.grey
                                : null),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Row(
                  children: [
                    TextButton(
                      child: Text(
                        'Copy',
                        style: TextStyle(
                            color:
                                context.read<PrivateModeProvider>().privateModeEnabled
                                    ? Colors.grey
                                    : null),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Share',
                        style: TextStyle(
                            color:
                                context.read<PrivateModeProvider>().privateModeEnabled
                                    ? Colors.grey
                                    : null),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            )
          ],
        );
      });
}
