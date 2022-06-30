import '/models/returned_data_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopChangeThemeModeState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopChangeBottomNavBarState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopChangeIndexCarouselSliderState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopGetHomeDataLoadingState extends ShopStates {}

class ShopGetHomeDataSuccessState extends ShopStates {}

class ShopGetHomeDataErrorState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopGetCategoriesDataSuccessState extends ShopStates {}

class ShopGetCategoriesDataErrorState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopGetCategoryDetailsDataSuccessState extends ShopStates {}

class ShopGetCategoryDetailsDataErrorState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopGetFavoritesDataSuccessState extends ShopStates {}

class ShopGetFavoritesDataErrorState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopGetCartsDataSuccessState extends ShopStates {}

class ShopGetCartsDataErrorState extends ShopStates {}

///////////////////
class ShopChangeFavoriteIconSuccessState extends ShopStates {}

///////////////////
class ShopUpdateFavoriteDataSuccessState extends ShopStates {}

class ShopUpdateFavoriteDataErrorState extends ShopStates {
  final String message;
  ShopUpdateFavoriteDataErrorState(this.message);
}

///////////////////
class ShopUpdateCartDataSuccessState extends ShopStates {
  final String message;
  ShopUpdateCartDataSuccessState(this.message);
}

class ShopUpdateCartDataErrorState extends ShopStates {}

///////////////////
class ShopUpdateCartQuantityLoadingState extends ShopStates {}

class ShopUpdateCartQuantitySuccessState extends ShopStates {}

class ShopUpdateCartQuantityErrorState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopGetUserDataSuccessState extends ShopStates {}

class ShopGetUserDataErrorState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopUpdateUserDataLoadingState extends ShopStates {}

class ShopUpdateUserDataSuccessState extends ShopStates {
  ReturnedDataModel userDataModel;
  ShopUpdateUserDataSuccessState(this.userDataModel);
}

class ShopUpdateUserDataErrorState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopGetSearchDataLoadingState extends ShopStates {}

class ShopGetSearchDataSuccessState extends ShopStates {}

class ShopGetSearchDataErrorState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopChangeCartQuantityValueState extends ShopStates {}

//////////////////////////////////////////////////////////////
class ShopSettingsChangeProfileContainerStatusState extends ShopStates {}

class ShopSettingsChangeThemeContainerStatusState extends ShopStates {}

class ShopSettingsChangeLanguageContainerStatusState extends ShopStates {}

class ShopChangePrimaryColorIndexState extends ShopStates {}

///////////////////////////////////////////////////////////////////////
class ShopChangeAppLanguageState extends ShopStates {}
class ShopChangeAppLanguageSuccessState extends ShopStates {}

///////////////////////////////////////////////////////////////////////
class ShopChangeTextFieldUserDataState extends ShopStates {}

