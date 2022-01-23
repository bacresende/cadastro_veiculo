import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key key,
      this.action,
      this.label,
      this.color,
      this.textStyle,
      this.width = 320,
      this.radius = 30})
      : super(key: key);
  final String label;
  final Color color;
  final TextStyle textStyle;
  final VoidCallback action;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color ?? corAzul,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: Container(
        width: width,
        height: 50,
        alignment: Alignment.center,
        child: Text(
          label ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            //fontFamily: 'Pero'
          ),
        ),
      ),
      onPressed: action,
    );
  }
}
