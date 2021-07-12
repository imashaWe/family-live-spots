import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'place_add.dart';

class PlacesView extends StatefulWidget {
  PlacesView({Key? key}) : super(key: key);

  @override
  _PlacesViewState createState() => _PlacesViewState();
}

class _PlacesViewState extends State<PlacesView> {
  Widget placeTypeCard({required Icon icon, required String name}) => Card(
        child: ListTile(
          leading: icon,
          title: Text(name),
          trailing: Icon(Icons.arrow_forward_ios_sharp),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => PlaceAdd())),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Places"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            placeTypeCard(icon: Icon(Icons.home), name: "Add your home"),
            placeTypeCard(icon: Icon(Icons.school), name: "Add your school"),
            placeTypeCard(
                icon: Icon(FontAwesomeIcons.businessTime),
                name: "Add your office"),
            placeTypeCard(
                icon: Icon(Icons.location_pin), name: "Add customer place"),
          ],
        ),
      ),
    );
  }
}
