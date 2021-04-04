import 'package:coolapp/main.dart';
import 'package:coolapp/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Movie>>(
          future: getMovies(),
          builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            }

            return ListView(
              children: snapshot.data
                  .map((movie) => ListTile(
                        title: Text(movie.name),
                        subtitle: Text(movie.description),
                      ))
                  .toList(),
            );
          }),
    );
  }

  Future<List<Movie>> getMovies() async {
    final response = await supabaseClient
        .from('movies')
        .select()
        .order('name', ascending: true)
        .execute();

    final dataList = response.data as List;
    return dataList.map((map) => Movie.fromJson(map)).toList();
  }
}
