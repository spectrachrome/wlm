import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config.dart';

const LOGO_HEIGHT = 28.0;

class Navbar extends StatelessWidget {
  Navbar();

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 36.0, top: 0, right: 36.0, bottom: 36.0),
      height: config['navbarHeight'],
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
                Container(
                    height: LOGO_HEIGHT,
                    width: LOGO_HEIGHT * (52 / 32),
                    child: SvgPicture.asset('assets/img/logo.svg'),
                ),
            ],
          )
        ],
      ),
    );
  }
}