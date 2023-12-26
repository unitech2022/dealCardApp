import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:deal_card/bloc/app_cubit/app_cubit.dart';
import 'package:deal_card/bloc/auth_cubit/auth_cubit.dart';
import 'package:deal_card/bloc/business_owners_cubit/business_owners_cubit.dart';
import 'package:deal_card/bloc/business_owners_cubit/business_owners_cubit.dart';
import 'package:deal_card/bloc/cards_cubit/cards_cubit.dart';
import 'package:deal_card/bloc/category_cubit/category_cubit.dart';
import 'package:deal_card/bloc/market_cubit/market_cubit.dart';
import 'package:deal_card/bloc/notification_cubit/notification_cubit.dart';
import 'package:deal_card/bloc/order_cubit/order_cubit.dart';
import 'package:deal_card/bloc/order_cubit/order_cubit.dart';
import 'package:deal_card/bloc/search_cubit/search_cubit.dart';
import 'package:deal_card/bloc/subscribe_cubit/subscribe_cubit.dart';
import 'package:deal_card/core/local_database/local_database.dart';
import 'package:deal_card/core/router/routes.dart';
import 'package:deal_card/core/styles/thems.dart';
import 'package:deal_card/core/utils/payment.dart';
import 'package:deal_card/ui/home_screen/home_screen.dart';
import 'package:deal_card/ui/nnavigation_screen/nnavigation_screen.dart';
import 'package:deal_card/ui/orders_screen/orders_screen.dart';
import 'package:deal_card/ui/payment_test.dart';
import 'package:deal_card/ui/selecte_lang_screen/selecte_lang_screen.dart';
import 'package:deal_card/ui/splash_screen/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrader/upgrader.dart';
import 'bloc/home_cubit/home_cubit.dart';
import 'core/helpers/helper_functions.dart';
import 'core/utils/http_overriddes.dart';

Future<void> _messageHandler(RemoteMessage message) async {}
void initLocalNotification() {
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'recovery',
      channelName: 'recovery',
      channelDescription: "Notification recovery",
      defaultColor: Colors.transparent,
      ledColor: Colors.blue,
      channelShowBadge: true,
      importance: NotificationImportance.High,
      // playSound: true,
      // enableLights:true,
      // enableVibration: false
    )
  ]);
}

void main() async {
  // WidgetsBinding widgetsBinding=

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCwwqvNK5QEeoZ1nnjkHTfFQPL8yOca9jM",
            appId: "app-1-106813810965-ios-15eaed73f8fe018e6a211c",
            messagingSenderId: "106813810965",
            projectId: "dealcard-64837"));
  } else {
    await Firebase.initializeApp();
  }

  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  FirebaseMessaging.onMessageOpenedApp;
  initLocalNotification();
  HttpOverrides.global = MyHttpOverrides();
  await EasyLocalization.ensureInitialized();
  await Upgrader.clearSavedSettings();
  await readData();

await PaymentIntegration().configureSDK();
  // await LocalDatabaseHelper().createDataBase();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale("ar"), Locale("en")],
        path: "assets/i18n",
        // <-- change the path of the translation files
        fallbackLocale: const Locale("ar"),
        startLocale: const Locale("ar"),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit()),
        BlocProvider<AuthCubit>(create: (BuildContext context) => AuthCubit()),
        BlocProvider<AppCubit>(create: (BuildContext context) => AppCubit()),
        BlocProvider<CategoryCubit>(
            create: (BuildContext context) => CategoryCubit()),
        BlocProvider<MarketCubit>(
            create: (BuildContext context) => MarketCubit()),
        BlocProvider<CardsCubit>(
            create: (BuildContext context) => CardsCubit()),
        BlocProvider<SubscribeCubit>(
            create: (BuildContext context) => SubscribeCubit()),
        BlocProvider<NotificationCubit>(
            create: (BuildContext context) => NotificationCubit()),
        BlocProvider<SearchCubit>(
            create: (BuildContext context) => SearchCubit()),
        BlocProvider<OrderCubit>(
            create: (BuildContext context) => OrderCubit()),
        BlocProvider<BusinessOwnersCubit>(
            create: (BuildContext context) => BusinessOwnersCubit()),
      ],
      child: MaterialApp(
          title: "Deal Card",
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: lightTheme(context),
          initialRoute: splash,
          routes: {
            splash: (context) => const SplashScreen(),
            test: (context) => PaymentTest(),
            lang: (context) => const SelectLangeScreen(),

            // homeProvider: (context) => HomeProviderScreen(),
            home: (context) => const HomeScreen(),
            // navUser: (context) => const NavigationUserScreen(),
            // // detailsProvider: (context) => const DetailsProviderScreen(),
            orders: (context) => const OrdersScreen(),
            // fav: (context) => FavoriteScreen(),
            // notyUser: (context) => NotificationsScreen(),
            // abouteUs: (context) => AboutUsScreen(),
            // praivcy: (context) => PrivacyScreen(),
             nav: (context) => NavigationScreen(),
            // statistics: (context) => StatisticsScreen(),
            // quizscreen: (context) => QuizScreen(),
          }),
    );
  }
}
