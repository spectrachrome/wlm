import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../components/station.dart';
import '../components/navbar.dart';

import '../config.dart';

class RealTimeInfo extends StatefulWidget {
  @override
  _RealTimeInfoState createState() => _RealTimeInfoState();
}

class _RealTimeInfoState extends State<RealTimeInfo> {
  bool useMockData = false;
  dynamic realTimeData;
  dynamic wlmConfig;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getData();
    fetchConfig();
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => getData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void getData() async {
    if (useMockData) {
      final String response = await rootBundle.loadString('assets/json/mock_response.json');
      final data = await json.decode(response);
      setState(() {
        realTimeData = data;
      });
    } else {
      fetchRealTimeData();
    }
  }

  Future<void> fetchConfig() async {
    String url = 'http://192.168.0.24/wlm_config.json'; // Your API URL
    try {
      var res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        setState(() {
          wlmConfig = json.decode(res.body);
        });
      } else {
        // Handle error
        print("Failure: ${res.statusCode}");
      }
    } catch (e) {
      // Handle network error
      print("Error: $e");
    }
  }

  Future<void> fetchRealTimeData() async {
    String url = 'https://www.wienerlinien.at/ogd_realtime/monitor?rbl=101&rbl=118&rbl=384&rbl=353&rbl=4404&rbl=4433&rbl=4440&rbl=4439&rbl=4627&rbl=4651'; // Your API URL
    try {
      var res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        setState(() {
          realTimeData = json.decode(res.body);
        });
      } else {
        // Handle error
        print("Failure: ${res.statusCode}");
      }
    } catch (e) {
      // Handle network error
      print("Error: $e");
    }
  }

  List<dynamic> get monitors {
    return realTimeData != null ? realTimeData['data']['monitors'] : [];
  }

  bool isDepartureTooSoon(Map<String, dynamic> departure) {
    return departure['departureTime']['countdown'] < 3;
  }

  bool isDepartureTooLate(Map<String, dynamic> departure) {
    return departure['departureTime']['countdown'] > 30;
  }

  List<Map<String, dynamic>> get stations {
    var stationsMap = <String, Map<String, dynamic>>{};

    for (var monitor in monitors) {
      var stationTitle = monitor['locationStop']['properties']['title'];
      // Debugging: Print station title
      print('Processing station: $stationTitle');

      if (!stationsMap.containsKey(stationTitle)) {
        stationsMap[stationTitle] = {
          'name': stationTitle,
          'locationStop': monitor['locationStop'],
          'lines': <Map<String, dynamic>>[]
        };
      }

      for (var line in monitor['lines']) {
        var newLine = Map<String, dynamic>.from(line);

        // Debugging: Print line name
        print('Processing line: ${line['name']}');

        var deps = line['departures']['departure'];
        
        // Filter out any that are too early or too late
        var filteredDepartures = deps
          .where((departure) => !isDepartureTooSoon(departure))
          .where((departure) => !isDepartureTooLate(departure));

        // Extract the 
        newLine['departures'] = filteredDepartures.map((departure) {
          print(departure['departureTime']['countdown']);
          return departure['departureTime'];
        }).toList();
/*
        newLine['departures'] = line['departures']['departure']
          // Remove departures that are too early or too late
          .where((departure) => departure['departureTime']['countdown'] > 3)
          .map((departure) {
            print(departure['departureTime']['countdown']);
            return departure['departureTime'];
          })
          .toList();
*/

        var stationEntry = stationsMap[stationTitle];
        if (stationEntry != null) {
          stationEntry['lines'].add(newLine);
        }
      }
    }

    return stationsMap.entries.map((entry) {
      return {
        'name': entry.key,
        'locationStop': entry.value['locationStop'],
        'lines': entry.value['lines']
      };
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    if (realTimeData == null) {
      return Center(child: CircularProgressIndicator());
    }

    var panels = stations.map<Widget>((station) {
      var stationType = StationType.U;

      if (station['name'] == 'Franz-Josefs-Bahnhof S') {
        stationType = StationType.S;
      }

      return StationPanel(
        name: station['name'],
        type: stationType,
        lines: station['lines'].map<Line>((line) {
          return Line(
            name: line['name'],
            type: line['type'],
            direction: line['towards'],
            upcomingDepartures: line['departures'].map((departure) {
              return departure['countdown'].toString();
            }).toList(),
          );
        }).toList(),
      );
    }).toList();

    print(panels.length);

    return Scaffold(
      // appBar: AppBar(title: Text('Real Time Info')),
      body: Container(
        padding: EdgeInsets.only(
          left: config['viewMargin'] as double,
          right: config['viewMargin'] as double,
          top: 12.0,
          bottom: 0.0,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF000f17),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 24,
              right: 24,
              child: Navbar(),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: panels/*[
                      Container(
                        width: MediaQuery.of(context).size.width - 2 * (config['viewMargin'] as double),
                        child: panels[2],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [panels[1], panels[0]],
                      ),
                    ]*/,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}