import 'package:flutter/material.dart';
import 'package:flutter_app/res/components/button.dart';
import 'package:provider/provider.dart';

import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';
import '../view_model/auth_view_model.dart';



class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  _SignupScreenState createState() =>  _SignupScreenState();
}
class _SignupScreenState extends State<SignupScreen>{
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context){
    final authViewMode = Provider.of<AuthViewModel>(context);
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blue,
        foregroundColor: Colors.white,
        title: Text("SignUp"),
      ),
      body:Center(
        child: Container(
          width: 350,
          height: 430,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius:10,
                    color:Colors.black12,
                    spreadRadius:3
                )
              ],
              borderRadius: BorderRadius.circular(8)
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: height * .01,),
                Image.asset('assets/images/images.png' , width:100,),
                SizedBox(height: height * .01,),
                Row(
                  children: [
                    Text("SignUp" , style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: height * .01,),
                TextFormField(
                  controller:_emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your UserName',
                    labelText: "User Name",
                    prefixIcon:Icon(Icons.person_2),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color:Colors.black,
                        width: 1,
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color:Colors.black54,
                        width: 1,
                      ),
                    ),
                  ),
                  onFieldSubmitted:(value){
                    Utils.fieldFocusChange(context , emailFocusNode , passwordFocusNode);
                  },
                ),

                SizedBox(height: height * .02,),

                ValueListenableBuilder(
                    valueListenable: _obscurePassword,
                    builder: (context , value , child){
                      return TextFormField(
                        controller:_passwordController ,
                        obscuringCharacter: '*',
                        obscureText: _obscurePassword.value,
                        focusNode: passwordFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Enter your Password',
                          labelText: "Password",
                          prefixIcon:Icon(Icons.lock),
                          suffixIcon: InkWell(
                              onTap:(){
                                _obscurePassword.value = !_obscurePassword.value;
                              },
                              child: Icon(_obscurePassword.value? Icons.visibility_off_outlined : Icons.visibility)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color:Colors.black,
                              width: 1,
                            ),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color:Colors.black54,
                              width: 1,
                            ),
                          ),
                        ),
                      );
                    }),


                SizedBox(height: height * .02,),
                RoundButton(
                  title: "SignUp",
                  loading: authViewMode.signUpLoading,
                  onPress:(){
                    if(_emailController.text.isEmpty){
                      Utils.flushBarErrorMessage("Please Enter your Email", context);
                    }else if(_passwordController.text.isEmpty){
                      Utils.flushBarErrorMessage("Please Enter your Password", context);
                    }else if(_emailController.text.length<3){
                      Utils.flushBarErrorMessage("Please Enter 3 digit Password", context);
                    }else{
                      Map data = {
                        'email' :_emailController.text.toString(),
                        'password': _passwordController.text.toString(),
                      };


                      authViewMode.signUpApi(data , context);
                    }

                  },),
                SizedBox(height: height * .02,),
                InkWell(
                  onTap:(){
                    Navigator.pushNamed(context, RoutesName.login);
                  },child: Text("Already have an account? Sign In"),
                )
              ],

            ),
          ),
        ),
      ),
    );
  }
}