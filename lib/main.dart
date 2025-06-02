import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recruitment_agents/firebase_options.dart';
import 'package:recruitment_agents/screens/home_screen.dart';
import 'package:recruitment_agents/utils/logger.dart';

void main() async {
  await initApp();
  runApp(const MyApp());
}

initApp() async {
  AppLogger.init();
  AppLogger.i('\n\n---> START NEW SESSION <---');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}
