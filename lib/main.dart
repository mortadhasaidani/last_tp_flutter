import 'dart:convert';

import 'package:compte_rendu/data/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/album.dart';

Future<List<Album>> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    return body.map<Album>(Album.fromJson).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Album>> futureAlbum;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data from api'),
        ),
      body: FutureBuilder<List<Album>>(
          future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4.0,
                          style: BorderStyle.solid
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10)
                        )
                      ),
                      child: Column(
                        children: [
                          Text(snapshot.data![index].title),
                          SizedBox(height: 10),
                          Text(snapshot.data![index].body)
                        ],
                      ),
                    );
                  },
                );
                // return Text(snapshot.data!.length.toString());
              } else if(snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },

        ),
      );
  }
}
