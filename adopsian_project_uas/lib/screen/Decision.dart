import 'package:flutter/material.dart';

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
