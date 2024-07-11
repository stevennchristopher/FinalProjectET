import 'package:flutter/material.dart';
import 'package:adopsian_project_uas/class/Pet.dart';
import 'package:adopsian_project_uas/class/Propose.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class DecisionOffer extends StatefulWidget {
  int petID;
  DecisionOffer({super.key, required this.petID});

  @override
  State<StatefulWidget> createState() {
    return _DecisionOffer();
  }
}

@override
State<DecisionOffer> createState() => _DecisionOffer();

class _DecisionOffer extends State<DecisionOffer> {
  Pet? _p;
  List<Propose> _Proposes = [];

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421039/adoptians/detailPet.php"),
        body: {'id': widget.petID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _p = Pet.fromJson(json['data']);
      setState(() {});
    });
  }

  Future<String> fetchDataPropose() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421039/adoptians/getProposeByPetId.php"),
        body: {'id': widget.petID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaDataPropose() {
    _Proposes.clear();

    Future<String> data = fetchDataPropose();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var prop in json['data']) {
        Propose pr = Propose.fromJson(prop);
        _Proposes.add(pr);
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
    bacaDataPropose();
  }

  void submit(int calon_adopter_id) async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421039/adoptians/decision.php"),
        body: {
          'users_id': calon_adopter_id.toString(),
          'pets_id': widget.petID.toString(),
        });

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Berhasil Memilih Adopter!')));
        Navigator.of(context).pop(true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to the server.')),
      );
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Decision Offer'),
        ),
        body: ListView(children: <Widget>[
          Column(children: <Widget>[tampilData()]),
          Container(
            height: MediaQuery.of(context).size.height,
            child: DaftarPropose(_Proposes),
          ),
        ]));
  }

  Widget tampilData() {
    if (_p == null) {
      return const CircularProgressIndicator();
    }
    return SingleChildScrollView(
        child: Card(
            elevation: 10,
            margin: const EdgeInsets.all(10),
            child: Column(children: <Widget>[
              Text("Nama: " + _p!.name, style: const TextStyle(fontSize: 20)),
              Text(""),
              Image.network(
                  "https://ubaya.me/flutter/160421039/adoptians/images/${_p!.id}.jpg"),
              Text("Jenis: " + _p!.jenis),
              Text("Deskripsi: " + _p!.description),
            ])));
  }

  Widget DaftarPropose(Proposes) {
    if (Proposes != null) {
      return ListView.builder(
          itemCount: Proposes.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.people, size: 30),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Username: " + Proposes[index].username_user),
                      Text("Komentar: " + Proposes[index].description),
                      Text(""),
                      ElevatedButton(
                        onPressed: () {
                          submit(Proposes[index].user_id);
                        },
                        child: Text('Choose as Adopter'),
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
