import 'package:flutter/material.dart';
import 'package:flutter_app/view_model/services/splash_services.dart';



class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  _SplashViewState createState() =>  _SplashViewState();

}
class _SplashViewState extends State<SplashView>{
SplashServices splashServices = SplashServices();
 @override
  void initState() {
    splashServices.checkAuthentication(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Center(child: Image.asset('assets/images/images.png' , width:100,)),
    );
  }
}