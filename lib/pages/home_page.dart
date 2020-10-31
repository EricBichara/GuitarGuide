import 'package:flutter/material.dart';
import 'package:guitar_guide/core/notes.dart';
import 'package:guitar_guide/core/notes_provider.dart';
import 'package:guitar_guide/core/sl_factory.dart';
import 'package:provider/provider.dart';
import 'package:guitar_guide/widgets/board.dart';
import 'package:guitar_guide/widgets/chord_progression.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DropdownMenuItem> scaleOptions = [];
  List<DropdownMenuItem> keyOptions = [];
  List<DropdownMenuItem> chordOptions = [];
  MapEntry<String, List<int>> selectedScale;
  String selectedKey;
  String chordKey;
  String selectedChord;

  NotesProvider notesProvider;
  Notes notes;

  @override
  void initState() {
    //createChordOptions();

    notesProvider = sl<NotesProvider>();
    notes = notesProvider.notes;

    createScaleOptions();
    createKeyOptions();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {});
    });
    super.initState();
  }

  void createScaleOptions() {
    scaleOptions.clear();
    for (int i = 0; i < notes.scales.keys.length; i++) {
      if (i > 0 && i % 7 == 0) {
        scaleOptions.add(
          DropdownMenuItem(
            child: Container(
                height: 5,
                child: Divider(
                  height: 1,
                  thickness: 1,
                )),
            value: null,
          ),
        );
      }

      scaleOptions.add(
        DropdownMenuItem(
          child: Text(notes.scales.keys.elementAt(i)),
          value: notes.scales.keys.elementAt(i),
        ),
      );
    }

    /*scaleOptions = notes.scales.keys
        .map((String scale) => DropdownMenuItem(
              child: Text(scale),
              value: scale,
            ))
        .toList();*/
    selectedScale = notes.scales.entries.first;
  }

  void createKeyOptions() {
    keyOptions = ['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#']
        .map((String key) => DropdownMenuItem(
              child: Text(key),
              value: key,
            ))
        .toList();
    selectedKey = 'E';
  }

  void createChordOptions() {
    chordOptions = notes.chords.keys
        .map((String chord) => DropdownMenuItem(
              child: Text(chord),
              value: chord,
            ))
        .toList();
    selectedChord = 'Minor';
  }

  void selectChord(String chord, String key) {
    setState(() {
      selectedChord = chord;
      chordKey = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GG'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                DropdownButton(
                  items: keyOptions,
                  onChanged: (dynamic value) {
                    setState(() {
                      selectedKey = value;
                    });
                  },
                  value: selectedKey,
                ),
                SizedBox(
                  width: 20,
                ),
                DropdownButton(
                  items: scaleOptions,
                  onChanged: (dynamic value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      selectedScale = notes.scales.entries.firstWhere((MapEntry<String, List<int>> element) => element.key == value);
                    });
                  },
                  value: selectedScale.key,
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ChordProgression(
                scaleKey: selectedKey,
                selectedScale: selectedScale,
                selectChordCallback: selectChord,
              ),
              Divider(
                color: Colors.grey.shade800,
                thickness: 1,
              ),
              if (selectedChord != null)
                Board(
                  chord: selectedChord,
                  musicKey: chordKey,
                  showChord: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
