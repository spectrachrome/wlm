import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'station_row.dart';

class Line {
    final String type;
    final String name;
    final String direction;
    final List<dynamic> upcomingDepartures;

    Line({
        required this.type,
        required this.name,
        required this.direction,
        required this.upcomingDepartures,
    });
}

enum StationType {
  U,
  S,
}

class StationPanel extends StatelessWidget {
  /// The name of the station.
  final String name;
  final StationType type;
  /// The lines we want to display.
  final List<Line> lines;

  StationPanel({
    required this.name,
    required this.type,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 3 * 36.0) / 2,
      margin: EdgeInsets.only(bottom: 36.0),
      // padding: EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0, bottom: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 36.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 79,
                  width: 79,
                  margin: EdgeInsets.only(right: 18.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: type == StationType.U
                      ? SvgPicture.asset('assets/icons/u_bahn.svg')
                      : SvgPicture.asset('assets/icons/s_bahn.svg'),
                  ),
                ),
                Container(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 48,
                      color: Color(0xFFCCCC33),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...lines.map((line) {
            return StationPanelRow(line: line);
          }).toList(),
        ],
      ),
    );
  }
}