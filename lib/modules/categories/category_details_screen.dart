import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/layout/shop_layout/cubit/cubit.dart';
import '/layout/shop_layout/cubit/states.dart';
import '/shared/components/components.dart';

class CategoryDatailsScreen extends StatelessWidget {
  final String categoryName;
  const CategoryDatailsScreen({
    required this.categoryName,
    Key? key,
  }) : super(key: key);

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
        return Directionality(
          textDirection:
              cubit.appLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text(categoryName),
            ),
            body: ConditionalBuilder(
              condition: cubit.categoryProductsModel != null,
              builder: (_) => Stack(
                children: [
                  ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cubit.categoryProductsModel!.data!.data.length,
                    itemBuilder: (con, index) => buildProductItem(
                      con,
                      cubit,
                      cubit.categoryProductsModel!.data!.data[index],
                    ),
                    separatorBuilder: (_, __) => myDivider(),
                  ),
                  ///////////////////////
                  if (state is ShopChangeFavoriteIconSuccessState ||
                      state is ShopUpdateFavoriteDataSuccessState)
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
              fallback: (_) => const Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }
}
