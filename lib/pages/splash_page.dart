import 'package:coolapp/pages/home_page.dart';
import 'package:coolapp/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

const persistentSessionKey = 'persistentSessionKey';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    authentication();
  }

  Future<void> authentication() async {
    final supabaseClient = Injector.appInstance.get<SupabaseClient>();
    final sharedPreferences = await SharedPreferences.getInstance();
    final session = sharedPreferences.getString(persistentSessionKey);

    if (session == null) {
      redirectToLogin();
      return;
    } else {
      final response = await supabaseClient.auth.recoverSession(session);
      if (response.error == null) {
        redirectToLogin();
      } else {
        await sharedPreferences.setString(
            persistentSessionKey, response.data.persistSessionString);
      }
    }

    final user = supabaseClient.auth.user();
    if (user == null) {
      // redirect to login
      redirectToLogin();
    } else {
      redirectToHome();
    }
  }

  void redirectToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void redirectToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: CircularProgressIndicator(),
    ));
  }
}
