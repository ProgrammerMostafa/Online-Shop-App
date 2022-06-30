import 'package:flutter/material.dart';

import '/layout/shop_layout/shop_layout.dart';
import '/modules/login/login_screen.dart';
import '/modules/on_boarding/on_boarding_screen.dart';
import '/shared/constant/constant.dart';
import '/shared/network/local/cache_helper.dart';
import '/layout/shop_layout/cubit/cubit.dart';
import '/shared/components/components.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    selectWidgetToRun();
  }

  void selectWidgetToRun() async {
    /////////////////////
    Widget widget = const OnBoardingScreen();

    dynamic onBoarding =
        CacheHelper.getDataFromSharedPreferences(key: 'onBoarding');

    if (onBoarding != null) {
      // login or not
      if (userToken != null) {
        widget = const ShopLayout();
      } else {
        widget = LoginScreen();
      }
    }
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        navigateAndFinish(context, widget);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shopIcon1.png',
            color: ShopCubit.get(context).primaryColor,
            width: double.infinity,
            height: 150,
          ),
          Text(
            'Online Shop App',
            style: defaultTextStyle(
              color: ShopCubit.get(context).primaryColor,
              fontSize: 26,
            ),
          ),
        ],
      ),
    );
  }
}
