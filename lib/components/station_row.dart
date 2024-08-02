import 'package:flutter/material.dart';
import 'station.dart';

double rowHeight = 80.0;

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
      //height: 56, // Used to be 42
      height: rowHeight,
      margin: EdgeInsets.only(bottom: 9.0),
      decoration: BoxDecoration(
        color: Color(0x11FFFFFF),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              //height: 56,
              width: 84, // used to be 56
              decoration: BoxDecoration(
                color: lineBoxColor,
              ),
              child: Center(
                child: Text(
                  line.name,
                  textAlign: TextAlign.left,
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
              height: rowHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 280,
                    //height: 36,
                    margin: EdgeInsets.only(left: 12.0),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      // Normalize the direction to be capitalized.
                      line.direction.toUpperCase() == line.direction
                        ? line.direction[0].toUpperCase() + line.direction.substring(1).toLowerCase()
                        : line.direction,
                      style: TextStyle(
                        fontSize: 27,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  
                  Container(
                    decoration: BoxDecoration(
                      // for debug only
                      //color: Color(0x22FFFFFF),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: line.upcomingDepartures.map<Widget>((departure) {
                        return Container(
                          margin: EdgeInsets.only(left: 12.0),
                          decoration: BoxDecoration(
                            // for debug only
                            color: Color(0x22FFFFFF),
                          ),
                          width: 50,
                          height: 30,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                departure,
                                style: TextStyle(
                                  fontSize: 21,
                                  fontFamily: 'Basier Circle Mono',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}