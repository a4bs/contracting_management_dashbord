import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as form;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AppTextFiled extends StatefulWidget {
  final String name;
  final String? hintText;
  final String? labelText;
  final Color? color;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<String? Function(String?)>? validator;
  final IconData? icon;
  final bool isPassword;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final int? maxLines;
  final bool? isNumber;
  final bool isEnable;
  final bool? isMony;
  final double borderRadius;
  final bool? isEnglish;
  final bool? isRtl;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final void Function(String?)? onChanged;

  AppTextFiled({
    super.key,
    required this.name,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.isMony = false,
    this.keyboardType,
    this.validator,
    this.icon,
    this.borderRadius = 5,
    this.isPassword = false,
    this.suffixWidget,
    this.prefixWidget,
    this.maxLines = 1,
    this.isNumber = false,
    this.initialValue,
    this.isEnglish = false,
    this.isEnable = true,
    this.color,
    this.textInputAction,
    this.isRtl = false,
    this.onChanged,
  });

  @override
  State<AppTextFiled> createState() => _AppTextFiledState();
}

class _AppTextFiledState extends State<AppTextFiled> {
  bool _obscureText = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      enabled: widget.isEnable,
      name: widget.name,
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      focusNode: _focusNode,
      keyboardType: widget.isNumber == true
          ? TextInputType.number
          : widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: [
        if (widget.isNumber!) FilteringTextInputFormatter.digitsOnly,
        if (widget.isEnglish!)
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
        if (widget.isMony!)
          TextInputFormatter.withFunction((oldValue, newValue) {
            String newText = newValue.text;
            if (newText.isEmpty) {
              return newValue.copyWith(text: '');
            }

            // Calculate number of "meaningful" characters (digits and dots) before cursor
            int initialCursor = newValue.selection.baseOffset;
            int meaningfulCharsBeforeCursor = 0;
            for (int i = 0; i < initialCursor && i < newText.length; i++) {
              if (RegExp(r'[0-9.]').hasMatch(newText[i])) {
                meaningfulCharsBeforeCursor++;
              }
            }

            String formatted = formatMony(newText);

            int newCursor = formatted.length;
            if (meaningfulCharsBeforeCursor == 0) {
              newCursor = 0;
            } else {
              int count = 0;
              for (int i = 0; i < formatted.length; i++) {
                if (RegExp(r'[0-9.]').hasMatch(formatted[i])) {
                  count++;
                }
                if (count == meaningfulCharsBeforeCursor) {
                  newCursor = i + 1;
                  break;
                }
              }
            }

            return newValue.copyWith(
              text: formatted,
              selection: TextSelection.collapsed(offset: newCursor),
            );
          }),
      ],

      obscureText: _obscureText,
      validator: FormBuilderValidators.compose(widget.validator ?? []),
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : widget.suffixWidget,
        prefixIcon: widget.prefixWidget != null
            ? widget.prefixWidget
            : (widget.icon != null ? Icon(widget.icon) : null),
        hintText: widget.hintText,
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        filled: true,
        fillColor: widget.color,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  String formatMony(String text) {
    if (text.isEmpty) return text;

    // إزالة أي أحرف غير رقمية باستثناء الفواصل والنقاط
    String cleanedText = text.replaceAll(RegExp(r'[^0-9.]'), '');

    // إذا كانت السلسلة فارغة
    if (cleanedText.isEmpty) return '';

    // التحقق من صلاحية الرقم (لمنع حالات النقاط المتعددة)
    if (double.tryParse(cleanedText) == null) {
      return text;
    }

    // تقسيم النص إلى جزء صحيح وجزء عشري للحفاظ على النقطة والأصفار العشرية أثناء الكتابة
    List<String> parts = cleanedText.split('.');

    // تنسيق الجزء الصحيح
    String integerPart = parts[0];
    if (integerPart.isNotEmpty) {
      final number = double.parse(integerPart);
      integerPart = form.NumberFormat('#,###').format(number);
    }

    // إذا كان هناك جزء عشري (أو نقطة في نهاية النص)
    if (parts.length > 1) {
      String decimalPart = parts[1];
      // تحديد عدد الخانات العشرية بخانتين فقط
      if (decimalPart.length > 2) {
        decimalPart = decimalPart.substring(0, 2);
      }
      return '$integerPart.$decimalPart';
    }

    return integerPart;
  }
}
