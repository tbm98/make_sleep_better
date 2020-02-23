import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/obj/data.dart';
import 'package:make_sleep_better/src/supports/dates.dart';
import 'package:make_sleep_better/src/supports/file_store.dart';
import 'package:make_sleep_better/src/supports/sizes.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage();

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  DateSupport _dateSupport;
  FileStore _fileStore;
  Future<List<Data>> _listDataWakeUpFuture;
  List<Data> _listDataWakeUp;

  @override
  void initState() {
    super.initState();
    _dateSupport = DateSupport();
    _fileStore = const FileStore();
//    _listDataWakeUpFuture = _getListWakeUpNotYetRated();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        _buildStatisticCounter(),
        _buildStatisticByTime(),
      ],
    );
  }

  Widget _buildStatisticCounter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Statistic counter',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: TileCounter(Colors.green, 20, 'Total')),
            Expanded(
                child: TileCounter(Colors.red, 20, 'Unsatisfied')),
            Expanded(
                child: TileCounter(Colors.grey, 20, 'Normal')),
            Expanded(
                child: TileCounter(Colors.blue, 20, 'Satisfied')),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticByTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Statistic by time',
            style: TextStyle(fontSize: 20),
          ),
        ),
        _buildListStatisticByTime()
      ],
    );
  }

  Widget _buildListStatisticByTime() {
    final double height = Sizes.getHeightNoAppbar(context) * 0.25;
    return Container(
      height: height,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: 20,
                  decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: [Colors.blue, Colors.grey, Colors.red],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                ),
              ),
              const Text('Hour')
            ],
          ),
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 24,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Flexible(
                            child:
                                LayoutBuilder(builder: (context, constrains) {
                              final _height = constrains.maxHeight;
                              return LineChart(
                                  _height / (index % 3 + 1), 100, 50, 20);
                            }),
                          ),
                          Text((index + 1).toString())
                        ],
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}

class TileCounter extends StatelessWidget {
  const TileCounter(this.color, this.number, this.name);

  final Color color;
  final int number;
  final String name;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
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
        ));
  }
}

class LineChart extends StatelessWidget {
  const LineChart(this.height, this.a, this.b, this.c);

  final double height;
  final int a, b, c;

  int get sum => a + b + c;

  double get apt => a / sum * 100;

  double get bpt => b / sum * 100;

  double get cpt => c / sum * 100;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: height,
        child: Column(
          children: <Widget>[
            Container(
              height: apt * height / 100,
              width: 20,
              color: Colors.blue,
            ),
            Container(
              height: bpt * height / 100,
              width: 20,
              color: Colors.grey,
            ),
            Container(
              height: cpt * height / 100,
              width: 20,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
