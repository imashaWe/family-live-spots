import 'package:family_live_spots/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'slider_view.dart';

class OnBoardingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int _index = 0;
  final _slides = [
    SliderView(
        title: 'Welcome',
        description: "See your family's location\n on the map",
        imagePath: "assets/svgs/onb-1.svg"),
    SliderView(
        title: 'Stay Connected',
        description:
            "Get real time alerts as your family\n members come and go.",
        imagePath: "assets/svgs/onb-2.svg"),
    SliderView(
        title: 'Movements History',
        description: "Check the history of your family's\n whereabouts",
        imagePath: "assets/svgs/onb-3.svg"),
  ];
  void _next() {
    setState(() => _index++);
  }

  void _done() {
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            child: Text("Skip"),
            onPressed: _done,
          ),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: _slides[_index],
        ),
        AnimatedSmoothIndicator(
          activeIndex: _index,
          count: _slides.length,
          effect: WormEffect(),
        ),
        ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
            onPressed: _index == 2 ? _done : _next,
            child: Text(
              _index == 2 ? "Done" : "Next",
              style: TextStyle(fontSize: 18),
            )),
      ],
    ));
  }
}
