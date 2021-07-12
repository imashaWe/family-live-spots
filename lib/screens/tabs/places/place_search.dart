import 'package:flutter/material.dart';
import '../../../services/place_service.dart';

class PlaceSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlaceSearchState();
}

class _PlaceSearchState extends State<PlaceSearch> {
  final TextEditingController _textEditingController = TextEditingController();
  String _q = '';

  void _onSearch(String q) => setState(() => _q = q);

  void _clear() {
    PlaceService.searchLoction('ginigath');
    return;
    _textEditingController.clear();
    setState(() => _q = '');
  }

  // void _onTapPlace(Place p) {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceView(p)));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        title: TextField(
          controller: _textEditingController,
          style: TextStyle(fontSize: 20),
          onChanged: _onSearch,
          decoration: InputDecoration(
              suffix: GestureDetector(
                child: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onTap: _clear,
              ),
              border: InputBorder.none,
              hintText: 'Search for place'),
          autofocus: true,
        ),
      ),
      body: Center(
          // child: FutureBuilder<List<Place>>(
          //   future: PlaceService.searchPlaces(_q),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //     if (snapshot.hasError) {
          //       print("Eroor");
          //     }

          //     final data = _q.isEmpty ? [] : snapshot.data;
          //     return ListView.builder(
          //       itemCount: data.length,
          //       itemBuilder: (context, int i) => ListTile(
          //         leading: Icon(Icons.place),
          //         title: Text(data[i].name),
          //         subtitle: (Text(
          //           data[i].desc,
          //           overflow: TextOverflow.ellipsis,
          //         )),
          //         onTap: () => _onTapPlace(data[i]),
          //       ),
          //       //separatorBuilder: (context, int i) {},
          //     );
          //   },
          // ),
          ),
    );
  }
}
