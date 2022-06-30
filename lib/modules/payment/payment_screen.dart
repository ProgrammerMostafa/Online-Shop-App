import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/layout/shop_layout/cubit/cubit.dart';
import 'package:flutter_shop_app/layout/shop_layout/cubit/states.dart';
import 'package:flutter_shop_app/shared/components/components.dart';
import 'package:flutter_shop_app/shared/constant/constant.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({Key? key}) : super(key: key);

  List<Map> paymentList = [
    {
      'en': 'Visa',
      'ar': 'فيزا',
      'image': 'assets/images/payments/visa.jpg',
    },
    {
      'en': 'Mastercard',
      'ar': 'ماستركارد',
      'image': 'assets/images/payments/mastercard.jpg',
    },
    {
      'en': 'Paypal',
      'ar': 'باي بال',
      'image': 'assets/images/payments/paypal.jpg',
    },
    {
      'en': 'American Express',
      'ar': 'أمريكان إكسبريس',
      'image': 'assets/images/payments/americanexpress.jpg',
    },
    {
      'en': 'Cirrus',
      'ar': 'سيروس',
      'image': 'assets/images/payments/cirrus.jpg',
    },
    {
      'en': 'Visa Electron',
      'ar': 'فيزا إلكترون',
      'image': 'assets/images/payments/visaelectron.jpg',
    },
  ];

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
            appBar: AppBar(
              title: Text(appWords['payment'][cubit.appLanguage]),
              centerTitle: true,
            ),
            /////////////////////////
            body: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: paymentList.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () {},
                    child: buildPaymentItem(
                      ctx,
                      index,
                      cubit,
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => myDivider(),
            ),
            /////////////////////////
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appWords['total'][cubit.appLanguage],
                    style: defaultTextStyle(
                      fontSize: 24,
                      color: cubit.textColor.withOpacity(0.8),
                    ),
                  ),
                  //////////
                  Text(
                    ' ${(cubit.cartsModel!.data!.total).round()} ',
                    style: defaultTextStyle(
                      fontSize: 24,
                      color: cubit.primaryColor,
                      textHeight: cubit.appLanguage == 'ar' ? 0.95 : 1.15,
                    ),
                  ),
                  //////////
                  Text(
                    appWords['price'][cubit.appLanguage],
                    style: defaultTextStyle(
                      fontSize: 22,
                      color: cubit.textColor.withOpacity(0.8),
                      textHeight: cubit.appLanguage == 'ar' ? 1.15: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //////////////////////////////
  buildPaymentItem(
    BuildContext ctx,
    int index,
    ShopCubit cubit,
  ) {
    return Container(
      height: 100.0,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Theme.of(ctx).canvasColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                paymentList[index]['image'],
              ),
            ),
          ),
          /////////////////////////
          const SizedBox(width: 10.0),
          /////////////////////////
          Text(
            paymentList[index][cubit.appLanguage],
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
