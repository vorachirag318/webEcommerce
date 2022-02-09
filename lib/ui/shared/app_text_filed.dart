import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final String? suffixText;
  final String? initialValue;
  final String? Function(String?)? validate;
  final Function(String)? onChange;
  final bool obsecureText;
  final TextInputType keyboardType;
  final int maxLines;
  final TextEditingController? controller;
  final AutovalidateMode? autoValidateMode;
  final int? maxLength;
  final bool readOnly;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  TextCapitalization textCapitalization;

  AppTextField(
      {Key? key,
      this.suffixIcon,
      this.hintText,
      this.suffixText,
      this.readOnly = false,
      this.initialValue,
      this.validate,
      this.onChange,
      this.obsecureText = false,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.controller,
      this.autoValidateMode,
      this.maxLength,
      this.inputFormatters,
      this.textCapitalization = TextCapitalization.none})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      maxLength: maxLength,
      autovalidateMode: autoValidateMode,
      controller: controller,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      initialValue: initialValue,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        counterStyle: const TextStyle(color: Colors.black),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        hintText: hintText,
        suffixText: suffixText,
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 0.5, color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 0.5, color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 0.5, color: Colors.transparent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 0.5, color: Colors.transparent),
        ),
      ),
      onChanged: onChange,
      validator: validate,
      obscureText: obsecureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}
