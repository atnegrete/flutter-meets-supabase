import 'package:coolapp/pages/home_page.dart';
import 'package:coolapp/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:supabase/supabase.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await Future.delayed(Duration(seconds: 5));
      final supabaseClient = Injector.appInstance.get<SupabaseClient>();
      final user = supabaseClient.auth.user();
      if (user == null) {
        // redirect to login
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: CircularProgressIndicator(),
    ));
  }
}
