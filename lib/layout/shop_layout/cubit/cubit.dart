import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/shared/network/local/cache_helper.dart';
import '/models/returned_data_model.dart';
import '/models/carts_model.dart';
import '/modules/home/home_screen.dart';
import '/models/category_products_model.dart';
import '/models/categories_model.dart';
import '/models/favorites_model.dart';
import '/models/home_model.dart';
import '/shared/constant/constant.dart';
import '/shared/network/end_points.dart';
import '/shared/network/remote/dio_helper.dart';
import '/modules/categories/categories_screen.dart';
import '/modules/favorites/favorites_screen.dart';
import '/modules/settings/settings_screen.dart';
import '/layout/shop_layout/cubit/states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState()) {
    getAllSavedDataSharedPreferences();
  }
  static ShopCubit get(context) => BlocProvider.of(context);

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  int currentIndexBottomNavBar = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeIndexBottomNavBar(index) {
    currentIndexBottomNavBar = index;
    emit(ShopChangeBottomNavBarState());
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  HomeModel? homeModel;
  Future<void> getHomeData() async {
    emit(ShopGetHomeDataLoadingState());
    await DioHelper.getData(
      url: homeUrl,
      language: appLanguage,
      token: userToken,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      /////////// Fill the favoritesMap with inFavorites value
      for (var i = 0; i < homeModel!.data!.products.length; i++) {
        favoritesMap.addAll({
          homeModel!.data!.products[i].productID!:
              homeModel!.data!.products[i].inFavorites!
        });
        //////////////////////
        cartsMap.addAll({
          homeModel!.data!.products[i].productID!:
              homeModel!.data!.products[i].inCart!
        });
      }
      emit(ShopGetHomeDataSuccessState());
    }).catchError((error) {
      emit(ShopGetHomeDataErrorState());
    });
  }

  ////////////////////////////////////
  Map<int, bool> favoritesMap = {};
  Map<int, bool> cartsMap = {};
  ////////////////////////////////////
  void changeFavoriteIcon(int productID) {
    favoritesMap[productID] = !favoritesMap[productID]!;
    emit(ShopChangeFavoriteIconSuccessState());
    DioHelper.postData(
      url: getFavoritesUrl,
      language: appLanguage,
      token: userToken,
      data: {'product_id': productID},
    ).then((value) {
      if (value.data['status']) {
        getFavoritesData();
        emit(ShopUpdateFavoriteDataSuccessState());
      } else {
        favoritesMap[productID] = !favoritesMap[productID]!;
        emit(ShopUpdateFavoriteDataErrorState(value.data['message']));
      }
    }).catchError((error) {
      emit(ShopUpdateFavoriteDataErrorState(error.toString()));
    });
  }

  ///////////////////////////////////////
  FavoritesModel? favoritesModel;
  Future<void> getFavoritesData() async {
    await DioHelper.getData(
      url: getFavoritesUrl,
      language: appLanguage,
      token: userToken,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(ShopGetFavoritesDataSuccessState());
    }).catchError((error) {
      emit(ShopGetFavoritesDataErrorState());
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  CategoriesModel? categoriesModel;
  Future<void> getCategoriesData() async {
    await DioHelper.getData(
      url: getCategoriesUrl,
      language: appLanguage,
      token: userToken,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopGetCategoriesDataSuccessState());
    }).catchError((error) {
      emit(ShopGetCategoriesDataErrorState());
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  CategoryProductsModel? categoryProductsModel;
  void getCategoryDetails({required int categoryID}) {
    // get all products for a selected categoryID
    DioHelper.getData(
      url: '$getCategoriesUrl/$categoryID',
      language: appLanguage,
      token: userToken,
    ).then((value) {
      categoryProductsModel = CategoryProductsModel.fromJson(value.data);
      emit(ShopGetCategoryDetailsDataSuccessState());
    }).catchError((error) {
      emit(ShopGetCategoryDetailsDataErrorState());
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  CategoryProductsModel? searchProductsModel;
  void getSearchProducts({required String searchValue}) {
    emit(ShopGetSearchDataLoadingState());
    // get all products for search value
    if (searchValue.trim().isNotEmpty) {
      DioHelper.postData(
        url: searchUrl,
        language: appLanguage,
        token: userToken,
        data: {'text': searchValue},
      ).then((value) {
        searchProductsModel = CategoryProductsModel.fromJson(value.data);
        emit(ShopGetSearchDataSuccessState());
      }).catchError((error) {
        emit(ShopGetSearchDataErrorState());
      });
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  int currentIndexCarouselSlider = 0;
  void changeIndexCarouselSlider(index) {
    currentIndexCarouselSlider = index;
    emit(ShopChangeIndexCarouselSliderState());
  }

  /////////////////////////////////////////////////////////////////////////////
  int cartQuantity = 1;
  void changeCartQuantityValue({required cartQuantity}) {
    emit(ShopChangeCartQuantityValueState());
  }

  /////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////
  CartsModel? cartsModel;
  Future<void> getCartsData() async {
    await DioHelper.getData(
      url: getCartsUrl,
      language: appLanguage,
      token: userToken,
    ).then((value) {
      cartsModel = CartsModel.fromJson(value.data);
      emit(ShopGetCartsDataSuccessState());
    }).catchError((error) {
      emit(ShopGetCartsDataErrorState());
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<void> addOrRemoveCartData(int productID) async {
    await DioHelper.postData(
      url: getCartsUrl,
      language: appLanguage,
      token: userToken,
      data: {'product_id': productID},
    ).then((value) {
      cartsMap[productID] = !cartsMap[productID]!;
      emit(ShopUpdateCartDataSuccessState(value.data['message']));
      // To update cartQuantity value
      if (cartQuantity > 1) {
        updateCartQuantity(value.data['data']['id'], cartQuantity);
      } else {
        getCartsData();
      }
    }).catchError((error) {
      emit(ShopUpdateCartDataErrorState());
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<void> updateCartQuantity(int cartID, int quantity) async {
    emit(ShopUpdateCartQuantityLoadingState());
    await DioHelper.putData(
      url: '$getCartsUrl/$cartID',
      language: appLanguage,
      token: userToken,
      data: {'quantity': quantity},
    ).then((value) {
      emit(ShopUpdateCartQuantitySuccessState());
      getCartsData();
    }).catchError((error) {
      emit(ShopUpdateCartQuantityErrorState());
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  int returnCartQuantity(int productID) {
    int index = cartsModel!.data!.cartItems.indexWhere((element) {
      return element.product!.productID == productID;
    });
    if (index == -1) {
      return cartQuantity;
    } else {
      return cartsModel!.data!.cartItems[index].quantity!;
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  ReturnedDataModel? userDataModel;
  String usernameValue = '';
  String emailValue = '';
  String phoneValue = '';
  void getUserData() {
    DioHelper.getData(
      url: getProfileUrl,
      language: appLanguage,
      token: userToken,
    ).then((value) {
      userDataModel = ReturnedDataModel.fromJson(value.data);
      usernameValue = userDataModel!.data!.name!;
      emailValue = userDataModel!.data!.email!;
      phoneValue = userDataModel!.data!.phone!;
      emit(ShopGetUserDataSuccessState());
    }).catchError((error) {
      emit(ShopGetUserDataErrorState());
    });
  }

  void changeTextFieldUserData(String newValue, String type) {
    switch (type) {
      case 'username':
        usernameValue = newValue;
        break;
      case 'email':
        emailValue = newValue;
        break;
      case 'phone':
        phoneValue = newValue;
        break;
    }
    emit(ShopChangeTextFieldUserDataState());
  }

  /////////////////////////////////////////////////////////////////////////////
  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopUpdateUserDataLoadingState());
    DioHelper.putData(
      url: updateProfileUrl,
      token: userToken,
      language: appLanguage,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userDataModel = ReturnedDataModel.fromJson(value.data);
      emit(ShopUpdateUserDataSuccessState(
          ReturnedDataModel.fromJson(value.data)));
    }).catchError((error) {
      emit(ShopUpdateUserDataErrorState());
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  bool isProfileContainerOpen = false;
  void changeProfileContainerStatus() {
    isProfileContainerOpen = !isProfileContainerOpen;
    emit(ShopSettingsChangeProfileContainerStatusState());
  }

  //////////////////////////////////////////////////////////////////////////////
  bool isThemeContainerOpen = false;
  void changeThemeContainerStatus() {
    isThemeContainerOpen = !isThemeContainerOpen;
    emit(ShopSettingsChangeThemeContainerStatusState());
  }

  //////////////////////////////////////////////////////////////////////////////
  bool isLanguageContainerOpen = false;
  void changeLanguageContainerStatus() {
    isLanguageContainerOpen = !isLanguageContainerOpen;
    emit(ShopSettingsChangeLanguageContainerStatusState());
  }

  ////////////////////////////////////////////////////////////////////////////////
  // ThemeMode themeMode = ThemeMode.dark;
  // Color textColor = Colors.white;
  ThemeMode themeMode = ThemeMode.light;
  Color textColor = Colors.black;
  void changeThemeMode(ThemeMode newThemeMode, Color newTextColor) async {
    themeMode = newThemeMode;
    textColor = newTextColor;
    emit(ShopChangeThemeModeState());
    /////////////////////
    await CacheHelper.saveDataInSharedPreferences(
      key: 'darkMode',
      value: themeMode == ThemeMode.dark,
    );
  }

  //////////////////////////////////
  int primaryColorIndex = 0;
  List defaultColors = [
    Colors.deepOrange,
    Colors.teal,
    Colors.blue,
    Colors.pink,
    Colors.deepPurple,
  ];
  dynamic primaryColor = Colors.deepOrange;

  void changePrimaryColorIndex(int newIndex, dynamic color) async {
    primaryColorIndex = newIndex;
    primaryColor = color;
    emit(ShopChangePrimaryColorIndexState());
    //////////////////
    await CacheHelper.saveDataInSharedPreferences(
      key: 'primaryColor',
      value: primaryColorIndex,
    );
  }

  //////////////////////////////////
  String appLanguage = 'ar'; // en --or-- ar
  int changingLanguage = 0;
  void changeAppLanguage(String newValue) {
    appLanguage = newValue;
    changingLanguage = 1;
    emit(ShopChangeAppLanguageState());
    ////////////////
    CacheHelper.saveDataInSharedPreferences(
      key: 'appLanguage',
      value: appLanguage,
    ).then((value) async {
      await getHomeData();
      await getCategoriesData();
      await getFavoritesData();
      await getCartsData();
      changingLanguage = 0;
      emit(ShopChangeAppLanguageSuccessState());
    });
  }

  ///////////////
  void changeAppLanguageLoginRegister() {
    if (appLanguage == 'en') {
      appLanguage = 'ar';
    } else {
      appLanguage = 'en';
    }
    emit(ShopChangeAppLanguageState());
    ////////////////
    CacheHelper.saveDataInSharedPreferences(
      key: 'appLanguage',
      value: appLanguage,
    ).then((value) async {
      emit(ShopChangeAppLanguageSuccessState());
    });
  }

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  void getAllSavedDataSharedPreferences() {
    //// Get Theme Mode //////////////////////////////////////////////////
    bool? darkModeValue =
        CacheHelper.getDataFromSharedPreferences(key: 'darkMode');
    if (darkModeValue != null) {
      themeMode = darkModeValue ? ThemeMode.dark : ThemeMode.light;
      textColor = darkModeValue ? Colors.white : Colors.black;
    }

    //// Get Primary Color ////////////////////////////////////////////////
    int? pcIndex =
        CacheHelper.getDataFromSharedPreferences(key: 'primaryColor');
    primaryColorIndex = pcIndex ?? 0;
    primaryColor = defaultColors[primaryColorIndex];

    //// Get App Language ////////////////////////////////////////////////
    String? lang = CacheHelper.getDataFromSharedPreferences(key: 'appLanguage');
    appLanguage = lang ?? 'en';
  }
}
