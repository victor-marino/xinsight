import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexax/tools/private_mode_provider.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:indexax/tools/snackbar.dart';

// Pop-up window shown when the app crashes
// Shows information about the error and the option to share it outside the app

showCrashReport(BuildContext context, String errorMessage, String stack) {
  final errorLogController = TextEditingController();
  errorLogController.text = "$errorMessage\n\n$stack";
  ScrollController scrollController = ScrollController();
  return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Theme.of(context).colorScheme.background,
      builder: (BuildContext context) {
        return Scaffold(
          body: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "Crash report",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    "Oops! Looks like there was a problem.\n\nIf you want me to fix this issue, please share the error log with me."),
                SizedBox(height: 20),
                Container(
                  height: 300,
                  child: Scrollbar(
                    controller: scrollController,
                    // Prevent the scrollbar from being draggable, so it doesn't interfere with the copy button. This doesn't work on iOS.
                    interactive: false,
                    // Auto-hide the scrollbar on iOS, as otherwise it remains draggable and interferes with the copy button.
                    thumbVisibility: !Platform.isIOS,
                    child: TextFormField(
                      // scrollPhysics: AlwaysScrollableScrollPhysics(),
                      readOnly: true,
                      enableInteractiveSelection: false,
                      maxLines: null,
                      scrollPadding: EdgeInsets.zero,
                      controller: errorLogController,
                      scrollController: scrollController,
                      style: text_styles.ubuntuMono(context, 16),
                      decoration: InputDecoration(
                        // suffixIcon: Align(
                        //   alignment: Alignment.topRight,
                        //   widthFactor: 1,
                        //   child: IconButton(
                        //       visualDensity: VisualDensity.compact,
                        //       iconSize: 16,
                        //       splashRadius: 20,
                        //       icon: Icon(Icons.copy,
                        //           color: Theme.of(context).colorScheme.primary),
                        //       onPressed: () => copyToClipboard(
                        //           context, errorLogController.text)),
                        // ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 0),
                        enabled: true,
                        border: const OutlineInputBorder(),
                        labelText: "Error log",
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        visualDensity: VisualDensity.compact,
                        iconSize: 16,
                        splashRadius: 20,
                        icon: Icon(Icons.copy),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () =>
                            copyToClipboard(context, errorLogController.text)),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      iconSize: 16,
                      icon: Icon(Icons.share),
                      splashRadius: 20,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () => showInSnackBar(context, "Sharing..."),
                    ),
                  ],
                ),
                Text("I will only receive what you see in the text box."),
              ],
            ), // Padding(
            contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      'Not now',
                      style: TextStyle(
                          color: context
                                  .read<PrivateModeProvider>()
                                  .privateModeEnabled
                              ? Colors.grey
                              : null),
                    ),
                    onPressed: () {
                      quitApp();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Share',
                      style: TextStyle(
                          color: context
                                  .read<PrivateModeProvider>()
                                  .privateModeEnabled
                              ? Colors.grey
                              : null),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        );
      });
}

Future<void> copyToClipboard(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  showInSnackBar(context, "Text copied to clipboard");
}

void quitApp() {
  if (Platform.isIOS) {
    exit(0);
  } else {
    SystemNavigator.pop();
  }
}
