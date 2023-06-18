import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:provider/provider.dart';
import 'package:qlink/widgets/notifiers.dart';
import 'FirebasedataPage.dart';
import 'Home.dart';
import 'dashboard.dart';
import 'package:firebase_database/firebase_database.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final databaseRef = FirebaseDatabase(databaseURL: 'https://qlink-c75ee-default-rtdb.europe-west1.firebasedatabase.app').reference();
   MyApp({key});

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = databaseRef.child('qlink');
    ref.get().then((DataSnapshot snapshot) {
      if (snapshot.value is Map<dynamic, dynamic>) {
        final dataMap = Map<String, dynamic>.from(snapshot.value as Map);
        if (dataMap?.containsKey('status') ?? false) {
          final status = dataMap['status'] == "true" ? true : false;
          Provider.of<LineNotifier>(context, listen: false).changeSingleActiveStatus(status, 0);
          print("statu değeri: $status");
        }
      }
    });

    // Firebase Realtime Database referansını alın

    return MultiProvider(

      providers: [
        ChangeNotifierProvider<LineNotifier>  (create: (_) => LineNotifier()),
    ],
    child: MaterialApp(


      debugShowCheckedModeBanner: false,
      navigatorKey: Grock.navigationKey,
      scaffoldMessengerKey: Grock.scaffoldMessengerKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Dashport(),
    ),
    );
  }
}