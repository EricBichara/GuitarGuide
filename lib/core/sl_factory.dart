import 'package:get_it/get_it.dart';
import 'package:guitar_guide/core/notes_provider.dart';
import 'package:guitar_guide/core/settings_provider.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerSingleton<NotesProvider>(NotesProvider());
  sl.registerSingleton<SettingsProvider>(SettingsProvider());
}