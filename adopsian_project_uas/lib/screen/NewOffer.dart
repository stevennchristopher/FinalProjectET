import 'dart:convert';
import 'dart:io';

import 'package:adopsian_project_uas/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

File? _image;
File? _imageProses;

class NewOffer extends StatefulWidget {
  NewOffer({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewOffer();
  }
}

@override
State<NewOffer> createState() => _NewOffer();

class _NewOffer extends State<NewOffer> {
  final _formKey = GlobalKey<FormState>();
  String _jenis = "";
  String _name = "";
  String _desc = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Offer'),
        ),
        body: SingleChildScrollView(
          child: Form(
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
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: _imageProses != null
                      ? Image.file(_imageProses!)
                      : Image.network("https://ubaya.me/blank.jpg"),
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
                    submit();
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ]),
        )));
  }

    _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 400,
        maxWidth: 400);
    if (image == null) return;
    setState(() {
      prosesFoto();
    });
  }

  void prosesFoto() {
    Future<Directory?> extDir = getTemporaryDirectory();
    extDir.then((value) {
      String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = '${value?.path}/$_timestamp.jpg';
      _imageProses = File(filePath);
      img.Image? temp = img.readJpg(_image!.readAsBytesSync());
      img.Image temp2 = img.copyResize(temp!, width: 480, height: 640);
      img.drawString(temp2, img.arial_24, 4, 4, 'UAS Flutter',
          color: img.getColor(250, 100, 100));
      setState(() {
        _imageProses?.writeAsBytesSync(img.writeJpg(temp2));
      });
    });
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421039/adoptians/newPet.php"),
        body: {
          'jenis': _jenis,
          'name': _name,
          'description': _desc,
          'users_id':user_id
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }
}
