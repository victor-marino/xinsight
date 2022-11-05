import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/models/theme_preference_data.dart';
import 'package:indexax/tools/theme_operations.dart' as theme_operations;

class ThemeModalBottomSheet extends StatefulWidget {
  const ThemeModalBottomSheet({
    Key? key,
    required this.updateCurrentThemePreference,
  }) : super(key: key);
  final Function updateCurrentThemePreference;

  @override
  State<ThemeModalBottomSheet> createState() => _ThemeModalBottomSheetState();
}

class _ThemeModalBottomSheetState extends State<ThemeModalBottomSheet> {
  ThemePreference? currentThemePreference;

  void getCurrentThemePreference() async {
    ThemePreference? storedThemePreference =
        await theme_operations.readThemePreference(context);
    if (storedThemePreference == ThemePreference.system ||
        storedThemePreference == null) {
      setState(() {
        currentThemePreference = ThemePreference.system;
      });
    } else {
      setState(() {
        currentThemePreference = ThemePreference.values
            .byName(storedThemePreference.toString().split(".").last);
      });
    }
  }

  _handleThemeChange(ThemePreference value) async {
    await theme_operations.storeThemePreference(context, value);
    setState(() {
      currentThemePreference = value;
    });
    widget.updateCurrentThemePreference();
    theme_operations.updateTheme(context);
  }

  @override
  void initState() {
    super.initState();
    getCurrentThemePreference();
  }

  @override
  Widget build(BuildContext context) {
    theme_operations.updateTheme(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: 70,
          height: 5,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.circular(3)),
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    _handleThemeChange(ThemePreference.system);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 200,
                          child: Image.asset(
                              'assets/images/phone_mock_system.png'),
                        ),
                      ),
                      Text(
                        "settings_screen.system".tr(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Radio<ThemePreference>(
                        value: ThemePreference.system,
                        activeColor: Colors.blue,
                        groupValue: currentThemePreference,
                        onChanged: (ThemePreference? value) {
                          setState(() {
                            currentThemePreference = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _handleThemeChange(ThemePreference.light);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 200,
                          child:
                              Image.asset('assets/images/phone_mock_light.png'),
                        ),
                      ),
                      Text(
                        "settings_screen.light".tr(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Radio<ThemePreference>(
                        value: ThemePreference.light,
                        activeColor: Colors.blue,
                        groupValue: currentThemePreference,
                        onChanged: (ThemePreference? value) {
                          setState(() {
                            currentThemePreference = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _handleThemeChange(ThemePreference.dark);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 200,
                          child:
                              Image.asset('assets/images/phone_mock_dark.png'),
                        ),
                      ),
                      Text(
                        "settings_screen.dark".tr(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Radio<ThemePreference>(
                        value: ThemePreference.dark,
                        activeColor: Colors.blue,
                        groupValue: currentThemePreference,
                        onChanged: (ThemePreference? value) {
                          setState(() {
                            currentThemePreference = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
