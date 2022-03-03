/*import 'package:flutter/material.dart';
import 'dart:async';
import 'package:usage_stats/usage_stats.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<EventUsageInfo> events = [];
  Map<String?, NetworkInfo?> _netInfoMap = Map();

  @override
  void initState() {
    super.initState();
    initUsage();
  }

  Future<void> initUsage() async {
    UsageStats.grantUsagePermission();
    DateTime endDate = new DateTime.now();
    DateTime startDate = DateTime(2020, 2, 2, 0, 0, 0);
    // DateTime startDate = endDate.subtract(Duration(days: 1));

    List<EventUsageInfo> queryEvents =
        await UsageStats.queryEvents(startDate, endDate);
    List<NetworkInfo> networkInfos =
        await UsageStats.queryNetworkUsageStats(startDate, endDate);
    Map<String?, NetworkInfo?> netInfoMap = Map.fromIterable(networkInfos,
        key: (v) => v.packageName, value: (v) => v);

    List<UsageInfo> t = await UsageStats.queryUsageStats(startDate, endDate);

    /*for (var i in t) {
      if (double.parse(i.totalTimeInForeground!) > 0) {
        print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.firstTimeStamp!))
            .toIso8601String());

        print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.lastTimeStamp!))
            .toIso8601String());

        print(i.packageName);
        print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.lastTimeUsed!))
            .toIso8601String());
        print(int.parse(i.totalTimeInForeground!) / 1000 / 60);

        print('-----\n');
      }
    }*/

    this.setState(() {
      events = queryEvents.reversed.toList();
      _netInfoMap = netInfoMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Usage Stats"), actions: [
          IconButton(
            onPressed: UsageStats.grantUsagePermission,
            icon: Icon(Icons.settings),
          )
        ]),
        body: Container(
          child: RefreshIndicator(
            onRefresh: initUsage,
            child: ListView.separated(
              itemBuilder: (context, index) {
                var event = events[index];
                var networkInfo = _netInfoMap[event.packageName];
                return ListTile(
                  title: Text(events[index].appName!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Last time used: ${DateTime.fromMillisecondsSinceEpoch(int.parse(events[index].timeStamp!)).toIso8601String()}"),
                      /*  networkInfo == null
                          ? Text("Unknown network usage")
                          : Text("Received bytes: ${networkInfo.rxTotalBytes}\n" +
                              "Transfered bytes : ${networkInfo.txTotalBytes}"),*/
                    ],
                  ),
                  // trailing: Text(events[index].eventType!),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: events.length,
            ),
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<AppUsageInfo> _infos = [];

  @override
  void initState() {
    super.initState();
  }

  void getUsageStats() async {
    try {
      DateTime endDate = new DateTime.now();
      DateTime now = new DateTime.now();
      DateTime startDate = new DateTime(now.year, now.month, now.day);
      // DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage.getAppUsage(startDate, endDate);
      setState(() {
        _infos = infoList;
      });

      for (var info in infoList) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Usage Example'),
          backgroundColor: Colors.green,
        ),
        body: ListView.separated(
          itemCount: _infos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_infos[index].appName[0].toUpperCase() +
                  _infos[index].appName.substring(1)),
              trailing: Text(_infos[index].usage.toString()),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: getUsageStats, child: Icon(Icons.file_download)),
      ),
    );
  }
}
