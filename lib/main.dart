import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          title: const Text(
            'What movie now playing can you suggest?',
            style: TextStyle(color: Colors.amber),
          ),
          backgroundColor: Colors.blueGrey.shade900,
          centerTitle: true,
        ),
        body: const MagicBallPage(),
      ),
    );
  }
}

class MagicBallPage extends StatefulWidget {
  const MagicBallPage({Key? key}) : super(key: key);

  @override
  State<MagicBallPage> createState() => _MagicBallPageState();
}

class _MagicBallPageState extends State<MagicBallPage> {
  int index = -1;
  List nowPlaying = [];

  getMovies() async {
    final response = await Dio().get(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=631c41f7f6ce868918b5a484565a830d');
    nowPlaying = response.data['results'];
    print(
        '${nowPlaying.length} + ${nowPlaying[nowPlaying.length - 1]['title']}');
  }

  changeIndex() {
    setState(() {
      index = Random().nextInt(nowPlaying.length - 1);
      print(index);
      print(nowPlaying[index]['vote_average']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getMovies();
      // print(
      //     '${nowPlaying.length} + ${nowPlaying[nowPlaying.length - 1]['title']}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                changeIndex();
              },
              child: index != -1
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${nowPlaying[index]['poster_path']}')
                  : Image.asset(
                      'images/playnowbutton1.png',
                      width: 200,
                    ),
            ),
          ),
          if (nowPlaying.length != 0)
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.movie),
                    title: Text(nowPlaying[index]['title']),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: RatingBarIndicator(
                      rating: nowPlaying[index]['vote_average'].toDouble(),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 10,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
