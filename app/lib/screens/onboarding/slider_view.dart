import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SliderView extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  const SliderView(
      {required this.title,
      required this.description,
      required this.imagePath,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: h / 4,
            child: SvgPicture.asset(imagePath),
          ),
          SizedBox(
            height: h / 6,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.blueGrey),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
