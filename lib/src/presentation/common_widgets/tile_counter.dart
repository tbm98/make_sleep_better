import 'package:flutter/material.dart';

class TileCounter extends StatelessWidget {
  const TileCounter(this.color, this.number, this.name, this.showDialog);

  final Color color;
  final int number;
  final String name;
  final VoidCallback showDialog;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: InkWell(
            onTap: showDialog,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  number.toString(),
                  style: TextStyle(fontSize: 36, color: color),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(name),
                ),
              ],
            ),
          ),
        ));
  }
}
