import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/modules/payment/payment_screen.dart';
import '/shared/constant/constant.dart';
import '/layout/shop_layout/shop_layout.dart';
import '/layout/shop_layout/cubit/cubit.dart';
import '/layout/shop_layout/cubit/states.dart';
import '/shared/components/components.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (ctx, state) {
        if (state is ShopUpdateCartDataSuccessState) {
          showToast(
            message: state.message,
            state: ToastStates.SUCCESS,
          );
        }
      },
      builder: (ctx, state) {
        var cubit = ShopCubit.get(ctx);
        return Directionality(
          textDirection:
              cubit.appLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text(appWords['cart'][cubit.appLanguage]),
              centerTitle: true,
              leading: IconButton(
                splashColor: Colors.white.withOpacity(0.0),
                highlightColor: Colors.white.withOpacity(0.0),
                onPressed: () {
                  navigateAndFinish(ctx, const ShopLayout());
                },
                icon: const Icon(Icons.home_outlined),
              ),
            ),
            ////////////////////////
            body: ConditionalBuilder(
              condition: cubit.cartsModel != null,
              fallback: (_) => const Center(child: CircularProgressIndicator()),
              builder: (_) => Stack(
                children: [
                  ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cubit.cartsModel!.data!.cartItems.length,
                    itemBuilder: (con, index) => buildCartItem(
                      con,
                      cubit,
                      cubit.cartsModel!.data!.cartItems[index].cartID!,
                      cubit.cartsModel!.data!.cartItems[index].quantity!,
                      cubit.cartsModel!.data!.cartItems[index].product!,
                    ),
                    separatorBuilder: (_, __) => myDivider(),
                  ),
                  ///////////////////////
                  if (state is ShopUpdateCartDataSuccessState ||
                      state is ShopUpdateCartQuantityLoadingState ||
                      state is ShopUpdateCartQuantitySuccessState)
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
            ////////////////////////
            bottomNavigationBar: ConditionalBuilder(
              condition: cubit.cartsModel != null,
              builder: (_) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //////////
                        Text(
                          appWords['total'][cubit.appLanguage],
                          style: defaultTextStyle(
                            fontSize: 20,
                            color: cubit.textColor.withOpacity(0.8),
                          ),
                        ),
                        //////////
                        Row(
                          children: [
                            Text(
                              '${(cubit.cartsModel!.data!.total).round()} ',
                              style: defaultTextStyle(
                                fontSize: 19,
                                color: cubit.primaryColor,
                              ),
                            ),
                            //////////
                            Text(
                              appWords['price'][cubit.appLanguage],
                              style: defaultTextStyle(
                                fontSize: 16,
                                color: cubit.textColor.withOpacity(0.8),
                                textHeight:
                                    cubit.appLanguage == 'ar' ? 1.45 : 1.15,
                              ),
                            ),
                          ],
                        ),

                        //////////
                      ],
                    ),
                    ///////////////
                    const Spacer(),
                    ////////////////
                    defaultOutlinedButton(
                      width: 150,
                      height: 45.0,
                      btnText: appWords['checkout'][cubit.appLanguage],
                      btnFunction: () {
                        navigateTo(ctx, PaymentScreen());
                      },
                      icon: Image.asset(
                        'assets/images/checkout.png',
                        width: 28,
                        height: 28,
                        color: Colors.white,
                      ),
                      backColor: cubit.primaryColor,
                    ),
                  ],
                ),
              ),
              fallback: (_) => Container(),
            ),
          ),
        );
      },
    );
  }
}
