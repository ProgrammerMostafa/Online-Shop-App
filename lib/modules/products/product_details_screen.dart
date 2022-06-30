import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/carts_model.dart';
import '/shared/constant/constant.dart';
import '/layout/shop_layout/cubit/cubit.dart';
import '/layout/shop_layout/cubit/states.dart';
import '/models/home_model.dart';
import '/shared/components/components.dart';

class ProductsDatailsScreen extends StatelessWidget {
  final ProductModel model;
  const ProductsDatailsScreen({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        var cubit = ShopCubit.get(ctx);
        return Directionality(
          textDirection:
              cubit.appLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: WillPopScope(
            onWillPop: () async {
              cubit.currentIndexCarouselSlider = 0;
              cubit.cartQuantity = 1;
              return true;
            },
            child: OrientationBuilder(
              builder: (context, orientation) => Scaffold(
                body: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      actions: [
                        IconButton(
                          iconSize: 24,
                          onPressed: () {
                            cubit.changeFavoriteIcon(model.productID!);
                          },
                          icon: cubit.favoritesMap[model.productID!]!
                              ? Icon(
                                  Icons.favorite,
                                  color: cubit.primaryColor,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  color: Colors.black87,
                                ),
                        ),
                      ],
                      backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
                      iconTheme: IconThemeData(color: cubit.primaryColor),
                      pinned: true,
                      expandedHeight:
                          orientation == Orientation.portrait ? null : 240,
                      collapsedHeight:
                          orientation == Orientation.portrait ? 240 : 120,
                      flexibleSpace: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CarouselSlider(
                              items: model.images!.map(
                                (element) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                    ),
                                    child: buildCachedNetworkImage(
                                      urlImage: element.toString(),
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  );
                                },
                              ).toList(),
                              options: CarouselOptions(
                                height: 255,
                                enlargeCenterPage: true,
                                viewportFraction: 1.0,
                                onPageChanged: (indexVal, _) {
                                  cubit.changeIndexCarouselSlider(indexVal);
                                },
                              ),
                            ),
                            ////////////////////
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: DotsIndicator(
                                dotsCount: model.images!.length,
                                position:
                                    cubit.currentIndexCarouselSlider.toDouble(),
                                decorator: DotsDecorator(
                                  color: Colors.grey, // Inactive color
                                  activeColor: cubit.primaryColor,
                                  size: const Size.square(10.0),
                                  activeSize: const Size.square(13.0),
                                ),
                              ),
                            ),
                            ////////////////////
                          ],
                        ),
                      ),
                    ),
                    //////////////////////////////////////
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 5.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.name!,
                                  style: defaultTextStyle(
                                    color: cubit.textColor,
                                    fontSize: 22,
                                  ),
                                ),
                                ///////////
                                const SizedBox(height: 15),
                                ///////////
                                Text(
                                  model.description!,
                                  style: defaultTextStyle(
                                    color: cubit.themeMode == ThemeMode.dark
                                        ? Colors.grey[350]!
                                        : Colors.grey[800]!,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                /////////////////////////////
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultIconButton(
                              backColor: cubit.primaryColor,
                              onPressed: () {
                                if (cubit.cartQuantity != 1) {
                                  cubit.changeCartQuantityValue(
                                      cartQuantity: --cubit.cartQuantity);
                                }
                              },
                              iconData: Icons.remove,
                              iconSize: 18.0,
                            ),
                            //////////
                            Text(
                              '  ${(model.price).round()}',
                              style: defaultTextStyle(
                                fontSize: 20,
                                color: cubit.textColor,
                              ),
                            ),
                            //////////
                            Text(
                              ' X ${cubit.cartQuantity}  ',
                              style: defaultTextStyle(
                                fontSize: 20,
                                color: cubit.themeMode == ThemeMode.dark
                                    ? Colors.grey[400]!
                                    : Colors.grey[600]!,
                              ),
                            ),
                            defaultIconButton(
                              backColor: cubit.primaryColor,
                              onPressed: () {
                                cubit.changeCartQuantityValue(
                                    cartQuantity: ++cubit.cartQuantity);
                              },
                              iconData: Icons.add,
                              iconSize: 18.0,
                            ),
                            //////////
                          ],
                        ),
                      ),
                      ///////////////
                      const Spacer(),
                      ////////////////
                      Stack(
                        children: [
                          defaultOutlinedButton(
                            backColor: cubit.primaryColor,
                            isUpperCase: false,
                            width: 150,
                            height: 45,
                            btnText: appWords['addCart'][cubit.appLanguage],
                            btnFunction: () {
                              if (cubit.cartsMap[model.productID]!) {
                                CartItemModel cartItem = cubit
                                    .cartsModel!.data!.cartItems
                                    .firstWhere(
                                  (cart) =>
                                      model.productID ==
                                      cart.product!.productID,
                                );
                                cubit
                                    .updateCartQuantity(
                                      cartItem.cartID!,
                                      cartItem.quantity! + cubit.cartQuantity,
                                    )
                                    .then((value) => Navigator.pop(ctx));
                              } else {
                                cubit
                                    .addOrRemoveCartData(model.productID!)
                                    .then((value) => Navigator.pop(ctx));
                              }
                              showToast(
                                message: appWords['messageAdding']
                                    [cubit.appLanguage],
                                state: ToastStates.SUCCESS,
                              );
                              //////////////////
                              cubit.currentIndexCarouselSlider = 0;
                              cubit.cartQuantity = 1;
                            },
                            icon: Image.asset(
                              'assets/images/cartIcon.png',
                              width: 28,
                              height: 28,
                              color: Colors.white,
                            ),
                          ),
                          ////////////////
                          if (state is ShopUpdateCartDataSuccessState ||
                              state is ShopUpdateCartQuantityLoadingState ||
                              state is ShopUpdateCartQuantitySuccessState)
                            Container(
                              width: 150,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
