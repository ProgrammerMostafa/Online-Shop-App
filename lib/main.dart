import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/splash/splash_screen.dart';
import '../layout/shop_layout/cubit/states.dart';
import '../layout/shop_layout/cubit/cubit.dart';
import '../shared/constant/constant.dart';
import '../styles/theme.dart';
import '../shared/network/local/cache_helper.dart';
import '../shared/network/remote/dio_helper.dart';
import '../my_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //////////////////////////////////////////
  HttpOverrides.global = MyHttpOverrides();
  /////////////////////
  DioHelper.init();
  /////////////////////
  await CacheHelper.init();
  /////////////////////
  userToken = CacheHelper.getDataFromSharedPreferences(key: 'userToken');
  debugPrint('Token --> $userToken');
  /////////////////////
  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopCubit>(
      create: (_) {
        if (userToken == null) {
          return ShopCubit();
        } else {
          return ShopCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavoritesData()
            ..getCartsData()
            ..getUserData();
        }
      },
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (ctx, state) {},
        builder: (ctx, state) {
          ShopCubit cubit = ShopCubit.get(ctx);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: cubit.themeMode,
            theme: lightTheme(color: cubit.primaryColor),
            darkTheme: darkTheme(color: cubit.primaryColor),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
