import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class InputWidget extends StatelessWidget {
  final double topRight;
  final double bottomRight;

  bool error = false;

  InputWidget(this.topRight, this.bottomRight, this.onNameChanged);

  final TextEditingController onNameChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 40, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(bottomRight),
                  topRight: Radius.circular(topRight))),
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 20, top: 10, bottom: 10),
            child: TextFormField(
              controller: onNameChanged,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter a user name, only alpha numeric",
                  hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14),
/*
                  errorText: validateUserName(onNameChanged.text),
                  errorStyle: TextStyle(color: Colors.red),*/
              ),
            ),
          ),
        ),
      ),
    );
  }

  String validateUserName(String val) {
    if(val == null || val.trim().isEmpty && !isAlphanumeric(val.trim())) {
      return "User name must contain a valid alpha numeric string";
    }
    return '';
  }
}