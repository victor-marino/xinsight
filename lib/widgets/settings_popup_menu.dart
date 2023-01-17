import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/screens/settings_screen.dart';
import 'package:indexax/tools/text_styles.dart' as text_styles;
import 'package:indexax/widgets/settings_screen/logout_popup.dart';

// Pop-up menu that dropws down when clicking the settings wheel.
// Allows the user to:
// 1. Switch between accounts
// 2. Access the settings menu
// 3. Logout

class SettingsPopupMenu extends StatelessWidget {
  const SettingsPopupMenu(
      {Key? key,
      required this.userAccounts,
      required this.currentAccountIndex,
      required this.currentPage,
      required this.reloadPage})
      : super(key: key);

  final List<Map<String, String>> userAccounts;
  final int currentAccountIndex;
  final int currentPage;
  final Function reloadPage;

  @override
  Widget build(BuildContext context) {
    List<PopupMenuEntry> itemList = [];
    double itemHeight = 50;
    TextStyle accountsHeaderTextStyle = text_styles.roboto(14);
    TextStyle accountNumberTextStyle = text_styles.robotoBold(16);
    TextStyle accountTypeTextStyle = text_styles.roboto(14);

    itemList.add(
      PopupMenuItem(
        child: Text('header.accounts'.tr()),
        textStyle: accountsHeaderTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
        enabled: false,
        height: 30,
      ),
    );
    for (int i = 0; i < userAccounts.length; i++) {
      String? accountType;
      switch (userAccounts[i]['type']) {
        case 'mutual':
          accountType = 'header.mutual_account'.tr();
          break;
        case 'pension':
          accountType = 'header.pension_account'.tr();
          break;
        case 'epsv':
          accountType = 'header.epsv_account'.tr();
          break;
        case 'employment_plan':
          accountType = 'header.employment_plan_account'.tr();
          break;
        default:
          accountType = userAccounts[i]['type'];
      }
      itemList.add(PopupMenuItem(
        height: itemHeight,
        child: Row(
          children: [
            Container(
              width: 26,
              alignment: Alignment.centerLeft,
              child: i == currentAccountIndex
                  ? Container(
                      height: 0.8 * itemHeight,
                      width: 4,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius:
                              BorderRadius.horizontal(left: Radius.circular(4)),
                          color: Colors.blue))
                  : null,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userAccounts[i]['number']!,
                    style: i == currentAccountIndex
                        ? accountNumberTextStyle.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant)
                        : accountNumberTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                Text(accountType!,
                    style: i == currentAccountIndex
                        ? accountTypeTextStyle.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant)
                        : accountTypeTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
          ],
        ),
        value: i,
        enabled: i != currentAccountIndex,
      ));
    }
    itemList.add(PopupMenuDivider());
    itemList.add(PopupMenuItem(
      height: itemHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'header.settings'.tr(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          IconButton(
              icon: Icon(Icons.checklist),
              color: Theme.of(context).colorScheme.onSurface,
              disabledColor: Theme.of(context).colorScheme.onSurfaceVariant,
              onPressed: null),
        ],
      ),
      value: "options",
    ));
    itemList.add(PopupMenuItem(
      height: itemHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('header.logout'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          IconButton(
              icon: Icon(Icons.logout),
              color: Colors.red.shade900,
              disabledColor: Colors.red.shade900,
              onPressed: null),
        ],
      ),
      value: "logout",
    ));

    return Container(
      child: PopupMenuButton(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.settings, color: Colors.blue),
            Icon(Icons.arrow_drop_down_rounded, color: Colors.blue)
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        onSelected: (dynamic value) {
          switch (value) {
            case "options":
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SettingsScreen()));
              break;
            case "logout":
              showDialog(
                  context: context,
                  builder: (BuildContext context) => LogoutPopup());
              break;
            default:
              if (value != currentAccountIndex) {
                reloadPage(value, currentPage);
              }
          }
        },
        itemBuilder: (context) {
          return itemList;
        },
      ),
    );
  }
}
