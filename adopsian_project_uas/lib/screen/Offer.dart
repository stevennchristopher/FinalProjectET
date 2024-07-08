import 'package:adopsian_project_uas/screen/Decision.dart';
import 'package:adopsian_project_uas/screen/EditOffer.dart';
import 'package:adopsian_project_uas/screen/NewOffer.dart';
import 'package:flutter/material.dart';
import 'package:adopsian_project_uas/class/PetInOffer.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:adopsian_project_uas/main.dart';

class Offer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OfferState();
  }
}

class _OfferState extends State<Offer> {
  String _temp = 'waiting API respond…';
  List<PetInOffer> _Pets = [];

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421039/adoptians/offer.php"),
        body: {'id': user_id.toString()});
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
        PetInOffer p = PetInOffer.fromJson(pet);
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

  void navigateToDecisionPage(int petID) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DecisionOffer(petID: petID),
      ),
    );

    if (result == true) {
      bacaData();
    }
  }

  void navigateToEditOfferPage(int petID) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOffer(petID: petID),
      ),
    );

    if (result == true) {
      bacaData();
    }
  }

  void delete(int petID) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Offer Pet')),
        body: Column(children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewOffer()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 255, 248, 166),
            ),
            child: Text('New Offer',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                )),
          ),
          Expanded(child: DaftarPet(_Pets)),
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
                  title: Text("Nama: " + Pets[index].name,
                      style: const TextStyle(fontSize: 20)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(""),
                      Image.network(
                          "https://ubaya.me/flutter/160421039/adoptians/images/${Pets[index].id}.jpg"),
                      Text("Jenis: " + Pets[index].jenis),
                      Text("Status: " + Pets[index].status + " Di Apdopsi"),
                      Pets[index].adopterName != 'admin'
                          ? Text("Nama Pengadopsi: " + Pets[index].adopterName)
                          : SizedBox(height: 0),
                      Text("Jumlah pelamar: " +
                          Pets[index].totalProposal.toString()),
                      Text(""),
                      Text("Deskripsi: " + Pets[index].description),
                      Text(""),
                      Pets[index].status == 'Belum'
                          ? ElevatedButton(
                              onPressed: () {
                                navigateToDecisionPage(Pets[index].id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 85, 255, 0),
                              ),
                              child: Text('Decision',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  )),
                            )
                          : SizedBox(height: 0),
                      SizedBox(height: 10),
                      Pets[index].totalProposal.toString() == '0'
                          ? ElevatedButton(
                              onPressed: () {
                                navigateToEditOfferPage(Pets[index].id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 174, 0),
                              ),
                              child: Text('Edit',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  )))
                          : SizedBox(height: 0),
                      SizedBox(height: 10),
                      Pets[index].totalProposal.toString() == '0'
                          ? ElevatedButton(
                              onPressed: () {
                                delete(Pets[index].id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 17, 0),
                              ),
                              child: Text('Delete',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 57, 46, 46),
                                  )),
                            )
                          : SizedBox(height: 0),
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
