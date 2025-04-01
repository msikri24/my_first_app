import 'package:flutter/material.dart';
import 'package:flutter_app/res/color.dart';
class RoundButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;


  const RoundButton(
      {super.key, required this.title, required this.loading, required this.onPress,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onPress,
      child: Container(
        height: 40,
        width:195,
        decoration: BoxDecoration(
          color: AppColors.buttonColors,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
              child:loading? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white,)) : Text(title  , style: TextStyle(color: AppColors.whiteColor),),
        ),
      ),

    );
  }
}
