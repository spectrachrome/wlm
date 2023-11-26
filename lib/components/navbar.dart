import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config.dart';

const LOGO_HEIGHT = 42.0;

class Navbar extends StatelessWidget {
  Navbar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: LOGO_HEIGHT,
      width: LOGO_HEIGHT * (52 / 32),
      child: SvgPicture.asset('assets/img/logo.svg'),
    );
  }
}