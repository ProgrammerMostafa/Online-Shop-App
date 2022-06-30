import 'package:flutter_shop_app/models/returned_data_model.dart';

abstract class ShopRegisterStates {}

class ShopRegisterInitialState extends ShopRegisterStates {}

/////////////////////////////////////////////////////////////
class ShopRegisterLoadingState extends ShopRegisterStates {}

class ShopRegisterSuccessState extends ShopRegisterStates {
  final ReturnedDataModel userDataModel;

  ShopRegisterSuccessState(this.userDataModel);
}

class ShopRegisterErrorState extends ShopRegisterStates {
  final String error;
  ShopRegisterErrorState(this.error);
}

/////////////////////////////////////////////////////////////
class ShopRegisterChangePasswordVisibilityState extends ShopRegisterStates {}
