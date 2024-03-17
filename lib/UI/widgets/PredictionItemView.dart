import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class PredictionItemView extends StatelessWidget {
  final Prediction prediction;

  const PredictionItemView({required Key key, required this.prediction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          prediction.description!,
        ),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
