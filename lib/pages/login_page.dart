import 'package:coolapp/pages/home_page.dart';
import 'package:coolapp/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';
import 'package:coolapp/pages/splash_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email;
  TextEditingController _password;

  @override
  void initState() {
    super.initState();

    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Enter email'),
                controller: _email,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Enter password'),
                controller: _password,
                obscureText: true,
              ),
              ElevatedButton(child: Text('Login'), onPressed: _login),
              Divider(
                thickness: 2,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Text('Don\'t have an account? Signup!'))
            ],
          ),
        ),
      ),
    );
  }

  Future _login() async {
    final signInResult = await Injector.appInstance
        .get<SupabaseClient>()
        .auth
        .signIn(email: _email.text, password: _password.text);
    if (signInResult != null && signInResult.user != null) {
      final sharedPreferences = await SharedPreferences.getInstance();

      await sharedPreferences.setString(
          persistentSessionKey, signInResult.data.persistSessionString);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (signInResult.error.message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(signInResult.error.message)));
    }
  }
}
