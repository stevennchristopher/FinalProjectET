import 'dart:convert';

import 'package:adopsian_project_uas/main.dart';
import 'package:adopsian_project_uas/screen/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String _username = "";
String _email = "";
String _phone = "";
String _user_password = "";

class MyRegist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 142, 203, 232)),
      ),
      home: Registration(),
    );
  }
}

class Registration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistState();
  }
}

class _RegistState extends State<Registration> {
  void doRegist() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421039/adoptians/registration.php"),
        body: {
          'username': _username,
          'email': _email,
          'phone': _phone,
          'pass': _user_password
        });

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        setState(() {
          error_regist = "Registration failed, please re-check your data.";
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
          title: Text('Registration'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
            child: Container(
          height: 460,
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
              child: TextField(
                onChanged: (value) {
                  _email = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter email here'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  _phone = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                    hintText: 'Enter phone number here'),
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
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                        onPressed: () {
                          doRegist();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 78, 183, 240))),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),
                      ),
                    ),
                    Text(""),
                    Text(error_regist, style: TextStyle(color: Colors.red)),
                  ],
                )),
          ]),
        )));
  }
}
