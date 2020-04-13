import 'package:code_faster/code_faster.dart';
import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/obj/data.dart';
import 'package:make_sleep_better/src/theme.dart';
import 'package:make_sleep_better/src/widgets/statistic_by_time.dart';

import 'delay_animation.dart';

class StatisticDetailPage extends StatelessWidget {
  StatisticDetailPage(this.timeSleep, this.count, this.listData);

  final int timeSleep;
  final int count;
  final List<Data> listData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Go to sleep at $timeSleep o\'clock'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'You have slept a total of $count times at this time.',
                  style: styleOf([bold, 18]),
                ),
              ),
              _buildStatisticByCycle(context),
              _buildStatisticByWakeUp(context),
            ],
          ),
        ));
  }

  Widget _buildStatisticByCycle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Cyclic statistics.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _buildStatisticByTime(2, context)
      ],
    );
  }

  Widget _buildStatisticByWakeUp(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Statistics by wake time.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _buildStatisticByTime(1, context)
      ],
    );
  }

  Widget _buildStatisticByTime(int type, BuildContext context) {
    final double height = context.getH(30);
    final List<Data> _listData = List.from(listData)
      ..removeWhere((data) => data.timeSleep.hour != timeSleep);
    return StatisticByTime(
      type: type,
      height: height,
      listData: _listData,
      action: false,
    );
  }
}
