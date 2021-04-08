import 'package:coolapp/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:supabase/supabase.dart';

void main() {
  const supabaseUrl = 'https://rcpcxnwwpxtfexykdvnl.supabase.co';
  const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYxNzgwNjMwNywiZXhwIjoxOTMzMzgyMzA3fQ.cMEwSwpKYmut_U4s9d9VpRnB5Oi99MhLeskgfr5w8eg';
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
