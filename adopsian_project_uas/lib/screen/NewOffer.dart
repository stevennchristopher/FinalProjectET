import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Offer'),
      ),
      body: Center(
        child: Text("This is New Offer "),
      ),
    );
  }
}
