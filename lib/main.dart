import 'package:coolapp/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:supabase/supabase.dart';

import 'pages/home_page.dart';

void main() {
  const supabaseUrl = 'https://ecjlrraxlnjqqavwhvgz.supabase.co';
  const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYxNzUxMjU5NCwiZXhwIjoxOTMzMDg4NTk0fQ.FnnZZEc7P_ylQcaawfp1RedkiHMKeG2-6e76PeSAtx4';
  final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);

  Injector.appInstance.registerSingleton<SupabaseClient>(() => supabaseClient);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}
