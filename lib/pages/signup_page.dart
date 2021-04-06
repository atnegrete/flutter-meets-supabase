import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:supabase/supabase.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _confirmPassword;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Signup'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                    decoration: InputDecoration(hintText: 'Enter email'),
                    controller: _email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid email.';
                      }
                      return null;
                    }),
                TextFormField(
                    decoration: InputDecoration(hintText: 'Enter password'),
                    controller: _password,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid password.';
                      }
                      return null;
                    }),
                TextFormField(
                    decoration: InputDecoration(hintText: 'Confirm password'),
                    controller: _confirmPassword,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid password.';
                      }

                      if (value != _password.text) {
                        return 'Confirm password does not match.';
                      }
                      return null;
                    }),
                ElevatedButton(child: Text('Signup'), onPressed: _signup)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _signup() async {
    if (_formKey.currentState.validate()) {
      await Injector.appInstance
          .get<SupabaseClient>()
          .auth
          .signUp(_email.text, _password.text);
    }
  }
}
