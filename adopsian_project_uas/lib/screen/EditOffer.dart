import 'dart:convert';

import 'package:adopsian_project_uas/class/Pet.dart';
import 'package:adopsian_project_uas/screen/NewOffer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditOffer extends StatefulWidget {
  int petID;
  EditOffer({super.key, required this.petID});

  @override
  State<StatefulWidget> createState() {
    return _EditOffer();
  }
}

@override
State<EditOffer> createState() => _EditOffer();

class _EditOffer extends State<EditOffer> {
  late Pet p;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _jenisCont = TextEditingController();
  TextEditingController _nameCont = TextEditingController();
  TextEditingController _descCont = TextEditingController();

  String _jenis = "";
  String _name = "";
  String _desc = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bacaData();
  }

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
      p = Pet.fromJson(json['data']);
      setState(() {});
    });

    setState(() {
      _jenis = p.jenis;
      _name = p.name;
      _desc = p.description;

      _jenisCont.text = p.jenis;
      _nameCont.text = p.name;
      _descCont.text = p.description;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Offer'),
        ),
        body: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama'),
                  onChanged: (value) {
                    _name = value;
                  },
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Jenis'),
                  onChanged: (value) {
                    _jenis = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenis hewan harus diisi';
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  onChanged: (value) {
                    _desc = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi hewan harus diisi';
                    }
                    return null;
                  },
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      !_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Harap isian diperbaiki.')));
                  } else {
                    update();
                  }
                },
                child: Text('Update'),
              ),
            ),
          ]),
        ));
  }

  void update() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421039/updatePet.php"),
        body: {'jenis': p.jenis, 'name': p.name, 'description': p.description});
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
    } else {
      throw Exception('Failed to read API');
    }
  }
}
