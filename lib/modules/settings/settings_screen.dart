import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/layout/shop_layout/cubit/cubit.dart';
import '/layout/shop_layout/cubit/states.dart';
import '/shared/components/components.dart';
import '/shared/constant/constant.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (ctx, state) {
        if (state is ShopUpdateUserDataSuccessState) {
          // get message if updating data sucessfully or not
          showToast(
            message: state.userDataModel.message!,
            state: state.userDataModel.status!
                ? ToastStates.SUCCESS
                : ToastStates.ERROR,
          );
        }
      },
      ///////////////////////
      builder: (ctx, state) {
        var cubit = ShopCubit.get(ctx);
        return ConditionalBuilder(
          condition: cubit.changingLanguage == 0,
          fallback: (_) => Container(
            padding: const EdgeInsets.all(20.0),
            width: double.infinity,
            color: Colors.black.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  appWords['changeLanguage'][cubit.appLanguage],
                  style: defaultTextStyle(
                    fontSize: 20,
                    color: cubit.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                const LinearProgressIndicator(),
              ],
            ),
          ),
          builder: (_) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ////////////////////////////////////////////////////////
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10.0,
                      ),
                      width: double.infinity,
                      height: cubit.isProfileContainerOpen ? 375 : 60,
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).canvasColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            splashColor: cubit.textColor.withOpacity(0.0),
                            highlightColor: cubit.textColor.withOpacity(0.0),
                            onTap: () => cubit.changeProfileContainerStatus(),
                            child: buildRowItem(
                              cubit,
                              Icons.person,
                              appWords['account'][cubit.appLanguage],
                              cubit.isProfileContainerOpen,
                            ),
                          ),
                          if (cubit.isProfileContainerOpen) ...[
                            const SizedBox(height: 5),
                            myDivider(horizontalPad: 0.0),
                            const SizedBox(height: 20),
                            ConditionalBuilder(
                              condition: cubit.userDataModel != null,
                              builder: (_) => buildProfileColumn(cubit, state),
                              fallback: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    ////////////////////////////////////////////////////////
                    const SizedBox(height: 20.0),
                    ////////////////////////////////////////////////////////
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10.0,
                      ),
                      width: double.infinity,
                      height: cubit.isThemeContainerOpen ? 325 : 60,
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).canvasColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            splashColor: cubit.textColor.withOpacity(0.0),
                            highlightColor: cubit.textColor.withOpacity(0.0),
                            onTap: () => cubit.changeThemeContainerStatus(),
                            child: buildRowItem(
                              cubit,
                              Icons.brightness_4,
                              appWords['theme'][cubit.appLanguage],
                              cubit.isThemeContainerOpen,
                            ),
                          ),
                          if (cubit.isThemeContainerOpen) ...[
                            const SizedBox(height: 10),
                            myDivider(horizontalPad: 0.0),
                            const SizedBox(height: 20),
                            ////////////////////////////////
                            buildThemeColumn(cubit, state),
                          ],
                        ],
                      ),
                    ),
                    ////////////////////////////////////////////////////////
                    const SizedBox(height: 20.0),
                    ////////////////////////////////////////////////////////
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10.0,
                      ),
                      width: double.infinity,
                      height: cubit.isLanguageContainerOpen ? 190 : 60,
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).canvasColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            splashColor: cubit.textColor.withOpacity(0.0),
                            highlightColor: cubit.textColor.withOpacity(0.0),
                            onTap: () => cubit.changeLanguageContainerStatus(),
                            child: buildRowItem(
                              cubit,
                              Icons.language,
                              appWords['language'][cubit.appLanguage],
                              cubit.isLanguageContainerOpen,
                            ),
                          ),
                          if (cubit.isLanguageContainerOpen) ...[
                            const SizedBox(height: 10),
                            myDivider(horizontalPad: 0.0),
                            const SizedBox(height: 5),
                            ////////////////////////////////
                            buildLanguageColumn(cubit, state),
                          ],
                        ],
                      ),
                    ),
                    ///////////////////////////////////////////////////////
                    const SizedBox(height: 20.0),
                    ///////////////////////////////////////////////////////
                    myDivider(horizontalPad: 0.0),
                    ///////////////////////////////////////////////////////
                    const SizedBox(height: 20.0),
                    ///////////////////////////////////////////////////////
                    defaultOutlinedButton(
                      btnText: appWords['logout'][cubit.appLanguage],
                      btnFunction: () {
                        //Calling the function --> constant method
                        userLogout(ctx);
                        cubit.currentIndexBottomNavBar = 0;
                      },
                      backColor: cubit.primaryColor,
                      icon: Image.asset(
                        'assets/images/logoutIcon.png',
                        width: 25,
                        height: 25,
                        color: Colors.white,
                      ),
                    ),
                    ///////////////////////////////////////////////////////
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  SizedBox buildRowItem(
    ShopCubit cubit,
    IconData iconData,
    String text,
    bool arrowStatus,
  ) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Icon(iconData, color: cubit.textColor),
          const SizedBox(width: 20.0),
          Text(
            text,
            style: defaultTextStyle(
              color: cubit.textColor,
              fontSize: 18.0,
            ),
          ),
          const Spacer(),
          Icon(
            arrowStatus ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: cubit.textColor,
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  Column buildProfileColumn(ShopCubit cubit, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        defaultTextField(
          initialValue: cubit.usernameValue,
          labelText: appWords['username'][cubit.appLanguage],
          textColor: cubit.textColor,
          prefixIconData: Icons.person,
          keyboardType: TextInputType.text,
          validateFun: (value) {
            if (value != null && value.isEmpty) {
              return appWords['usernameError'][cubit.appLanguage];
            }
            return null;
          },
          onChangeFun: (val) {
            cubit.changeTextFieldUserData(val, 'username');
          },
        ),
        /////////////////////////////
        const SizedBox(height: 20.0),
        /////////////////////////////
        defaultTextField(
          initialValue: cubit.emailValue,
          labelText: appWords['email'][cubit.appLanguage],
          textColor: cubit.textColor,
          prefixIconData: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validateFun: (value) {
            if (value != null && value.isEmpty) {
              return appWords['emailError'][cubit.appLanguage];
            }
            return null;
          },
          onChangeFun: (val) {
            cubit.changeTextFieldUserData(val, 'email');
          },
        ),
        /////////////////////////////
        const SizedBox(height: 20.0),
        /////////////////////////////
        defaultTextField(
          initialValue: cubit.phoneValue,
          labelText: appWords['phone'][cubit.appLanguage],
          textColor: cubit.textColor,
          prefixIconData: Icons.phone,
          keyboardType: TextInputType.phone,
          validateFun: (value) {
            if (value != null && value.isEmpty) {
              return appWords['phoneError'][cubit.appLanguage];
            }
            return null;
          },
          onChangeFun: (val) {
            cubit.changeTextFieldUserData(val, 'phone');
          },
        ),
        /////////////////////////////
        const SizedBox(height: 20.0),
        /////////////////////////////
        ConditionalBuilder(
          condition: state is! ShopUpdateUserDataLoadingState,
          ////
          builder: (con) {
            return defaultOutlinedButton(
              enabled: cubit.usernameValue.trim() !=
                      cubit.userDataModel!.data!.name! ||
                  cubit.emailValue.trim() !=
                      cubit.userDataModel!.data!.email! ||
                  cubit.phoneValue.trim() != cubit.userDataModel!.data!.phone!,
              btnText: appWords['update'][cubit.appLanguage],
              btnFunction: () {
                if (_formKey.currentState!.validate()) {
                  // To close keyboard (Calling the method)
                  closeKeyboard(con);
                  // To update user data
                  cubit.updateUserData(
                    name: cubit.usernameValue,
                    email: cubit.emailValue,
                    phone: cubit.phoneValue,
                  );
                }
              },
              backColor: cubit.primaryColor,
            );
          },
          ////
          fallback: (_) => const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  Column buildThemeColumn(ShopCubit cubit, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ///////////////////////////////////////
        Text(
          appWords['themeTitle1'][cubit.appLanguage],
          style: defaultTextStyle(color: cubit.textColor, fontSize: 17),
        ),
        ///////////////////////////////////////
        const SizedBox(height: 5.0),
        ///////////////////////////////////////
        buildRadioListTile(
          cubit: cubit,
          radioValue: ThemeMode.light,
          groupValue: cubit.themeMode,
          onChangedFun: (newThemeVal) {
            cubit.changeThemeMode(newThemeVal, Colors.black);
          },
          titleText: appWords['lightMode'][cubit.appLanguage],
          secondaryWidget: Icon(Icons.wb_sunny, color: cubit.textColor),
        ),
        ///////////////////////////////////////
        buildRadioListTile(
          cubit: cubit,
          radioValue: ThemeMode.dark,
          groupValue: cubit.themeMode,
          onChangedFun: (newThemeVal) {
            cubit.changeThemeMode(newThemeVal, Colors.white);
          },
          titleText: appWords['darkMode'][cubit.appLanguage],
          secondaryWidget:
              Icon(Icons.nights_stay_outlined, color: cubit.textColor),
        ),
        ///////////////////////////////////////
        const SizedBox(height: 10.0),
        ///////////////////////////////////////
        Text(
          appWords['themeTitle2'][cubit.appLanguage],
          style: defaultTextStyle(color: cubit.textColor, fontSize: 17),
        ),
        ///////////////////////////////////////
        const SizedBox(height: 15.0),
        ///////////////////////////////////////
        Row(
          children: [
            const SizedBox(width: 8),
            containerColor(0, cubit, cubit.defaultColors[0]),
            const SizedBox(width: 6),
            containerColor(1, cubit, cubit.defaultColors[1]),
            const SizedBox(width: 6),
            containerColor(2, cubit, cubit.defaultColors[2]),
            const SizedBox(width: 6),
            containerColor(3, cubit, cubit.defaultColors[3]),
            const SizedBox(width: 6),
            containerColor(4, cubit, cubit.defaultColors[4]),
          ],
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////
  buildRadioListTile({
    required ShopCubit cubit,
    required dynamic radioValue,
    required dynamic groupValue,
    required Function(dynamic)? onChangedFun,
    required String titleText,
    Widget? secondaryWidget,
  }) {
    return RadioListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: radioValue,
      groupValue: groupValue,
      onChanged: onChangedFun,
      activeColor: cubit.primaryColor,
      title: Text(
        titleText,
        style: defaultTextStyle(color: cubit.textColor),
      ),
      secondary: secondaryWidget,
    );
  }

  //////////////////////////////////////////////////////////
  InkWell containerColor(int index, ShopCubit cubit, Color color) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.0),
      onTap: () {
        cubit.changePrimaryColorIndex(index, color);
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: index == cubit.primaryColorIndex
            ? const Icon(Icons.done, color: Colors.white, size: 30)
            : null,
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  Column buildLanguageColumn(ShopCubit cubit, state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildRadioListTile(
          cubit: cubit,
          radioValue: 'en',
          groupValue: cubit.appLanguage,
          onChangedFun: (newVal) {
            cubit.changeAppLanguage(newVal!);
          },
          titleText: 'English',
        ),
        ///////////////////////////
        buildRadioListTile(
          cubit: cubit,
          radioValue: 'ar',
          groupValue: cubit.appLanguage,
          onChangedFun: (newVal) {
            cubit.changeAppLanguage(newVal!);
          },
          titleText: appWords['arabic'][cubit.appLanguage],
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////////
}
