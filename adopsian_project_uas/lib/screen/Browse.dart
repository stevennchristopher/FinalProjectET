import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:adopsian_project_uas/class/Pet.dart';
import 'package:adopsian_project_uas/screen/Propose.dart';
import 'package:http/http.dart' as http;

class Browse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BrowseState();
  }
}

class _BrowseState extends State<Browse> {
  String _temp = 'waiting API respond…';
  List<Pet> _Pets = [];

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421039/adoptians/browse.php"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    _Pets.clear();

    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var pet in json['data']) {
        Pet p = Pet.fromJson(pet);
        _Pets.add(p);
      }

      setState(() {
        _temp = _Pets[0].description;
      });
    });
  }

  void initState() {
    super.initState();
    bacaData();
  }

  void navigateToProposePage(int petID) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Propose(petID: petID),
      ),
    );

    if (result == true) {
      bacaData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Browse Pet')),
        body: ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: DaftarPet(_Pets),
          ),
        ]));
  }

  Widget DaftarPet(Pets) {
    if (Pets != null) {
      return ListView.builder(
          itemCount: Pets.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.pets, size: 30),
                  title: Text("Nama: " + Pets[index].name, style: const TextStyle(fontSize: 20)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(""),
                      Image.network(
                          "https://ubaya.me/flutter/160421039/adoptians/images/${Pets[index].id}.jpg"),
                      Text("Jenis: " + Pets[index].jenis),
                      Text("Deskripsi: " + Pets[index].description),
                      Text("Jumlah pelamar: " + Pets[index].totalProposal.toString()),
                      Text(""),
                      ElevatedButton(
                        onPressed: () {
                          navigateToProposePage(Pets[index].id);
                        },
                        child: Text('Propose'),
                      ),
                    ],
                  ),
                ),
              ],
            ));
          });
    } else {
      return CircularProgressIndicator();
    }
  }
}
