import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Offer'),
      ),
      body: Center(
        child: Text("This is Edit Offer "),
      ),
    );
  }
}
