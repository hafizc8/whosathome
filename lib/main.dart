import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whosathome/routes/app_pages.dart';
import 'package:whosathome/ui/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Whos At Home',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeMode.dark,
      initialRoute: Routes.initial,
      defaultTransition: Transition.fade,
      getPages: AppPages.pages,
    );
  }
}