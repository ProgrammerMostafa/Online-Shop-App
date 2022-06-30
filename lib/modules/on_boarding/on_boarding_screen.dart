import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '/layout/shop_layout/cubit/cubit.dart';
import '/modules/login/login_screen.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper.dart';

class BoardingItem {
  final String image;
  final String title;
  final String body;

  BoardingItem({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingItem> boarding = [
    BoardingItem(
      image: 'assets/images/shopImage1.png',
      title: 'Online Shopping',
      body:
          'The Shop App is all about making it easier for people to buy from your online store.',
    ),
    BoardingItem(
      image: 'assets/images/shopImage2.png',
      title: 'Choose your product',
      body:
          'There are different categories of products and we have hot offers on some products.',
    ),
    BoardingItem(
      image: 'assets/images/shopImage3.png',
      title: 'Add to shopping cart',
      body:
          'Select and memorize your future purchases with smart online shopping cart.',
    ),
  ];

  /////////////////
  final PageController _pageController = PageController();
  bool isLastPage = false;

  void submit() {
    CacheHelper.saveDataInSharedPreferences(key: 'onBoarding', value: true)
        .then((value) {
      navigateAndFinish(context, LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic appColor = ShopCubit.get(context).primaryColor;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
              top: 25,
            ),
            child: OrientationBuilder(
              builder: (ctx, orientation) {
                return Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: boarding.length,
                        itemBuilder: (con, index) {
                          return buildBoardingItem(
                            orientation == Orientation.landscape,
                            boarding[index],
                            appColor,
                          );
                        },
                        onPageChanged: (index) {
                          if (index == boarding.length - 1) {
                            setState(() {
                              isLastPage = true;
                            });
                          } else {
                            setState(() {
                              isLastPage = false;
                            });
                          }
                        },
                      ),
                    ),
                    /////////////////////////////////////////////
                    Row(
                      children: [
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: boarding.length,
                          effect: ExpandingDotsEffect(
                            dotColor: Colors.grey,
                            activeDotColor: appColor,
                            spacing: 10,
                            expansionFactor: 3,
                          ),
                        ),
                        const Spacer(),
                        FloatingActionButton(
                          backgroundColor: appColor,
                          onPressed: () {
                            if (isLastPage) {
                              submit(); //Calling the function
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                              );
                            }
                          },
                          child: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          ///////////////
          Container(
            padding: const EdgeInsets.only(top: 25.0, right: 5.0),
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: submit, //calling the function
              child: Text(
                'SKIP',
                style: defaultTextStyle(
                  color: appColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column buildBoardingItem(bool isLandscape, BoardingItem item, appColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image.asset(
            item.image,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        ///////////////////////////
        Text(
          item.title,
          style: defaultTextStyle(color: appColor, fontSize: 28),
        ),
        ////////////////
        const SizedBox(height: 12),
        ///////////////
        Text(
          item.body,
          style: defaultTextStyle(color: Colors.black, fontSize: 18),
        ),
        ///////////////////////////
        SizedBox(height: isLandscape ? 15 : 50),
        ///////////////////////////
      ],
    );
  }
}
