import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String text;
  final String info;
  final IconData icon;

  const InfoCard(
      {Key key, @required this.text, @required this.info, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            this.icon,
            color: Colors.grey,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(this.info,
                    style: TextStyle(
                      fontSize: 20,
                    )),
                SizedBox(
                  height: 2,
                ),
                Text(
                  '$text',
                  style: TextStyle(
                      fontSize: 20,
                      color: corAzul,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
