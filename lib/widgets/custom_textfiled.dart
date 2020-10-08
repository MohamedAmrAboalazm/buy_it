import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class CustomText extends StatelessWidget {
  final String  hint;
  final IconData icon;
  final Function onClick;

  CustomText({this.onClick,this.hint, this.icon});
 String _errorMessage(String str)
 {
   switch(hint)
       {
         case 'Enter your name' : return 'Name is empty !';
         case 'Enter your email' : return 'Email is empty !';
         case 'Enter your password' : return 'Password is empty !';
       }
 }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        validator: (value)
        {
          if(value.isEmpty)
            {
              return _errorMessage(hint);
            }
        },
        onSaved: onClick,
        obscureText: hint=='Enter your password'?true:false,
        cursorColor: KMainColor,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon:Icon( icon,color:KMainColor),
          filled: true,
          fillColor: KSecondaryColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)
          ),
        ),
      ),
    );
  }
}