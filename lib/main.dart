import 'package:citations/pages/home_page.dart';
import 'package:citations/repository/saved_quotes_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedQuoteRepository = SavedQuoteRepository();
  await savedQuoteRepository.initalize();
  //GET-IT REGISTRO IL SINGLETON A LIVELLO GLOBALE
  GetIt.I.registerSingleton(savedQuoteRepository);
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      home: const HomePage(),
    );
  }
}
