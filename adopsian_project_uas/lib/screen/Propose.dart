import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:adopsian_project_uas/class/Pet.dart';
import 'package:adopsian_project_uas/main.dart';

class Propose extends StatefulWidget {
  int petID;
  Propose({super.key, required this.petID});

  @override
  State<Propose> createState() => _ProposeState();
}

class _ProposeState extends State<Propose> {
  Pet? _p;

  final _formKey = GlobalKey<FormState>();
  String _keterangan = "";

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

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421039/adoptians/propose.php"),
        body: {
          'users_id': user_id.toString(),
          'pets_id': widget.petID.toString(),
          'description': _keterangan,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Berhasil Melakukan Propose')));
        Navigator.of(context).pop(true);
      } else if (json['result'] == 'duplicate') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have already proposed for this pet!')),
      );
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
          title: Text("Propose Pet"),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              tampilData(),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Keterangan',
                    ),
                    onChanged: (value) {
                      _keterangan = value;
                    },
                    validator: (value) {
                      if (value!.length < 30) {
                        return 'Keterangan kurang panjang';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        !_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Harap Isian diperbaiki')));
                    } else {
                      submit();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        )));
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
}
