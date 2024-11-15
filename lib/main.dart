import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_tracker/screens/home_screen.dart';
import 'package:portfolio_tracker/services/all_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //to register all services and controllers.
  await AllServices().registerServices();
  await AllServices().registerControllers();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //GetMaterialApp instead of MaterialApp(for GetX)
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.quicksandTextTheme(),
          brightness: Brightness.light),
      routes: {
        '/home': (context) {
          return HomeScreen();
        },
      },
      initialRoute: '/home',
    );
  }
}
