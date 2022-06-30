import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/shared/constant/constant.dart';
import '/layout/shop_layout/cubit/cubit.dart';
import '/layout/shop_layout/cubit/states.dart';
import '/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        ShopCubit cubit = ShopCubit.get(ctx);
        return Directionality(
          textDirection:
              cubit.appLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 56),
              child: Container(
                color: Theme.of(ctx).canvasColor,
                padding: const EdgeInsets.only(
                  top: 25.0,
                  left: 15.0,
                  right: 15.0,
                ),
                child: TextFormField(
                  scrollPadding: const EdgeInsets.all(0.0),
                  autofocus: true,
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: appWords['search'][cubit.appLanguage],
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: cubit.textColor.withOpacity(0.7),
                    ),
                    icon: InkWell(
                      splashColor: null,
                      onTap: () {
                        Navigator.pop(ctx);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: cubit.textColor,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (String value) {
                    closeKeyboard(ctx);
                    cubit.getSearchProducts(searchValue: value);
                  },
                  /////////////////////
                ),
              ),
            ),
            //////////////////////////////////////////////////////////
            body: _searchController.text.trim().isEmpty
                ? Container()
                : ConditionalBuilder(
                    condition: state is! ShopGetSearchDataLoadingState,
                    builder: (_) => Stack(
                      children: [
                        ConditionalBuilder(
                          condition:
                              cubit.searchProductsModel!.data!.data.isNotEmpty,
                          builder: (_) => ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                cubit.searchProductsModel!.data!.data.length,
                            itemBuilder: (con, index) => buildProductItem(
                              con,
                              cubit,
                              cubit.searchProductsModel!.data!.data[index],
                            ),
                            separatorBuilder: (_, __) => myDivider(),
                          ),
                          //////////
                          fallback: (_) => Center(
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/noResult.png',
                                    height: 200,
                                    width: 200,
                                    color: cubit.textColor.withOpacity(0.8),
                                  ),
                                  ////
                                  Text(
                                    appWords['noSearch'][cubit.appLanguage]+'\n\n\n\n\n',
                                    style: defaultTextStyle(color: cubit.textColor,fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ///////////////////////
                        if (state is ShopChangeFavoriteIconSuccessState ||
                            state is ShopUpdateFavoriteDataSuccessState)
                          Container(
                            color: Colors.black.withOpacity(0.4),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                    fallback: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
          ),
        );
      },
    );
  }
}
