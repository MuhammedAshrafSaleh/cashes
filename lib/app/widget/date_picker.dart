import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';

// ignore: must_be_immutable
class DatePickerFormField extends StatefulWidget {
  DatePickerFormField({
    super.key,
    required this.controller,
    required this.text,
    required this.validator,
  });
  var controller;
  String? Function(String?)? validator;
  String text;
  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.none,
      onTap: () {
        _selectDate(context); // Show date picker when TextFormField is tapped
      },
      decoration: InputDecoration(
        labelText: widget.text,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            style: BorderStyle.none,
            color: AppTheme.grey,
          ), // Change border color here
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppTheme.grey,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppTheme.primaryColor,
          ),
        ),
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        fillColor: AppTheme.grey,
        filled: true,
      ),
      validator: widget.validator,
    );
  }
}
