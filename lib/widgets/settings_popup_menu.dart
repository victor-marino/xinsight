import 'package:flutter/material.dart';
import 'package:indexax/screens/settings_screen.dart';
import 'package:indexax/widgets/settings_screen/logout_popup.dart';
import 'package:indexax/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPopupMenu extends StatelessWidget {
  const SettingsPopupMenu(
      {Key? key,
      required this.userAccounts,
      required this.currentAccountNumber,
      required this.currentPage,
      required this.reloadPage})
      : super(key: key);

  final List<Map<String, String>>? userAccounts;
  final int currentAccountNumber;
  final int currentPage;
  final Function reloadPage;

  @override
  Widget build(BuildContext context) {
    List<PopupMenuEntry> itemList = [];
    double itemHeight = 50;

    //if (userAccounts.length > 1) {
    itemList.add(
      PopupMenuItem(
        child: Text('header.accounts'.tr()),
        textStyle: kAccountSwitcherHintTextStyle,
        enabled: false,
        height: 30,
      ),
    );
    for (int i = 0; i < userAccounts!.length; i++) {
      String? accountType;
      switch (userAccounts![i]['type']) {
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
          accountType = userAccounts![i]['type'];
      }
      itemList.add(PopupMenuItem(
        height: itemHeight,
        //padding: EdgeInsets.only(left: 32),
        child: Row(
          children: [
            Container(
              width: 26,
              alignment: Alignment.centerLeft,
              //child: i == currentAccountNumber ? Icon(Icons.fiber_manual_record_rounded, size: 10, color: Colors.blue) : null,
              child: i == currentAccountNumber
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
                Text(userAccounts![i]['number']!,
                    style: i == currentAccountNumber
                        ? kAccountSwitcherCurrentAccountNumberTextStyle
                        : kAccountSwitcherOtherAccountsNumberTextStyle),
                Text(accountType!,
                    style: i == currentAccountNumber
                        ? kAccountSwitcherCurrentAccountTypeTextStyle
                        : kAccountSwitcherOtherAccountsTypeTextStyle),
              ],
            ),
          ],
        ),
        value: i,
        enabled: i != currentAccountNumber,
        //enabled: true,
        //padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
      ));
    }
    itemList.add(PopupMenuDivider());
    //}

    itemList.add(PopupMenuItem(
      height: itemHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('header.settings'.tr()),
          IconButton(
              icon: Icon(Icons.checklist),
              color: Colors.black54,
              disabledColor: Colors.black54,
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
          Text('header.logout'.tr()),
          IconButton(
              icon: Icon(Icons.logout),
              color: Colors.red.shade900,
              disabledColor: Colors.red.shade900,
              onPressed: null),
        ],
      ),
      value: "logout",
      //padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
    ));

    return Container(
      child: PopupMenuButton(
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
              if (value != currentAccountNumber) {
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
