import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/shared/constant/constant.dart';
import '/models/home_model.dart';
import '/layout/shop_layout/cubit/cubit.dart';
import '/models/favorites_model.dart';
import '/modules/products/product_details_screen.dart';

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
Widget defaultOutlinedButton({
  required Function()? btnFunction,
  required String btnText,
  required dynamic backColor,
  double textSize = 16.0,
  double width = double.infinity,
  double height = 50.0,
  bool isUpperCase = true,
  double radius = 15.0,
  Widget? icon,
  bool enabled = true,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: enabled ? backColor : Colors.grey[600],
      borderRadius: BorderRadius.circular(radius),
    ),
    child: InkWell(
      onTap: enabled ? btnFunction : null,
      borderRadius: BorderRadius.circular(radius),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon,
            ///////////////////////
            const SizedBox(width: 10.0)
          ],
          ///////////////////////
          Text(
            isUpperCase ? btnText.toUpperCase() : btnText,
            style: defaultTextStyle(
              color: Colors.white,
              fontSize: textSize,
            ),
          ),
        ],
      ),
    ),
  );
}

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
Widget defaultIconButton({
  required Function()? onPressed,
  required IconData iconData,
  required dynamic backColor,
  Color iconColor = Colors.white,
  double iconSize = 24,
  double width = 30.0,
  double height = 30.0,
  double radius = 20.0,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: backColor,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onPressed,
      child: Icon(
        iconData,
        color: iconColor,
        size: iconSize,
      ),
    ),
  );
}

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
Widget defaultTextButton({
  required String btnText,
  required dynamic textColor,
  required Function() btnFunction,
}) {
  return TextButton(
    onPressed: btnFunction,
    child: Text(
      btnText.toUpperCase(),
      style: defaultTextStyle(color: textColor, fontSize: 15.0),
    ),
  );
}

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

Widget defaultTextField({
  TextEditingController? controller,
  required String labelText,
  required textColor,
  required IconData prefixIconData,
  required TextInputType keyboardType,
  Function()? onTapeFun,
  Function(String)? onChangeFun,
  Function(String)? onSubmittedFun,
  String? Function(String?)? validateFun,
  bool readOnly = false,
  bool obscureText = false,
  String obscuringChr = '.',
  IconData? suffixIconData,
  Function()? suffixPressed,
  double radius = 15.0,
  String? initialValue,
}) {
  return TextFormField(
    controller: controller,
    initialValue: initialValue,
    style: defaultTextStyle(color: textColor.withOpacity(0.9)),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: defaultTextStyle(color: textColor.withOpacity(0.7)),
      prefixIcon: Icon(
        prefixIconData,
        color: textColor.withOpacity(0.6),
      ),
      suffixIcon: IconButton(
        onPressed: suffixPressed,
        icon: Icon(
          suffixIconData,
          color: textColor.withOpacity(0.6),
        ),
        splashColor: Colors.white.withOpacity(0.0),
        highlightColor: Colors.white.withOpacity(0.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: BorderSide(color: textColor.withOpacity(0.7)),
      ),
    ),
    keyboardType: keyboardType,
    onTap: onTapeFun,
    onChanged: onChangeFun,
    onFieldSubmitted: onSubmittedFun,
    readOnly: readOnly,
    validator: validateFun,
    obscureText: obscureText, //To hide the password
    obscuringCharacter: obscuringChr,
  );
}

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
TextStyle defaultTextStyle({
  required Color color,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.bold,
  TextDecoration? textDecoration,
  Color? decorationColor,
  double textHeight = 1.15,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    decoration: textDecoration,
    decorationColor: decorationColor,
    height: textHeight,
  );
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
Widget myDivider({double horizontalPad = 15.0}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPad),
    child: Container(
      width: double.infinity,
      height: 2.0,
      color: Colors.grey,
    ),
  );
}

////////////////////////////////////////////////////////////////////////////////
void navigateTo(BuildContext ctx, Widget nextScreen) {
  Navigator.push(ctx, MaterialPageRoute(builder: (_) => nextScreen));
}

////////////////
void navigateAndFinish(BuildContext ctx, Widget nextScreen) {
  Navigator.pushReplacement(ctx, MaterialPageRoute(builder: (_) => nextScreen));
}

////////////////////////////////////////////////////////////////////////////////
showToast({
  required String message,
  required ToastStates state,
  Toast length = Toast.LENGTH_SHORT,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: length,
    timeInSecForIosWeb: 5,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastStates {
  SUCCESS,
  ERROR,
  WARNING,
}

Color chooseToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.SUCCESS:
      return Colors.green;
    case ToastStates.ERROR:
      return Colors.red;
    case ToastStates.WARNING:
      return Colors.amber;
  }
}

