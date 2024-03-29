import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

class InputFormField extends StatelessWidget {
  final String hint;
  final String error;
  final Function onChanged;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool enabled;
  final String label;
  final int maxLength;
  final Color textColor;
  final String prefix;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final String counterText;
  
  InputFormField({ this.hint, this.onChanged, this.error, @required this.controller, this.inputType, this.enabled, this.label, this.maxLength, this.textColor, this.prefix = '', this.inputFormatters, this.maxLines, this.counterText });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(alignment: Alignment.bottomLeft, child: Text(label, style: labelFormStyle)),
          TextField(
            controller: controller,
            keyboardType: inputType,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: hintColor),
              hintText: hint,
              errorText: error,
              counterText: counterText ?? '',
              prefix: Text(prefix, style: TextStyle(color: Colors.black87))
            ),
            style: TextStyle(fontSize: 15.0, color: textColor == null ? Colors.black87 : textColor),
            onChanged: onChanged,
            enabled: enabled,
            maxLines: maxLines,
            inputFormatters: inputFormatters
          ),
        ],
      )
    );
  }
}