import 'package:adopsian_project_uas/screen/Adopt.dart';
import 'package:adopsian_project_uas/screen/Login.dart';
import 'package:adopsian_project_uas/screen/Offer.dart';
import 'package:adopsian_project_uas/screen/browse.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String username_active_user = "";
String email_active_user = "";

void doLogout() async {
  //later, we use web service here to check the user id and password
  final prefs = await SharedPreferences.getInstance();
  username_active_user = "";
  email_active_user = "";
  prefs.remove("user_id");
  main();
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  username_active_user = prefs.getString("user_username") ?? '';
  email_active_user = prefs.getString("user_email") ?? '';
  return user_id;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADOPTIAN',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 142, 203, 232)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
      routes: {
        'main': (context) => MyApp(),
        'browse': (context) => Browse(),
        'login': (context) => Login(),
        'offer': (context) => Offer(),
        'adopt': (context) => Adopt()
        // 'propose': (context) => Propose()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home"),
      ),
      drawer:
          myDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Drawer myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(username_active_user),
              accountEmail: Text(email_active_user),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          ListTile(
            title: new Text("Browse"),
            leading: new Icon(Icons.search),
            onTap: (){
              Navigator.popAndPushNamed(context, 'browse');
            },
          ),
          ListTile(
            title: new Text("Offer "),
            leading: new Icon(Icons.handshake),
            onTap: (){
              Navigator.popAndPushNamed(context, 'offer');
            }
          ),
          ListTile(
            title: const Text("Adopt"),
            leading: const Icon(Icons.thumb_up),
            onTap: (){
              Navigator.popAndPushNamed(context, 'adopt');
            }),
            Divider(height: 10),
            ListTile(
            title: new Text(username_active_user != "" ? "Logout" : "Login"),
            leading: new Icon(Icons.login),
            onTap: (){
              username_active_user != "" ? doLogout() : Navigator.popAndPushNamed(context, 'login');
            })
        ],
      ),
    );
  }
}