/////////////////////////////////////////////////////////////////////////////
FadeInImage buildNetworkImage({
  required String urlImage,
  double width = 100.0,
  double height = 100.0,
  BoxFit boxFit = BoxFit.contain,
}) {
  return FadeInImage(
    placeholder: const AssetImage('assets/images/waitingImage.png'),
    image: NetworkImage(urlImage),
    width: width,
    height: height,
    fit: boxFit,
  );
}

/////////////////////////////////////////////////////////////////////////////////
CachedNetworkImage buildCachedNetworkImage({
  required String urlImage,
  double width = 100.0,
  double height = 100.0,
  BoxFit boxFit = BoxFit.contain,
}) {
  return CachedNetworkImage(
    width: width,
    height: height,
    fit: boxFit,
    imageUrl: urlImage,
    placeholder: (context, url) =>
        Image.asset('assets/images/waitingImage.png'),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}

/////////////////////////////////////////////////////////////////////////////
Widget buildProductItem(
  BuildContext ctx,
  ShopCubit cubit,
  dynamic model,
) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: () {
        if (model is FavProductModel) {
          model = cubit.homeModel!.data!.products.firstWhere((element) {
            return element.productID == model.productID;
          });
        }
        navigateTo(ctx, ProductsDatailsScreen(model: model));
      },
      child: Container(
        height: 110.0,
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Theme.of(ctx).canvasColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
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
                ////////////////////////
                if (model.discount != null && model.discount != 0)
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      width: 38,
                      height: 20,
                      margin: const EdgeInsets.only(
                        left: 2.0,
                        right: 2.0,
                        bottom: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          '- ${model.discount}%',
                          style: defaultTextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            ////////////////////////////////////
            const SizedBox(width: 10.0),
            ////////////////////////////////////
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    style: defaultTextStyle(color: cubit.textColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ////////////////////////////
                  const Spacer(),
                  ////////////////////////////
                  Row(
                    children: [
                      Text(
                        '${model.price!.round()}   ',
                        style: defaultTextStyle(color: cubit.primaryColor),
                      ),
                      //////////////////
                      if (model.discount != null && model.discount != 0)
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
                      CircleAvatar(
                        backgroundColor: cubit.themeMode == ThemeMode.light
                            ? Colors.grey[200]
                            : Colors.grey[850],
                        child: IconButton(
                          splashColor: Colors.white.withOpacity(0.0),
                          highlightColor: Colors.white.withOpacity(0.0),
                          onPressed: () {
                            cubit.changeFavoriteIcon(model.productID!);
                          },
                          iconSize: 20,
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/////////////////////////////////////////////////////////////////////////////
Widget buildCartItem(
  BuildContext ctx,
  ShopCubit cubit,
  int cartID,
  int quantity,
  ProductModel model,
) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Container(
      height: 110.0,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Theme.of(ctx).canvasColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildCachedNetworkImage(urlImage: model.image!),
            ),
          ),
          ////////////////////////////////////
          const SizedBox(width: 10.0),
          ////////////////////////////////////
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name!,
                  style: defaultTextStyle(color: cubit.textColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                ////////////////////////////
                const SizedBox(height: 5.0),
                ////////////////////////////
                const Spacer(),
                ////////////////////////////
                Row(
                  children: [
                    Text(
                      '${model.price!.round()} ',
                      style: defaultTextStyle(
                        color: cubit.primaryColor,
                      ),
                    ),
                    ////////////////////////////
                    Text(
                      appWords['price'][cubit.appLanguage],
                      style: defaultTextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        textHeight: cubit.appLanguage == 'ar' ? 1.3 : 1.15,
                      ),
                    ),
                    ////////////////////////////
                    const Spacer(),
                    ////////////////////////////
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultIconButton(
                            width: 25,
                            height: 25,
                            onPressed: () {
                              if (quantity != 1) {
                                cubit.updateCartQuantity(cartID, --quantity);
                              }
                            },
                            iconData: Icons.remove,
                            iconSize: 16.0,
                            backColor: cubit.primaryColor,
                          ),
                          //////////
                          Text(
                            '   $quantity   ',
                            style: defaultTextStyle(
                              fontSize: 18,
                              color: cubit.textColor.withOpacity(0.8),
                            ),
                          ),
                          defaultIconButton(
                            width: 25,
                            height: 25,
                            onPressed: () {
                              cubit.updateCartQuantity(cartID, ++quantity);
                            },
                            iconData: Icons.add,
                            iconSize: 16.0,
                            backColor: cubit.primaryColor,
                          ),
                          //////////
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          ////////////////////////////////////
          const SizedBox(width: 5.0),
          ////////////////////////////////////
          const VerticalDivider(
            width: 10.0,
            thickness: 1.2,
            color: Colors.grey,
          ),
          ///// Delete cart item ///////////////////////////////
          InkWell(
            onTap: () {
              cubit.addOrRemoveCartData(model.productID!);
            },
            child: SizedBox(
              height: double.infinity,
              width: 25.0,
              child: Icon(Icons.delete_forever_rounded, color: cubit.textColor),
            ),
          ),
        ],
      ),
    ),
  );
}
