import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;          // 🔥 changed from hint
  final IconData icon;
  final bool isPassword;
  final int maxLines;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,       // 🔥 floating label
    required this.icon,
    this.isPassword = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final isPwd = widget.isPassword;

    return TextField(
      controller: widget.controller,
      obscureText: isPwd ? _obscure : false,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,        // 🔥 FLOATING LABEL
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: Icon(widget.icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: isPwd
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        )
            : null,
      ),
    );
  }
}
