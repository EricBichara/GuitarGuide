import 'package:flutter/material.dart';
import 'package:guitar_guide/core/notes_provider.dart';
import 'package:guitar_guide/core/settings_provider.dart';
import 'package:guitar_guide/core/sl_factory.dart' as di;
import 'package:guitar_guide/pages/home_page.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesProvider>(
          create: (BuildContext context) => di.sl<NotesProvider>(),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (BuildContext context) => di.sl<SettingsProvider>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Guitar Guide',
        theme: ThemeData.dark(),
        home: HomePage(),
      ),
    );
  }
}
