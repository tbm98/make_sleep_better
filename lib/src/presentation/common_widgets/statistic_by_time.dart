import 'package:flutter/material.dart';
import 'package:lazy_code/lazy_code.dart';

import '../../model/entities/data.dart';
import '../../model/entities/data_for_hour.dart';
import '../screens/statistic_detail.dart';
import 'delay_animation.dart';
import 'line_chart.dart';

class StatisticByTime extends StatelessWidget {
  StatisticByTime({this.type, this.height, this.listData, this.action = true}) {
    for (final data in listData) {
      _dataTimeSleep[data.timeSleep.hour].addLevel(data.level);
      _dataTimeWakeUp[data.timeWakeUp.hour].addLevel(data.level);
      _dataCyles[data.cycleSleep].addLevel(data.level);
    }
  }

  final int type;
  final double height;
  final List<Data> listData;
  final bool action;

  final List<DataForHour> _dataTimeSleep =
      List.generate(24, (index) => DataForHour(0, 0, 0));
  final List<DataForHour> _dataTimeWakeUp =
      List.generate(24, (index) => DataForHour(0, 0, 0));
  final List<DataForHour> _dataCyles =
      List.generate(11, (index) => DataForHour(0, 0, 0));

  List<DataForHour> get dataForStatistic {
    switch (type) {
      case 0:
        return _dataTimeSleep;
      case 1:
        return _dataTimeWakeUp;
      case 2:
        return _dataCyles;
    }
    return null;
  }

  List<int> get hourOfType {
    return _hourOfType[type];
  }

  final List<List<int>> _hourOfType = [
    [
      20,
      21,
      22,
      23,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19
    ],
    [
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      0,
      1,
      2,
      3
    ],
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  ];

  @override
  Widget build(BuildContext context) {
    return DelayedAnimation(
      delay: 300,
      child: Container(
        height: height,
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: <Widget>[
            _tileLeftChart(),
            Expanded(child: _listChart()),
          ],
        ),
      ),
    );
  }

  double getPercentHeightLineChart(int index) {
    int max = 0;
    for (int i = 0; i < dataForStatistic.length; i++) {
      if (max < dataForStatistic[i].sum) {
        max = dataForStatistic[i].sum;
      }
    }
    if (max == 0) {
      return 0;
    }
    return dataForStatistic[index].sum / max;
  }

  Widget _tileLeftChart() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            width: 20,
            decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.grey, Colors.red],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  RotatedBox(
                    quarterTurns: 1,
                    child: Text(
                      'Good',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 1,
                    child: Text(
                      'Bad',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text(
          type == 2 ? 'Cycle' : 'Hour',
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _listChart() {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: hourOfType.length,
        separatorBuilder: (_, __) {
          return const Width(16);
        },
        itemBuilder: (context, index) {
          final DataForHour data = dataForStatistic[hourOfType[index]];
          return InkWell(
            onTap: data.sum > 0 && action
                ? () => context.push(
                      (_) => StatisticDetailPage(
                          hourOfType[index], data.sum, listData),
                    )
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: LineChart(
                      height *
                          0.7 *
                          getPercentHeightLineChart(hourOfType[index]),
                      data),
                ),
                Text(hourOfType[index].toString())
              ],
            ),
          );
        });
  }
}
