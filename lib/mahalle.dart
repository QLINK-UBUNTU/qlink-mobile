import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class sehir extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Center( child :Text('Şehir(Özel Mülk) hatları ')),
        backgroundColor: Color(0xFF3AB795),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const SizedBox(height: 50),
          buildRow([
            buildCard('A Mahallesi'),
            buildCard('B Mahalelsi'),
          ]),
          const SizedBox(height: 100),
          buildRow([
            buildCard('C Mahallesi'),
            buildCard('D Mahallesi'),
          ]),
          const SizedBox(height: 100),
          buildRow([
            buildCard('E Mahallesi '),
            buildCard('F Mahallesi'),
          ]),
        ],
      ),);


  }
  Widget buildRow(List<Widget> children) {
    return Row(
      children: children.map((child) {
        return Expanded(child: child);
      }).toList(),
    );
  }

  Widget buildCard(String title) {
    return Card(
      elevation: 4,
      child: Container(
        width: 100,
        height: 100,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}