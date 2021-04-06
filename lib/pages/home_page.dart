import 'package:coolapp/models/movie.dart';
import 'package:coolapp/pages/signup_page.dart';
import 'package:coolapp/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:supabase/supabase.dart';

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

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 500,
                    child: ListView(
                      children: snapshot.data
                          .map((movie) => ListTile(
                                title: Text(movie.name),
                                subtitle: Text(movie.description),
                              ))
                          .toList(),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await Injector.appInstance
                            .get<SupabaseClient>()
                            .auth
                            .signOut();

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SplashPage()),
                            (route) => false);
                      },
                      child: Text('Sign Out'))
                ],
              ),
            );
          }),
    );
  }

  Future<List<Movie>> getMovies() async {
    final response = await Injector.appInstance
        .get<SupabaseClient>()
        .from('movies')
        .select()
        .order('name', ascending: true)
        .execute();

    final dataList = response.data as List;
    return dataList.map((map) => Movie.fromJson(map)).toList();
  }
}
