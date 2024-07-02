import 'dart:convert';

import 'package:adopsian_project_uas/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String _username = "";
String _user_password = "";
String error_login = "";

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  void doLogin() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421039/adoptians/login.php"),
        body: {'username': _username, 'pass': _user_password});

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("username", _username);
        prefs.setString("email", json['email']);
        main();
      } else {
        setState(() {
          error_login = "Incorrect username or password";
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          height: 300,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              border: Border.all(width: 1),
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 20)]),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  _username = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter username here'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (value) {
                  _user_password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      doLogin();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple)),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                )),
          ]),
        ));
  }
}