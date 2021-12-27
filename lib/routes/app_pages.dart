import 'package:get/get.dart';
import 'package:whosathome/ui/home/home.dart';
import 'package:whosathome/ui/onboarding/onboarding.dart';
part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.initial, page: () => OnBoardingScreen()),
    GetPage(name: Routes.home, page: () => HomePage()),
  ];
}
