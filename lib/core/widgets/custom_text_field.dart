import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIcon;
  final Function(String)? onSubmit;
  final Function(String)? onChange;
  final bool? obscureText;
  final String errorMsg;
  final TextInputType keyboardType;
  final bool? isNextTabEnable;
  final TextInputAction textInputAction;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText,
    required this.errorMsg,
    required this.keyboardType,
    this.isNextTabEnable = true,
    this.onSuffixIcon,
    this.suffixIcon,
    this.onChange,
    this.onSubmit,
    required this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onFieldSubmitted: onSubmit,
        cursorColor: Theme.of(context).colorScheme.primary,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xffE8ECF4)),
          ),
          fillColor: const Color(0xffF7F8F9),
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14.0,
            color: Color(0xff8391A1),
          ),
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: onSuffixIcon,
            color: const Color(0xff6A707C),
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
        textAlign: TextAlign.start,
        obscureText: obscureText ?? false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorMsg;
          }
          return null;
        },
        onChanged: onChange,
      ),
    );
  }
}
