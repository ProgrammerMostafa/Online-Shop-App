import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/modules/categories/category_details_screen.dart';
import '/layout/shop_layout/cubit/cubit.dart';
import '/layout/shop_layout/cubit/states.dart';
import '/models/categories_model.dart';
import '/shared/components/components.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        var cubit = ShopCubit.get(ctx);
        return ConditionalBuilder(
          condition: cubit.categoriesModel != null,
          builder: (_) {
            List<CategoryDataModel> model = cubit.categoriesModel!.data!.data;
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: model.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () {
                      cubit.categoryProductsModel = null;
                      cubit.getCategoryDetails(categoryID: model[index].id!);
                      navigateTo(
                        ctx,
                        CategoryDatailsScreen(categoryName: model[index].name!),
                      );
                    },
                    child: buildCategoryItem(ctx, cubit, model[index]),
                  ),
                );
              },
              separatorBuilder: (_, __) => myDivider(),
            );
          },
          fallback: (_) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  ////////////////////////////////
  buildCategoryItem(
    BuildContext ctx,
    ShopCubit cubit,
    CategoryDataModel model,
  ) {
    return Container(
      height: 110.0,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Theme.of(ctx).canvasColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildCachedNetworkImage(urlImage: model.image!),
            ),
          ),
          /////////////////////////
          const SizedBox(width: 10.0),
          /////////////////////////
          Text(
            model.name!,
            style: defaultTextStyle(color: cubit.textColor, fontSize: 20.0),
          ),
          /////////////////////////
          const Spacer(),
          /////////////////////////
          Icon(Icons.arrow_forward_ios, color: cubit.textColor),
        ],
      ),
    );
  }
}
