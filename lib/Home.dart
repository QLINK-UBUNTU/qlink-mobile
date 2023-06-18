import 'package:flutter/material.dart';
import 'Kamu_Hatlari.dart';
import 'ilce.dart';
import 'firebase_options/messaging.dart';
import 'package:fl_chart/fl_chart.dart';

class Home extends StatefulWidget {
  const Home({key});


  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

  final _service = FirebaseMessagingService();

  @override
  void initState() {

    _service.connetctNotification();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Center(child: Text('Qlink')),
        backgroundColor: const Color(0xFF3AB795),
      ),
      backgroundColor: const Color(0xFFEEECEC),
      body: Center(
        child: Column(

          children: [
            Card(
              color: Color(0xFFEEECEC),

              child: Container(
                margin: EdgeInsets.all(20),



                width: 420,
                height: 220,

                child: PieChart(

                  PieChartData(

                    sections: _generateChartData(),

                    centerSpaceRadius: 70,
                    sectionsSpace: 3,

                  ),

                ),

              ),

            ),
            const SizedBox(height: 25),


            Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => kamu()),
                  );
                },
                onLongPress: () {},
                child: Container(
                  width: 300,
                  height: 200,

                  child: const Center(
                    child: Text(
                      'Kamu Hatları',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),

            ),
            const SizedBox(height: 5),
            Card(
              color: Colors.white,
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sehir()),
                  );
                },
                onLongPress: () {},
                child: Container(
                  width: 300,
                  height: 200,
                  child: const Center(
                    child: Text(
                      ' Şehir Hatları',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateChartData() {
    final data = <PieChartSectionData>[
      PieChartSectionData(
        value: 3,
        color: Color(0XFF2A2B2A),
        title: 'Kamu hatları',
        radius: 70,
        titleStyle: TextStyle(fontSize: 14, color: Colors.white),

      ),
      PieChartSectionData(
        value: 97,

        color: Color(0XFF8D77F8),

        title: 'Şehir Hatları',
        radius: 70,
        titleStyle: TextStyle(fontSize: 14, color: Colors.white),

      ),
    ];

    return data;
  }
}