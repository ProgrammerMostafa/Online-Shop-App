import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/layout/shop_layout/cubit/cubit.dart';
import '/layout/shop_layout/cubit/states.dart';
import '/shared/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

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
          condition: cubit.favoritesModel != null,
          builder: (_) => Stack(
            children: [
              ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: cubit.favoritesModel!.data!.data.length,
                itemBuilder: (con, index) => buildProductItem(
                  con,
                  cubit,
                  cubit.favoritesModel!.data!.data[index].product!,  ///model  
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
        );
      },
    );
  }
}
