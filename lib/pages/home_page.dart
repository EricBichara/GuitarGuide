import 'package:flutter/material.dart';
import 'package:guitar_tutor_win/core/notes.dart';
import 'package:guitar_tutor_win/widgets/board.dart';
import 'package:guitar_tutor_win/widgets/chord_progression.dart';

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

  Notes notes = Notes();

  @override
  void initState() {
    createScaleOptions();
    createKeyOptions();
    //createChordOptions();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {});
    });
    super.initState();
  }

  void createScaleOptions() {
    scaleOptions = notes.scales.keys
        .map((String scale) => DropdownMenuItem(
              child: Text(scale),
              value: scale,
            ))
        .toList();
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
        title: Text('Board'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
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
                      setState(() {
                        selectedScale = notes.scales.entries.firstWhere((MapEntry<String, List<int>> element) => element.key == value);
                      });
                    },
                    value: selectedScale.key,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ChordProgression(
                scaleKey: selectedKey,
                selectedScale: selectedScale,
                selectChordCallback: selectChord,
              ),
              Divider(),
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
