import 'dart:convert';
import 'dart:io';

import 'package:adopsian_project_uas/class/Pet.dart';
import 'package:adopsian_project_uas/screen/NewOffer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

File? _image;
File? _imageProses;

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
  Pet? _p;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _jenisCont = TextEditingController();
  TextEditingController _nameCont = TextEditingController();
  TextEditingController _descCont = TextEditingController();
  int _id = 0;

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
      _p = Pet.fromJson(json['data']);
      setState(() {
        // _jenis = p!.jenis;
        // _name = p!.name;
        // _desc = p!.description;

        _jenisCont.text = _p!.jenis;
        _nameCont.text = _p!.name;
        _descCont.text = _p!.description;
        _id = _p!.id;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Offer'),
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
                    _p!.name = value;
                  },
                  controller: _nameCont,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama hewan harus diisi';
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Jenis'),
                  onChanged: (value) {
                    _p!.jenis = value;
                  },
                  controller: _jenisCont,
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
                    _p!.description = value;
                  },
                  controller: _descCont,
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
                    update();
                  }
                },
                child: Text('Update'),
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
      _image = File(image.path);
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
      setState(() {
        _imageProses?.writeAsBytesSync(img.writeJpg(temp2));
      });
    });
  }

  void update() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421039/adoptians/updatePet.php"),
        body: {
          'jenis': _p!.jenis,
          'name': _p!.name,
          'description': _p!.description,
          'id': widget.petID.toString()
        });

    if (_imageProses == null) return;
    List<int> imageBytes = _imageProses!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    final response2 = await http.post(
        Uri.parse(
            'https://ubaya.me/flutter/160421039/adoptians/editPetImage.php'),
        body: {
          'image': base64Image,
        });
    if (response2.statusCode == 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response2.body)));
      Navigator.of(context).pop();
    }

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Mengedit Data')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }
}
