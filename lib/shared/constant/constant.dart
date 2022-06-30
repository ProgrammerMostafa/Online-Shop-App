import 'package:flutter/cupertino.dart';

import '/modules/login/login_screen.dart';
import '/shared/components/components.dart';
import '/shared/network/local/cache_helper.dart';

/////////////////////////////////
void userLogout(context) {
  CacheHelper.removeDataFromSharedPreferences(key: 'userToken').then(
    (value) {
      if (value) {
        navigateAndFinish(context, LoginScreen());
      }
    },
  );
}

/////////////////////////////////
void closeKeyboard(context) {
  // To close keyboard
  FocusScope.of(context).unfocus();
}

/////////////////////////////////
dynamic userToken = '';

/////////////////////////////////
var shopLayoutItems = {
  'en': [
    'Home',
    'Categories',
    'Favorites',
    'Settinges',
  ],
  'ar': [
    'الصفحة الرئيسية',
    'الفئات',
    'المفضلة',
    'الإعدادات',
  ],
};

/////////////////////////////////
Map appWords = {
  'loginTitle': {
    'en': 'Log in to your account',
    'ar': 'تسجيل الدخول إلى حسابك',
  },
  'login': {
    'en': 'LOGIN',
    'ar': 'تسجيل الدخول',
  },
  'noAccount': {
    'en': 'Don\'t have an account?',
    'ar': 'لا تملك حساب؟',
  },
  'haveAccount': {
    'en': 'Do you already have an account?',
    'ar': 'هل لديك حساب بالفعل؟',
  },
  'createAccount': {
    'en': 'Create a new account',
    'ar': 'إنشاء حساب جديد',
  },
  'register': {
    'en': 'REGISTER',
    'ar': 'تسجيل',
  },
  'logout': {
    'en': 'LOGOUT',
    'ar': 'تسجيل الخروج',
  },
  /////////////
  'username': {
    'en': 'Username',
    'ar': 'اسم المستخدم',
  },
  'usernameError': {
    'en': 'Please enter your username',
    'ar': 'يرجي إدخال اسم المستخدم الخاص بك',
  },
  'email': {
    'en': 'Email Address',
    'ar': 'عنوان البريد الإلكتروني',
  },
  'emailError': {
    'en': 'Please enter a valid email address',
    'ar': 'يرجى إدخال عنوان بريد إلكتروني صحيح',
  },
  'password': {
    'en': 'Password',
    'ar': 'كلمة المرور',
  },
  'passwordError': {
    'en': 'Password is too short',
    'ar': 'كلمة المرور قصيرة جدا',
  },
  'phone': {
    'en': 'Phone',
    'ar': 'الهاتف',
  },
  'phoneError': {
    'en': 'Please enter your phone number',
    'ar': 'يرجى إدخال رقم هاتفك',
  },
  //////////////
  'home': {
    'en': 'Home',
    'ar': 'الصفحة الرئيسية',
  },
  'categories': {
    'en': 'Categories',
    'ar': 'الفئات',
  },
  'products': {
    'en': 'Products',
    'ar': 'المنتجات',
  },
  'favorites': {
    'en': 'Favorites',
    'ar': 'المفضلة',
  },
  'settings': {
    'en': 'Settings',
    'ar': 'الإعدادات',
  },
  /////////
  'cart': {
    'en': 'Shopping Cart',
    'ar': 'عربة التسوق',
  },
  'addCart': {
    'en': 'Add to cart',
    'ar': 'أضف إلى العربة',
  },
  'total': {
    'en': 'Total',
    'ar': 'المجموع',
  },
  'checkout': {
    'en': 'CHECKOUT',
    'ar': 'إتمام الشراء',
  },
  ///////////
  'account': {
    'en': 'Account',
    'ar': 'الحساب',
  },
  'update': {
    'en': 'Updating Data',
    'ar': 'تحديث البيانات',
  },
  ///////////
  'theme': {
    'en': 'Theme',
    'ar': 'المظهر',
  },
  'lightMode': {
    'en': 'Light Mode',
    'ar': 'الوضع الفاتح',
  },
  'darkMode': {
    'en': 'Dark Mode',
    'ar': 'الوضع الداكن',
  },
  'themeTitle1': {
    'en': 'Choose your application mode',
    'ar': 'اختر وضع التطبيق الخاص بك',
  },
  'themeTitle2': {
    'en': 'Choose your accent color',
    'ar': 'اختر لون التمييز الخاص بك',
  },
  ///////////
  'language': {
    'en': 'Language',
    'ar': 'اللغة',
  },
  'changeLanguage': {
    'en': 'Please wait while changing the application language',
    'ar': 'يرجى الانتظار أثناء تغيير لغة التطبيق',
  },
  'arabic': {
    'en': 'Arabic',
    'ar': 'العربية',
  },
  ///////////
  'search': {
    'en': 'Search...',
    'ar': 'بحث...',
  },
  'noSearch': {
    'en': 'No results found',
    'ar': 'لم يتم العثور على نتائج',
  },
  ////////////
  'messageAdding': {
    'en': 'Added Successfully',
    'ar': 'تمت الإضافة بنجاح',
  },
  'price': {
    'en': 'EGP',
    'ar': 'جنيه',
  },
    ////////////
  'payment': {
    'en': 'Payment Method',
    'ar': 'طريقة الدفع',
  },
};
