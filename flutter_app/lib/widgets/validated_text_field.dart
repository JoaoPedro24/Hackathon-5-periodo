import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ValidatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final double? maxValue;
  final double? minValue;
  final Function(double?)? onChanged;
  final bool enabled;
  final String? label;

  const ValidatedTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxValue,
    this.minValue,
    this.onChanged,
    this.enabled = true,
    this.label,
  });

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  String? errorText;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateInput);
    super.dispose();
  }

  void _validateInput() {
    final text = widget.controller.text;
    String? newErrorText;

    if (text.isNotEmpty) {
      final value = double.tryParse(text);
      
      if (value == null) {
        newErrorText = 'Valor inválido';
      } else {
        if (widget.minValue != null && value < widget.minValue!) {
          newErrorText = 'Valor mínimo: ${widget.minValue}';
        } else if (widget.maxValue != null && value > widget.maxValue!) {
          newErrorText = 'Valor máximo: ${widget.maxValue}';
        }
      }
    }

    if (newErrorText != errorText) {
      setState(() {
        errorText = newErrorText;
      });
    }

    // Chamar callback se não houver erro
    if (widget.onChanged != null) {
      if (text.isEmpty) {
        widget.onChanged!(null);
      } else if (newErrorText == null) {
        final value = double.tryParse(text);
        widget.onChanged!(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 11),
            suffixIcon: widget.controller.text.isNotEmpty && errorText == null
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : errorText != null
                    ? const Icon(Icons.error, color: Colors.red, size: 20)
                    : null,
          ),
        ),
      ],
    );
  }
}

class FormValidationHelper {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Deixa validação de obrigatório para validateRequired
    }
    
    if (double.tryParse(value) == null) {
      return '$fieldName deve ser um número válido';
    }
    
    return null;
  }

  static String? validateRange(String? value, double min, double max, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    final numValue = double.tryParse(value);
    if (numValue == null) {
      return '$fieldName deve ser um número válido';
    }
    
    if (numValue < min || numValue > max) {
      return '$fieldName deve estar entre $min e $max';
    }
    
    return null;
  }

  static bool isFormValid(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  static void showValidationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

