import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/presentation/screens/feedback/feedback_state_notifier.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/delay_animation.dart';
import 'feedback_state.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage();

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<FeedbackStateNotifier>().hasListeners) {
      context.watch<FeedbackStateNotifier>().addListener((state) {
        print(state.listDataWakeUp);
      });
    }
    return Consumer<FeedbackState>(
      builder: (_, state, child) {
        if (state.listDataWakeUp == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (state.listDataWakeUp.isEmpty) {
            return const DelayedAnimation(
              delay: 300,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36),
                  child: Text(
                    'You\'ve finished your sleep, go to the statistics page'
                    ' to see how effective it is.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          } else {
            return _buildListWakeUp();
          }
        }
      },
    );
  }

  Widget _buildListWakeUp() {
    return DelayedAnimation(
      delay: 250,
      child: Consumer2<FeedbackStateNotifier, FeedbackState>(
        builder: (ct, notifier, state, child) {
          return ListView.separated(
              separatorBuilder: (_, __) {
                return const Divider();
              },
              itemCount: state.listDataWakeUp.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(right: 8, bottom: 8),
                        child: Icon(Icons.access_alarm),
                      ),
                      Text(
                        notifier.formatWithDMY(
                            state.listDataWakeUp[index].timeWakeUp),
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontSize: 18),
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
                            child: Icon(Icons.airline_seat_individual_suite),
                          ),
                          Text(notifier.formatWithDMY(
                              state.listDataWakeUp[index].timeSleep)),
                        ],
                      ),
                      Text(
                        '${state.listDataWakeUp[index].cycleSleep} cycles sleep',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: InkWell(
                      onTap: () => _confirmRating(
                          state.listDataWakeUp[index].timeWakeUp, index),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue, width: 0.5)),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Vote',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      )),
                );
              });
        },
      ),
    );
  }

  void _confirmRating(DateTime time, int index) {
    showDialog(
        context: context,
        builder: (ct) {
          return CupertinoAlertDialog(
            title: Text(
                'You woke up at ${context.read<FeedbackStateNotifier>().formatWithDMY(time)}'),
            content: const Text('How do you feel ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<FeedbackStateNotifier>().rating(4, index);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(Icons.delete_forever, color: Colors.red),
                    Text(' My mistake. remove it',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<FeedbackStateNotifier>().rating(1, index);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.red,
                    ),
                    Text(
                      ' Tired',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<FeedbackStateNotifier>().rating(2, index);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(
                      Icons.sentiment_neutral,
                      color: Colors.grey,
                    ),
                    Text(' Normal',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<FeedbackStateNotifier>().rating(3, index);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(Icons.sentiment_satisfied, color: Colors.blue),
                    Text(' Comfortable',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
