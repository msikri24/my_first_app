
import 'package:flutter/material.dart';

TextStyle mTextStyle(){
  return TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18
  );
}

ButtonStyle mTextButton(){
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Optional: rounded corners
    ),
  );
}

ButtonStyle mTextButton2(){
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Optional: rounded corners
    ),
  );
}