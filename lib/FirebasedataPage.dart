import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlink/widgets/notifiers.dart';


class FirebaseUpdater extends StatefulWidget {
  const FirebaseUpdater({Key? key}) : super(key: key);

  @override
  State<FirebaseUpdater> createState() => _FirebaseUpdaterState();
}

class _FirebaseUpdaterState extends State<FirebaseUpdater> {

  final databaseRef = FirebaseDatabase(databaseURL: 'https://qlink-c75ee-default-rtdb.europe-west1.firebasedatabase.app').reference();

  @override
  void initState(){
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await Firebase.initializeApp();
    print("init");
    DatabaseReference ref = databaseRef.child('qlink');
    ref.get().then((DataSnapshot snapshot) {
      if (snapshot.value is Map<dynamic, dynamic>) {
        final dataMap = Map<String, dynamic>.from(snapshot.value as Map);
        if (dataMap?.containsKey('status') ?? false) {
          final status = dataMap['status'] == "true" ? true : false;
          print("status: $status");
          Provider.of<LineNotifier>(context, listen: false).changeSingleActiveStatus(status, 0);
        }
      }
    });
  }

  void _fetchStatusFromFirebase() {
    LineNotifier lineNotifier = Provider.of<LineNotifier>(context, listen: false);

    DatabaseReference ref = databaseRef.child('qlink');
    ref.onValue.listen((event) { // onValue dinleyicisi ekleniyor
      print("hi");
      final snapshot = event.snapshot;
      if (snapshot.value is Map<dynamic, dynamic>) {
        final dataMap = Map<String, dynamic>.from(snapshot.value as Map);
        if (dataMap.containsKey('status')) {
          final status = dataMap['status'] == "true" ? true : false;
          lineNotifier.changeSingleActiveStatus(status, 0); // Durumu güncelle
          print("Değer: ${lineNotifier.isEnergyActive[0]}");
        }
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LineNotifier>(
      builder: (context, lineNotifier ,_) {
        _fetchStatusFromFirebase();
        return Container();},
    );
  }
}



class FirebaseRTDBPage extends StatefulWidget {

  @override
  _FirebaseRTDBPageState createState() => _FirebaseRTDBPageState();
}

class _FirebaseRTDBPageState extends State<FirebaseRTDBPage> {
  final databaseRef = FirebaseDatabase(databaseURL: 'https://qlink-c75ee-default-rtdb.europe-west1.firebasedatabase.app').reference();
  Map? dataMap;

  @override
  void initState() {
    super.initState();
    getData();
  }



  void _fetchStatusFromFirebase() {
    LineNotifier lineNotifier = Provider.of<LineNotifier>(context, listen: false);

    DatabaseReference ref = databaseRef.child('qlink');
    ref.onValue.listen((event) { // onValue dinleyicisi ekleniyor
      final snapshot = event.snapshot;
      if (snapshot.value is Map<dynamic, dynamic>) {
        final dataMap = Map<String, dynamic>.from(snapshot.value as Map);
        if (dataMap?.containsKey('status') ?? false) {
          final status = dataMap['status'] == "true" ? true : false;
          lineNotifier.changeSingleActiveStatus(status, 0); // Durumu güncelle
          print("Değer: ${lineNotifier.isEnergyActive[0]}");
        }
      }
    });
  }

  Future<void> getData() async {
    await Firebase.initializeApp();
    DatabaseReference ref = databaseRef.child('qlink');
    ref.get().then((DataSnapshot snapshot) {
      if (snapshot.value is Map<dynamic, dynamic>) {
        final dataMap = Map<String, dynamic>.from(snapshot.value as Map);
        if (dataMap?.containsKey('status') ?? false) {
          final status = dataMap['status'] == "true" ? true : false;
          Provider.of<LineNotifier>(context, listen: false).changeSingleActiveStatus(status, 0);
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    _fetchStatusFromFirebase();
    return Consumer<LineNotifier>(
      builder: (context, lineNotifier, _) => Scaffold(
        appBar: AppBar(
          title: Text('Firebase Realtime DB Page'),
        ),
        body: dataMap == null
            ? Center(child: CircularProgressIndicator())
            : ListView(
          children: dataMap!.entries.map((entry) {
            return ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value.toString()),
            );
          }).toList(),
        ),
      ),
    );
  }
}