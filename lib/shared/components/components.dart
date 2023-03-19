import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Components Used more than once during the project

// navigte to another screen
navigateTo(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: ((context) => widget)));
}

// Navigate to another screen without the ability to go back
navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: ((context) => widget)), (route) => false);
}

// Custom Button I made
Widget defaultButton({
  Color background = Colors.blue,
  double height = 40,
  double width = double.infinity,
  required String text,
  required void Function()? function,
}) {
  return Container(
    color: background,
    height: height,
    width: width,
    child: MaterialButton(
      onPressed: function,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

// Custom defaultTextFormField (Used to collect data)
Widget defaultTextFormField({
  required String text,
  required TextEditingController tEController,
  required String? Function(String?)? validator,
  void Function()? tapController,
  void Function()? onSubmit,
  TextInputType? inputType = TextInputType.text,
  Icon? prefixIcon,
  IconButton? suffixIcon,
  bool isPassword = false,
  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names, use_function_type_syntax_for_parameters
  required void Function()? onChange(String),
}) {
  return SizedBox(
    width: double.maxFinite,
    child: TextFormField(
      onChanged: onChange,
      onTap: tapController,
      controller: tEController,
      keyboardType: inputType,
      validator: validator,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: text,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    ),
  );
}

// Show message for a certain time (Registerd Successfully, Can't login, Etc)
void showToast({
  required String message,
  required ToastState state,
}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

// Toast Colors Based on Condition

// ignore: constant_identifier_names
enum ToastState { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastState state)
{
  Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
