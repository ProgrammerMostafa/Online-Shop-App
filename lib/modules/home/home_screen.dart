import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/modules/categories/category_details_screen.dart';
import 'package:flutter_shop_app/modules/products/product_details_screen.dart';
import 'package:flutter_shop_app/shared/constant/constant.dart';

import '/shared/components/components.dart';
import '/models/categories_model.dart';
import '/layout/shop_layout/cubit/cubit.dart';
import '/layout/shop_layout/cubit/states.dart';
import '/models/home_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (ctx, state) {
        if (state is ShopUpdateFavoriteDataErrorState) {
          showToast(message: state.message, state: ToastStates.ERROR);
        }
      },
      builder: (ctx, state) {
        var cubit = ShopCubit.get(ctx);
        return ConditionalBuilder(
          condition: (cubit.homeModel != null && cubit.categoriesModel != null),
          builder: (_) => productsBuilder(
              ctx, cubit.homeModel!, cubit.categoriesModel!, cubit),
          fallback: (_) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

//////////////////////////////////////////////////
Widget productsBuilder(
  BuildContext ctx,
  HomeModel homeModel,
  CategoriesModel categoriesModel,
  ShopCubit cubit,
) {
  double screenWidth = MediaQuery.of(ctx).size.width;
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      children: [
        //////////////// Build Banners (CarouselSlider) ////////////////////
        CarouselSlider.builder(
          itemCount: 8,
          itemBuilder: (con, index, _) {
            return Image.asset(
              'assets/images/banners/banners${index + 1}.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 180,
            );
          },
          options: CarouselOptions(
            height: 180,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
        ),
        ///////////////////////////////////////////
        const SizedBox(height: 10.0),
        ///////////////////////////////////////////
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appWords['categories'][cubit.appLanguage],
                style: defaultTextStyle(color: cubit.textColor, fontSize: 22),
              ),
              /////////////
              const SizedBox(height: 10.0),
              ///////// Build Categories (ListView) /////////////
              SizedBox(
                height: 100,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesModel.data!.data.length,
                  itemBuilder: (ctx, index) => InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      cubit.categoryProductsModel = null;
                      cubit.getCategoryDetails(
                          categoryID: categoriesModel.data!.data[index].id!);
                      navigateTo(
                        ctx,
                        CategoryDatailsScreen(
                          categoryName: categoriesModel.data!.data[index].name!,
                        ),
                      );
                    },
                    //Calling the item method
                    child:
                        buildCategoriesItem(categoriesModel.data!.data[index]),
                  ),
                  separatorBuilder: (ctx, index) => const SizedBox(width: 10),
                ),
              ),
              /////////////
              const SizedBox(height: 20.0),
              /////////////
              Text(
                appWords['products'][cubit.appLanguage],
                style: defaultTextStyle(color: cubit.textColor, fontSize: 22),
              ),
            ],
          ),
        ),
        ///////////////////////////////////////////
        const SizedBox(height: 5.0),
        //////////////// Build Products (GridView) ///////////////////////
        Container(
          padding: const EdgeInsets.all(10.0),
          color: Theme.of(ctx).scaffoldBackgroundColor,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ((screenWidth - 30) / 180).round(),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              mainAxisExtent: 275.0,
            ),
            itemCount: homeModel.data!.products.length,
            itemBuilder: (ctx, index) {
              return buildProductItem_Home(
                ctx,
                homeModel.data!.products[index],
                cubit,
              );
            },
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          ),
        ),
      ],
    ),
  );
}

//////////////////////////////////////////////////
Widget buildCategoriesItem(CategoryDataModel model) {
  return Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: buildCachedNetworkImage(
          urlImage: model.image!,
          width: 115.0,
          height: 110.0,
          boxFit: BoxFit.cover,
        ),
      ),
      /////////////////
      Container(
        height: 25,
        width: 115.0,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          model.name!,
          style: defaultTextStyle(color: Colors.white, fontSize: 15),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      )
    ],
  );
}

//////////////////////////////////////////////////
Widget buildProductItem_Home(
  BuildContext ctx,
  ProductModel model,
  ShopCubit cubit,
) {
  return InkWell(
    onTap: () {
      navigateTo(ctx, ProductsDatailsScreen(model: model));
    },
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(ctx).canvasColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: buildCachedNetworkImage(
                    urlImage: model.image!,
                    width: double.infinity,
                    height: 180,
                  ),
                ),
              ),
              //////////
              if (model.discount != 0)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    width: 42,
                    height: 24,
                    margin: const EdgeInsets.only(left: 5.5,right: 5.5, bottom: 3.5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        '- ${model.discount}%',
                        style: defaultTextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          ////////////////////////////////////
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35.0,
                  child: Text(
                    model.name!,
                    style: defaultTextStyle(
                      color: cubit.textColor,
                      fontSize: 14.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ),
                ////////////////////////////
                const SizedBox(height: 1.0),
                ////////////////////////////
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${model.price!.round()}  ',
                      style: defaultTextStyle(
                        fontSize: 15.0,
                        color: cubit.primaryColor,
                      ),
                    ),
                    //////////////////
                    if (model.discount != 0)
                      Text(
                        '${model.oldPrice!.round()}',
                        style: defaultTextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                          textDecoration: TextDecoration.lineThrough,
                          decorationColor: cubit.primaryColor,
                        ),
                      ),
                    ////////////////
                    const Spacer(),
                    ////////////////
                    IconButton(
                      iconSize: 22,
                      onPressed: () {
                        cubit.changeFavoriteIcon(model.productID!);
                      },
                      icon: cubit.favoritesMap[model.productID!]!
                          ? Icon(
                              Icons.favorite,
                              color: cubit.primaryColor,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: cubit.textColor,
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
