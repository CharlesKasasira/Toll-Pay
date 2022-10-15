import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tollpay/provider/user.provider.dart';
import 'package:tollpay/utils/color_constants.dart';
import 'package:tollpay/utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  await dotenv.load();
  await Supabase.initialize(
    // TODO: Replace credentials with your own
    url: dotenv.env['YOUR_SUPABASE_URL'],
    anonKey: dotenv.env['YOUR_SUPABASE_ANNON_KEY'],
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WrongUser()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: const Color(0xff1a1a1a),
        /* set Status bar color in Android devices. */
        statusBarIconBrightness: Brightness.light,
        /* icons color in Android devices.*/
        statusBarBrightness: Brightness.light,
      ), /* icons color in iOS. */
    );
    return GetMaterialApp(
      title: 'Toll Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        primaryColor: ColorConstants.ksecondary,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: ColorConstants.ksecondary,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}
