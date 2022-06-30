import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/returned_data_model.dart';
import '/modules/register/cubit/state.dart';
import '/shared/network/end_points.dart';
import '/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());
  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  //////////////////////////////////////////////

  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////
  bool isButtonRegisterClicked = false;
  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String appLanguage,
  }) {
    isButtonRegisterClicked = true;
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      url: registerUrl,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
      language: appLanguage,
    ).then((value) {
      emit(ShopRegisterSuccessState(ReturnedDataModel.fromJson(value.data)));
    }).catchError((error) {
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////
  bool isPasswordObscure = true;
  IconData icon = Icons.visibility;
  void changePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    icon = isPasswordObscure ? Icons.visibility : Icons.visibility_off;
    emit(ShopRegisterChangePasswordVisibilityState());
  }
}
