import 'package:flutter/material.dart';

navigateTo(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: ((context) => widget)));
}

navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: ((context) => widget)), (route) => false);
}

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

Widget defaultTextFormField({
  required String text,
  required TextEditingController TEController,
  required String? Function(String?)? validator,
  void Function()? TapController,
  void Function()? onSubmit,
  TextInputType? inputType = TextInputType.text,
  Icon? prefixIcon,
  IconButton? suffixIcon,
  bool isPassword = false,
  required void Function()? onChange(String),
}) {
  return SizedBox(
    width: double.maxFinite,
    child: TextFormField(
      onChanged: onChange,
      onTap: TapController,
      controller: TEController,
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

// void showToast({
//   required String message,
//   required ToastState state,
// }) {
//   Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 5,
//       backgroundColor: chooseToastColor(state),
//       textColor: Colors.white,
//       fontSize: 16.0);
// }

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
