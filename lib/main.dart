import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:world_hurdle_puzzle/providers/hurdle_provider.dart';
import 'package:world_hurdle_puzzle/word_hurdle_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => HurdleProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      home: const WordHurdlePage(),
    );
  }
}
