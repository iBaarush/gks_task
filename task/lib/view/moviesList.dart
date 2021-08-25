import 'package:flutter/material.dart';
import 'package:task/controller/movieDataApi.dart';

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late Map data;
  @override
  void initState() {
    print('inside intitstate');
    // TODO: implement initState
    method();

    super.initState();
  }

  void method() async {
    getData().then((Map s) => setState(() {
          data = s;
        }));
    print('after future intitstate');

    print(data);
    print(data['result'].runtimeType);
    List<Map<dynamic, dynamic>> liOfMovieObjects = data["result"];
    print(liOfMovieObjects);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
