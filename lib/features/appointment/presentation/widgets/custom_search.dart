import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 8), 
      child: Container(
        height: 50,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: <Widget>[
            CustomTextField()
          ]
        )
      )
    );
  }
}

class CustomTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          hintText: "Buscar",
          border: InputBorder.none,
        ),
      ),
    );
  }
}