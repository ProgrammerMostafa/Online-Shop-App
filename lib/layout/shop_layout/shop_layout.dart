import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/shared/constant/constant.dart';
import '/modules/cart/cart_screen.dart';
import '/layout/shop_layout/cubit/states.dart';
import '/modules/search/search_screen.dart';
import '/shared/components/components.dart';
import '/layout/shop_layout/cubit/cubit.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        var cubit = ShopCubit.get(ctx);
        return Directionality(
          textDirection:
              cubit.appLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                shopLayoutItems[cubit.appLanguage]![
                    cubit.currentIndexBottomNavBar],
              ), ////
              actions: [
                IconButton(
                  onPressed: () {
                    cubit.searchProductsModel = null;
                    navigateTo(ctx, SearchScreen());
                  },
                  icon: Icon(Icons.search, size: 26, color: cubit.textColor),
                  splashColor: Colors.white.withOpacity(0.0),
                  highlightColor: Colors.white.withOpacity(0.0),
                ),
                //////////////////
                IconButton(
                  onPressed: () {
                    navigateAndFinish(ctx, const CartScreen());
                    cubit.currentIndexBottomNavBar = 0;
                  },
                  icon: Image.asset(
                    'assets/images/cartIcon.png',
                    width: 26,
                    height: 26,
                    color: cubit.textColor,
                  ),
                  splashColor: Colors.white.withOpacity(0.0),
                  highlightColor: Colors.white.withOpacity(0.0),
                ),
                //////////////////
                const SizedBox(width: 10.0),
              ],
            ),
            ////////////////////////////////////////////////////
            body: cubit.screens[cubit.currentIndexBottomNavBar],
            ////////////////////////////////////////////////////
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndexBottomNavBar,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: shopLayoutItems[cubit.appLanguage]![0],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.apps),
                  label: shopLayoutItems[cubit.appLanguage]![1],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite),
                  label: shopLayoutItems[cubit.appLanguage]![2],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: shopLayoutItems[cubit.appLanguage]![3],
                ),
              ],
              onTap: (index) => cubit.changeIndexBottomNavBar(index),
            ),
          ),
        );
      },
    );
  }
}
