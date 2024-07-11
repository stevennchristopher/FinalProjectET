import 'package:flutter/material.dart';
import 'package:adopsian_project_uas/class/Pet.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Decision Offer'),
      ),
      body: Center(
        child: Text("This is Decision Offer "),
      ),
    );
  }
}
