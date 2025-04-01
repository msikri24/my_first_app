import 'package:flutter/material.dart';
import 'package:flutter_app/utils/routes/routes_name.dart';
import 'package:flutter_app/view/login_screen.dart';
import 'package:flutter_app/view/signUp_screen.dart';
import '../../view/home_screen.dart';
import '../../view/splash_screen.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings setting){
    switch(setting.name){
      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) => HomeScreen());

      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context) => SplashView());

      case RoutesName.signup:
        return MaterialPageRoute(builder: (BuildContext context) => SignupScreen());

      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) => LoginScreen());

      default:
        return MaterialPageRoute(builder:(_){
          return Scaffold(
            body: Center(
              child: Text('No Route Define'),
            ),
          );
        });
    }
  }
}