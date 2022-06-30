import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/layout/shop_layout/shop_layout.dart';
import '/modules/login/login_screen.dart';
import '/layout/shop_layout/cubit/cubit.dart';
import '/modules/register/cubit/cubit.dart';
import '/modules/register/cubit/state.dart';
import '/shared/components/components.dart';
import '/shared/constant/constant.dart';
import '/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopRegisterCubit>(
      create: (_) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (ctx, state) {
          var registerCubit = ShopRegisterCubit.get(ctx);
          if (state is ShopRegisterSuccessState) {
            if (state.userDataModel.status!) {
              CacheHelper.saveDataInSharedPreferences(
                key: 'userToken',
                value: state.userDataModel.data!.token,
              ).then((value) async {
                userToken = state.userDataModel.data!.token;
                debugPrint('Register Token ---> $userToken');
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
                registerCubit.isButtonRegisterClicked = false;
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
              registerCubit.isButtonRegisterClicked = false;
            }
          }
        },
        ////////////////////////
        builder: (ctx, state) {
          ShopRegisterCubit cubit = ShopRegisterCubit.get(ctx);
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
                                      appWords['createAccount']
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
                                      controller: _nameController,
                                      labelText: appWords['username']
                                          [shopCubit.appLanguage],
                                      textColor: shopCubit.textColor,
                                      prefixIconData: Icons.person,
                                      keyboardType: TextInputType.text,
                                      validateFun: (value) {
                                        if (value != null && value.isEmpty) {
                                          return appWords['usernameError']
                                              [shopCubit.appLanguage];
                                        }
                                        return null;
                                      },
                                    ),
                                    ////////////////////////////////
                                    const SizedBox(height: 20.0),
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
                                      validateFun: (value) {
                                        if (value != null && value.isEmpty) {
                                          return appWords['passwordError']
                                              [shopCubit.appLanguage];
                                        }
                                        return null;
                                      },
                                    ),
                                    ////////////////////////////////
                                    const SizedBox(height: 20.0),
                                    ////////////////////////////////
                                    defaultTextField(
                                      controller: _phoneController,
                                      labelText: appWords['phone']
                                          [shopCubit.appLanguage],
                                      textColor: shopCubit.textColor,
                                      prefixIconData: Icons.phone_android,
                                      keyboardType: TextInputType.phone,
                                      validateFun: (value) {
                                        if (value != null && value.isEmpty) {
                                          return appWords['phoneError']
                                              [shopCubit.appLanguage];
                                        }
                                        return null;
                                      },
                                      onSubmittedFun: (_) {
                                        if (_formKey.currentState!.validate()) {
                                          cubit.userRegister(
                                            name: _nameController.text,
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            phone: _phoneController.text,
                                            appLanguage: shopCubit.appLanguage,
                                          );
                                        }
                                      },
                                    ),
                                    ////////////////////////////////
                                    const SizedBox(height: 30.0),
                                    ////////////////////////////////
                                    ConditionalBuilder(
                                      condition: !cubit.isButtonRegisterClicked,
                                      ////
                                      builder: (con) => defaultOutlinedButton(
                                        btnText: appWords['register']
                                            [shopCubit.appLanguage],
                                        btnFunction: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // To close keyboard
                                            FocusScope.of(con).unfocus();
                                            // To Register by email & password
                                            cubit.userRegister(
                                              name: _nameController.text,
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              phone: _phoneController.text,
                                              appLanguage:
                                                  shopCubit.appLanguage,
                                            );
                                          }
                                        },
                                        backColor: shopCubit.primaryColor,
                                      ),
                                      ////
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
                                          appWords['haveAccount']
                                              [shopCubit.appLanguage],
                                          style: defaultTextStyle(
                                            color: shopCubit.textColor
                                                .withOpacity(0.9),
                                          ),
                                        ),
                                        ///////////////////////
                                        defaultTextButton(
                                          btnText: appWords['login']
                                              [shopCubit.appLanguage],
                                          textColor: shopCubit.primaryColor,
                                          btnFunction: () {
                                            navigateAndFinish(
                                                context, LoginScreen());
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
