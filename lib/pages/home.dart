import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http_demo/models/album.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Album>> futureAlbums;

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();
  }

  Future<List<Album>> fetchAlbums() async {

    //final auth = whatever auth request
    //get your_api_token_here out of auth

    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
      },
    );

    if (response.statusCode == 200) {
      List rawList = jsonDecode(response.body).toList();
      List<Album> list = [];

      for (int i = 0; i < rawList.length; i++) {
        Album album = Album.fromJson(rawList[i]);
        //print(album.title);
        list.add(album);
      }

      return list;
    } else {
      print('Failed to load albums');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Album>>(
          future: futureAlbums,
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.done) {
              List<Album> albums = snapshot.data ?? [];

              return ListView.builder(
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    Album album = albums[index];
                    return new ListTile(
                      title: new Text(album.title),
                    );
                  });

            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

          }
      ),
    );
  }
}
