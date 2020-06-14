import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage();

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Widget _title(String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget _link(String value) {
    return InkWell(
      onTap: () {
        _launchURL(value);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          value,
          style: const TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: <Widget>[
              _title('# What are sleep cycles? (based on mirror.co.uk)'),
              const Text(
                  '''A sleep cycle lasts about 90 minutes, during which time we move through five stages of sleep - four stages of non-rapid eye movement (NREM) sleep and one stage of rapid eye movement (REM) sleep.
              
  We move from light sleep in Stage 1 to a very deep sleep in Stage 4. It is difficult to wake someone in Stage 4 of a sleep cycle, which is why you might feel more groggy if you wake up during this stage.

  The fifth stage, REM sleep, is when most dreaming occurs.'''),
              _title('# Why choose 14 minutes? (based on mirror.co.uk'),
              const Text(
                  '''The sleep calculator factors in the average of 14 minutes it takes people to naturally fall asleep, so you don\'t necessarily need to be in bed by this time.
                  
  You can adjust it to suit your own needs in profile.'''),
              _title('# Learn more.'),
              _link(
                  'https://www.mirror.co.uk/lifestyle/health/exact-time-sleep-refreshed--10064611'),
              _link('https://www.youtube.com/watch?v=sqUx6TmIIUY'),
              _title('# About me'),
              _link('https://www.github.com/tbm98'),
              _link('https://www.fb.com/tbminh.98'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'A mobile developer ',
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.favorite,
                    color: Colors.pink,
                  ),
                  Text(
                    ' flutter.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              _title('# Source code'),
              _link('https://github.com/tbm98/make_sleep_better')
            ],
          ),
        ));
  }
}
