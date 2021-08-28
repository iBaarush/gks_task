import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:task/controller/movieDataApi.dart';

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  var liOfActualData;
  var _isLoading = true;
  int vote_counter = 0;
  List<int> votesFreq = [];
  late Future data;
  @override
  void initState() {
    super.initState();
    method();
  }

  void method() async {
    network().getData().then((Map s) => setState(() {
          liOfActualData = s['result'];
          var lenOfLiOfActualData = liOfActualData.length;
          votesFreq = List.filled(lenOfLiOfActualData, 0);
          setState(() {
            _isLoading = false;
          });
        }));
    print('after future intitstate');
    print(votesFreq);
  }

  Future fetch() async {
    var local_data;
    network net = network();
    local_data = net.getData();
    return local_data;
  }

  Widget createListView(List data, BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int index) {
        String stars = data[index]['stars'].toString();
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  //votes
                  Column(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => {
                          setState(() {
                            votesFreq[index]++;
                            print(votesFreq.toString());
                          })
                        },
                        icon: const Icon(Icons.arrow_upward),
                        tooltip: 'increase votes',
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text(
                          votesFreq[index].toString(),
                          style: TextStyle(),
                        ),
                      ),
                      IconButton(
                        onPressed: () => {
                          setState(() {
                            votesFreq[index]--;
                          })
                        },
                        icon: const Icon(Icons.arrow_downward),
                        tooltip: 'decrease votes',
                      ),
                      Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Text('Votes'))
                    ],
                  ),
                  //votes

                  //poster
                  Container(
                    width: 70,
                    child: Image.network(data[index]['poster']),
                  ),
                  //poster

                  //details
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    padding: EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width - 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          data[index]['title'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Genre: ' + data[index]['genre'],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          'Director: ' + data[index]['director'][0],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Container(
                          child: Text(
                            'Starring: ' + stars.substring(1, stars.length - 1),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Text(
                          data[index]['runtime'].toString() +
                              ' | ' +
                              data[index]['language'] +
                              ' | ' +
                              data[index]['releasedDate'].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //details
                ],
              ),
              //button
              ElevatedButton(
                onPressed: () => {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Watch trailer'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 30),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                'List of Movies',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : createListView(liOfActualData, context),
            ),
          ],
        ),
      ),
    );
  }
}

class network {
  Map reqDat = {
    "category": "movies",
    "language": "kannada",
    "genre": "all",
    "sort": "voting"
  };
  final String url1 = 'https://hoblist.com/movieList';

  Future<Map> getData() async {
    Uri url = Uri.parse(url1);
    String body = json.encode(reqDat);

    http.Response response = await http
        .post(url, body: body, headers: {"Content-Type": "application/json"});
    print(response.statusCode);

    return json.decode(response.body);
  }
}
