import 'package:flutter/material.dart';
import 'package:lazy_code/lazy_code.dart';

import '../../model/entities/data.dart';

class ListStatisticDialogContent extends StatelessWidget {
  ListStatisticDialogContent(
      this.title, this.color, this.datas, this.format, this.getTrailingWidget);

  String title;
  Color color;
  List<Data> datas;
  String Function(DateTime) format;
  Widget Function(int) getTrailingWidget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(color: color, fontSize: 36),
            ),
            HeightOfScreen(
              percent: 50,
              child: ListView.separated(
                  separatorBuilder: (_, __) {
                    return const Divider();
                  },
                  itemCount: datas.length,
                  itemBuilder: (context, id) {
                    final data = datas[id];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.access_alarm),
                            ),
                            Text(
                              format(data.timeWakeUp),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.only(right: 8, bottom: 4),
                                  child:
                                      Icon(Icons.airline_seat_individual_suite),
                                ),
                                Text(format(data.timeSleep)),
                              ],
                            ),
                            Text(
                              '${data.cycleSleep} cycles sleep',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: getTrailingWidget(data.level),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
