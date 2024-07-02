import 'package:adopsian_project_uas/screen/Login.dart';
import 'package:adopsian_project_uas/screen/browse.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

void doLogout() async {
  //later, we use web service here to check the user id and password
  final prefs = await SharedPreferences.getInstance();
  active_user = "";
  prefs.remove("user_id");
  main();
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
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
        title: Text("HOME"),
      ),
      // floatingActionButton: myFAB(),
      // bottomNavigationBar: MyBNB(),
      drawer:
          myDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // FloatingActionButton myFAB() {
  //   return FloatingActionButton(
  //     onPressed: 
  //     tooltip:
  //     child: const Icon(Icons.add),
  //   );
  // }

  // BottomNavigationBar MyBNB() {
  //   return BottomNavigationBar(
  //       currentIndex: _currentIndex,
  //       onTap: (int index){
  //         setState(() {
  //           _currentIndex = index;
  //         });
  //       },
  //       fixedColor: const Color.fromARGB(255, 0, 125, 150),
  //       items: [
  //         BottomNavigationBarItem(
  //           label: "Home",
  //           icon: Icon(Icons.home),
  //         ),
  //         BottomNavigationBarItem(
  //           label: "Search",
  //           icon: Icon(Icons.search),
  //         ),
  //         BottomNavigationBarItem(
  //           label: "History",
  //           icon: Icon(Icons.history),
  //         ),
  //       ]);
  // }

  Drawer myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text("Jennie"),
              accountEmail: Text(active_user),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          ListTile(
            title: new Text("Inbox"),
            leading: new Icon(Icons.inbox),
          ),
          ListTile(
            title: new Text("My Basket "),
            leading: new Icon(Icons.shopping_basket),
            onTap: (){
              Navigator.popAndPushNamed(context, 'myBasket');
            }
          ),
          ListTile(
            title: const Text("Add Recipe"),
            leading: const Icon(Icons.add_circle),
            onTap: (){
              Navigator.popAndPushNamed(context, 'addRecipe');
            }),
            Divider(height: 10),
            ListTile(
            title: new Text(active_user != "" ? "Logout" : "Login"),
            leading: new Icon(Icons.login),
            onTap: (){
              active_user != "" ? doLogout() : Navigator.popAndPushNamed(context, 'login');
            })
        ],
      ),
    );
  }
}
