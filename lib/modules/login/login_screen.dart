import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/layout/shop_layout/cubit/cubit.dart';
import '/shared/constant/constant.dart';
import '../../layout/shop_layout/shop_layout.dart';
import '/shared/network/local/cache_helper.dart';
import '/modules/login/cubit/cubit.dart';
import '/modules/login/cubit/state.dart';
import '/modules/register/register_screen.dart';
import '/shared/components/components.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopLoginCubit>(
      create: (_) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (ctx, state) {
          var loginCubit = ShopLoginCubit.get(ctx);
          if (state is ShopLoginSuccessState) {
            if (state.userDataModel.status!) {
              CacheHelper.saveDataInSharedPreferences(
                key: 'userToken',
                value: state.userDataModel.data!.token,
              ).then((value) async {
                userToken = state.userDataModel.data!.token;
                debugPrint('Login Token ---> $userToken');
                ////////////////////
                ShopCubit shopCubit = ShopCubit.get(ctx);
                await shopCubit.getHomeData();
                await shopCubit.getCategoriesData();
                await shopCubit.getFavoritesData();
                await shopCubit.getCartsData();
                shopCubit.getUserData();
                ////////////////////
                showToast(
                  message: state.userDataModel.message!,
                  state: ToastStates.SUCCESS,
                );
                loginCubit.isButtonLoginClicked = false;
                ////////////////////
                // ignore: use_build_context_synchronously
                navigateAndFinish(ctx, const ShopLayout());
              });
            } else {
              // Email or password incorrect
              showToast(
                message: state.userDataModel.message!,
                state: ToastStates.ERROR,
              );
              loginCubit.isButtonLoginClicked = false;
            }
          }
        },
        ////////////////////////
        builder: (ctx, state) {
          ShopLoginCubit cubit = ShopLoginCubit.get(ctx);
          ShopCubit shopCubit = ShopCubit.get(ctx);
          return Directionality(
            textDirection: shopCubit.appLanguage == 'en'
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: OrientationBuilder(
              builder: (context, orientation) {
                return Scaffold(
                  /////////////////
                  body: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
                        pinned: true,
                        expandedHeight:
                            orientation == Orientation.portrait ? null : 150,
                        collapsedHeight:
                            orientation == Orientation.portrait ? 150 : null,
                        flexibleSpace: Container(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            bottom: 5.0,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 25.0,
                                  right: 20.0,
                                ),
                                child: Image.asset(
                                  'assets/images/shopIcon1.png',
                                  color: shopCubit.primaryColor,
                                ),
                              ),
                              Text(
                                'Online Shop App',
                                style: defaultTextStyle(
                                  color: shopCubit.primaryColor,
                                  fontSize: 26,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                alignment: shopCubit.appLanguage == 'en'
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                                child: defaultTextButton(
                                  btnText: shopCubit.appLanguage == 'en'
                                      ? 'Arabic'
                                      : 'English',
                                  textColor: shopCubit.primaryColor,
                                  btnFunction: () {
                                    shopCubit.changeAppLanguageLoginRegister();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //////////////////////////////////////
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appWords['loginTitle']
                                          [shopCubit.appLanguage],
                                      style: defaultTextStyle(
                                        fontSize: 30,
                                        color: shopCubit.textColor,
                                      ),
                                    ),
                                    ////////////////////////////////
                                    const SizedBox(height: 25.0),
                                    ////////////////////////////////
                                    defaultTextField(
                                      controller: _emailController,
                                      labelText: appWords['email']
                                          [shopCubit.appLanguage],
                                      textColor: shopCubit.textColor,
                                      prefixIconData: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                      validateFun: (value) {
                                        if (value != null && value.isEmpty) {
                                          return appWords['emailError']
                                              [shopCubit.appLanguage];
                                        }
                                        return null;
                                      },
                                    ),
                                    ////////////////////////////////
                                    const SizedBox(height: 20.0),
                                    ////////////////////////////////
                                    defaultTextField(
                                      controller: _passwordController,
                                      labelText: appWords['password']
                                          [shopCubit.appLanguage],
                                      textColor: shopCubit.textColor,
                                      prefixIconData: Icons.lock_outlined,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: cubit.isPasswordObscure,
                                      obscuringChr: '*',
                                      suffixIconData: cubit.icon,
                                      suffixPressed: () {
                                        cubit.changePasswordVisibility();
                                      },
                                      onSubmittedFun: (value) {
                                        if (_formKey.currentState!.validate()) {
                                          cubit.userLogin(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            appLanguage: shopCubit.appLanguage,
                                          );
                                        }
                                      },
                                      validateFun: (value) {
                                        if (value != null && value.isEmpty) {
                                          return appWords['passwordError']
                                              [shopCubit.appLanguage];
                                        }
                                        return null;
                                      },
                                    ),
                                    ////////////////////////////////
                                    const SizedBox(height: 30.0),
                                    ////////////////////////////////
                                    ConditionalBuilder(
                                      condition: !cubit.isButtonLoginClicked,
                                      builder: (con) => defaultOutlinedButton(
                                        btnText: appWords['login']
                                            [shopCubit.appLanguage],
                                        btnFunction: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // To close keyboard (Calling the method)
                                            closeKeyboard(con);
                                            // To login by email & password
                                            cubit.userLogin(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              appLanguage:
                                                  shopCubit.appLanguage,
                                            );
                                          }
                                        },
                                        backColor: shopCubit.primaryColor,
                                      ),
                                      fallback: (_) => const Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                    ////////////////////////////////
                                    const SizedBox(height: 5.0),
                                    ////////////////////////////////
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          appWords['noAccount']
                                              [shopCubit.appLanguage],
                                          style: defaultTextStyle(
                                            color: shopCubit.textColor
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                        ///////////////////////
                                        defaultTextButton(
                                          btnText: appWords['register']
                                              [shopCubit.appLanguage],
                                          textColor: shopCubit.primaryColor,
                                          btnFunction: () {
                                            navigateAndFinish(
                                                context, RegisterScreen());
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
