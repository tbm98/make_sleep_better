import 'dart:math' as math;

import 'package:code_faster/code_faster.dart';
import 'package:flutter/material.dart';

import '../obj/data_for_hour.dart';

class LineChart extends StatelessWidget {
  const LineChart(this._maxHeight, this.data);

  final double _maxHeight;
  final DataForHour data;

  double get maxHeight {
    return math.max(_maxHeight, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Height(maxHeight, child: _getLine());
  }

  Widget _getLine() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(data.sum.toString()),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: maxHeight,
            width: 40,
            child: _componentsLine(),
          ),
        ),
      ],
    );
  }

  Widget _componentsLine() {
    if (maxHeight == 1) {
      return Container(
        color: Colors.blue,
        height: maxHeight,
        width: 40,
      );
    }
    return Column(
      children: <Widget>[
        Container(
          color: Colors.red,
          height: maxHeight * data.unpt,
          width: 40,
        ),
        Container(
          color: Colors.grey,
          height: maxHeight * data.nopt,
          width: 40,
        ),
        Container(
          color: Colors.blue,
          height: maxHeight * data.sapt,
          width: 40,
        ),
      ],
    );
  }
}
