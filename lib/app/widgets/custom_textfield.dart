import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String initialValue;
  final void Function(String) onChange;
  final String Function(String) validator;
  final EdgeInsets padding;
  final Color color;
  final String hint;
  final String label;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final bool readyOnly;
  final Widget prefix;
  final Widget suffix;
  final bool obscureText;

  const CustomTextFormField(
      {Key key,
      this.initialValue,
      this.onChange,
      this.validator,
      this.padding,
      this.color,
      this.hint,
      this.label,
      this.keyboardType,
      this.inputFormatters,
      this.readyOnly,
      this.prefix,
      this.suffix,
      this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 15.0),
      child: Theme(
        data: ThemeData(
            primaryColor: color ?? corAzul,
            accentColor: corAzul,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        child: TextFormField(
          readOnly: this.readyOnly ?? false,
          initialValue: initialValue ?? '',
          obscureText: this.obscureText ?? false,
          onChanged: onChange != null
              ? (String valor) {
                  onChange(valor);
                }
              : (String valor) {},
          cursorColor: color ?? corAzul,
          keyboardType: keyboardType ?? TextInputType.text,
          style: TextStyle(
            color: color ?? corAzul,
            fontSize: 18,
          ),
          decoration: InputDecoration(
              prefix: Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: this.prefix,
                  ) ??
                  null,
              suffix: this.suffix ?? null,
              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
              labelText: label ?? '',
              hintText: hint ?? '',
              filled: false,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
          validator: (String valor) {
            return validator != null ? validator(valor) : null;
          },
          inputFormatters: inputFormatters ?? [],
        ),
      ),
    );
  }
}
