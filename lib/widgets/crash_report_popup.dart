import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexax/tools/private_mode_provider.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:indexax/tools/snackbar.dart';
import 'package:share_plus/share_plus.dart';

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
              'crash_report.title'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('crash_report.explanation'.tr()),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: Scrollbar(
                    controller: scrollController,
                    // Prevent the scrollbar from being draggable, so it doesn't interfere with the copy button. This doesn't work on iOS.
                    interactive: false,
                    thumbVisibility: true,
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
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(12, 20, 12, 0),
                        enabled: true,
                        border: const OutlineInputBorder(),
                        labelText: 'crash_report.error_log'.tr(),
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
                        icon: const Icon(Icons.copy),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () =>
                            copyToClipboard(context, errorLogController.text)),
                    IconButton(
                        visualDensity: VisualDensity.compact,
                        iconSize: 16,
                        icon: const Icon(Icons.share),
                        splashRadius: 20,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () =>
                            shareErrorLog(context, errorLogController.text)),
                  ],
                ),
                // Text("I will only receive what you see in the text box."),
              ],
            ), // Padding(
            contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(
                        'crash_report.not_now'.tr(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      onPressed: () {
                        quitApp();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'crash_report.send_by_email'.tr(),
                        style: TextStyle(
                            color: context
                                    .read<PrivateModeProvider>()
                                    .privateModeEnabled
                                ? Colors.grey
                                : null),
                      ),
                      onPressed: () =>
                          sendOverEmail(context, errorLogController.text),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

Future<void> copyToClipboard(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    showInSnackBar(context, 'crash_report.copied_to_clipboard'.tr());
  }
}

Future<void> shareErrorLog(BuildContext context, String text) async {
  await Share.share(text, subject: 'crash_report.email_subject'.tr());
}

void sendOverEmail(BuildContext context, String text) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'indexax@victormarino.com',
    queryParameters: {
      'subject': 'crash_report.email_subject'.tr(),
      'body': text
    },
  );
  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {
    if (context.mounted) {
      showInSnackBar(context, 'crash_report.could_not_email'.tr());
    }
  }
}

void quitApp() {
  if (Platform.isIOS) {
    exit(0);
  } else {
    SystemNavigator.pop();
  }
}
