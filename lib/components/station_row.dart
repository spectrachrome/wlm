import 'package:flutter/material.dart';
import 'station.dart';

class StationPanelRow extends StatelessWidget {
  final Line line;

  StationPanelRow({
    required this.line,
  });

  @override
  Widget build(BuildContext context) {
    Color lineBoxColor = Colors.transparent;
    
    switch (line.name) {
      case 'U4':
        lineBoxColor = Color(0xFF337733);
      case 'U6':
        lineBoxColor = Color(0xFF775C33);
      default:
        lineBoxColor = Color(0x22FFFFFF);
    };

    return Container(
      height: 56, // Used to be 42
      margin: EdgeInsets.only(bottom: 9.0),
      decoration: BoxDecoration(
        color: Color(0x11FFFFFF),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 56,
                  width: 84, // used to be 56
                  decoration: BoxDecoration(
                    color: lineBoxColor,
                  ),
                  child: Center(
                    child: Text(
                      line.name,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 12.0),
                  child: Text(
                    // Normalize the direction to be capitalized.
                    line.direction.toUpperCase() == line.direction
                      ? line.direction[0].toUpperCase() + line.direction.substring(1).toLowerCase()
                      : line.direction,
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: line.upcomingDepartures.map<Widget>((departure) {
                return Container(
                  margin: EdgeInsets.only(left: 12.0),
                  decoration: BoxDecoration(
                    // for debug only
                    color: Color(0x00FFFFFF),
                  ),
                  width: 70,
                  height: 63,
                  child: Row(
                    children: [
                      Text(
                        departure,
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                );
              }).toList(),
            ),
          ],
        )
      ),
    );
  }
}