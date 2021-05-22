import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_vaccine_slot/Welcome/Screens/pincode.dart';
import 'package:track_vaccine_slot/Welcome/welcome.dart';

// importing file ;
import 'Provider/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        initialRoute: "/",
        routes: {
          '/': (context) => Welcome(),
          '/pincode': (context) => Pincode(),
        },
      ),
    );
  }
}
