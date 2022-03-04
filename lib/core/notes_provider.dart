import 'package:flutter/cupertino.dart';
import 'package:guitar_guide/core/notes.dart';

class NotesProvider with ChangeNotifier{

  NotesProvider(){
    notes = Notes();
  }
  late Notes notes;

  MapEntry<String, List<int>>? selectedScale;
  String? selectedKey;

  String? selectedChordKey;
  String? selectedChord;
}