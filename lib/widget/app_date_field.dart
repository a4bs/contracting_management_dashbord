import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class AppDateField extends StatelessWidget {
  final String name;
  final String? hintText;
  final String? labelText;
  final Color? color;
  final DateTime? initialValue;
  final InputType inputType;
  final DateFormat? format;
  final bool isEnable;
  final double borderRadius;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final IconData? icon;
  final void Function(DateTime?)? onChanged;
  final dynamic Function(DateTime?)? valueTransformer;
  final List<String? Function(DateTime?)>? validator;

  const AppDateField({
    super.key,
    required this.name,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.inputType = InputType.date,
    this.format,
    this.isEnable = true,
    this.color,
    this.borderRadius = 5,
    this.suffixWidget,
    this.prefixWidget,
    this.icon,
    this.onChanged,
    this.valueTransformer,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      name: name,
      initialValue: initialValue,
      inputType: inputType,
      format: format ?? DateFormat('yyyy-MM-dd'),
      enabled: isEnable,
      onChanged: onChanged,
      valueTransformer: valueTransformer,
      validator: FormBuilderValidators.compose(validator ?? []),
      decoration: InputDecoration(
        suffixIcon:
            suffixWidget ??
            (icon != null ? Icon(icon) : const Icon(Icons.calendar_today)),
        prefixIcon: prefixWidget,
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        filled: true,
        fillColor: color,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
