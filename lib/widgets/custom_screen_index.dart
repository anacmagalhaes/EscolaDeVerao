import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/screens/home/home_screen.dart';
import 'package:escoladeverao/screens/profile/profile_screen.dart';
import 'package:escoladeverao/screens/scan_screen.dart';
import 'package:escoladeverao/screens/schedule_screen.dart';
import 'package:escoladeverao/screens/settings_screen.dart';
import 'package:flutter/material.dart';

Widget getScreenFromIndex(int index, User user) {
  switch (index) {
    case 0:
      return HomeScreen(user: user);
    case 1:
      return ScheduleScreen(user: user);
    case 2:
      return ScanScreen(user: user);
    case 3:
      return ProfileScreen(user: user);
    case 4:
      return SettingsScreen(user: user);
    default:
      return HomeScreen(user: user);
  }
}
