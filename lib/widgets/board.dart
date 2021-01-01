import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:guitar_guide/core/my_styles.dart';
import 'package:guitar_guide/core/notes.dart';
import 'package:guitar_guide/core/notes_provider.dart';
import 'package:guitar_guide/core/settings_provider.dart';
import 'package:guitar_guide/core/sl_factory.dart';
import 'package:guitar_guide/widgets/settings_dialog.dart';

class Board extends StatefulWidget {
  final String musicKey;
  final String chord;
  final String scale;
  final bool showChord;

  Board({this.musicKey, this.chord, this.scale, this.showChord});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<String> _notesOrg = ['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#'];
  List<String> _notes = [];

  List<int> highlightedFrets = [0, 3, 5, 7, 9, 12, 15, 17, 19, 21, 24];
  List<String> highlightedNotes = [];
  List<List<String>> stringsNotes = [];
  String chordFormula = "";

  Map<String, String> noteIntervalMap = Map<String, String>();

  Color darkBlue = Color.fromRGBO(0, 48, 73, 1);
  Color red = Color.fromRGBO(214, 40, 40, 1);
  Color orange = Color.fromRGBO(247, 127, 0, 1);

  Notes notes;
  NotesProvider notesProvider;

  SettingsProvider settingsProvider;

  List<String> getNotesForString(String stringKey, List<String> noteList) {
    int currentIndex = noteList.indexOf(stringKey);
    List<String> notes = [];
    for (int i = 0; i < 25; i++) {
      notes.add(noteList[currentIndex]);
      if (currentIndex == noteList.length - 1) {
        currentIndex = 0;
      } else {
        currentIndex++;
      }
    }
    return notes;
  }

  @override
  void didUpdateWidget(Board oldWidget) {
    setup();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    notesProvider = sl<NotesProvider>();
    notes = notesProvider.notes;

    settingsProvider = sl<SettingsProvider>();

    settingsProvider.addListener(() {
      setup();
      setState(() {});
    });
    setup();
    super.initState();
  }

  void setup() {
    _notes = settingsProvider.isLefty ? _notesOrg : _notesOrg.reversed.toList();
    stringsNotes.clear();
    settingsProvider.stringNotes.forEach((String note) {
      stringsNotes.add(getNotesForString(note, _notes).reversed.toList());
    });

    highlightedNotes.clear();
    List<String> notesForKey = getNotesForString(widget.musicKey, _notesOrg);

    if (widget.showChord) {
      notes.chords[widget.chord].forEach((int index) {
        highlightedNotes.add(notesForKey[index - 1]);
      });
    } else {
      notes.scales[widget.scale].forEach((int index) {
        highlightedNotes.add(notesForKey[index - 1]);
      });
    }

    chordFormula = notes.getChordFormula(widget.chord);
    createNoteIntervalMap();
  }

  void createNoteIntervalMap() {
    List<String> cf = chordFormula.split(' - ');
    for (int i = 0; i < cf.length; i++) {
      noteIntervalMap[highlightedNotes[i]] = cf[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            children: [
              Text(
                '${widget.musicKey} ${widget.chord} : $chordFormula',
                style: MyStyles.header,
              ),
              SizedBox(
                width: 30,
              ),
              FlatButton(
                color: Colors.deepPurpleAccent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.settings),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Settings')
                  ],
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      contentPadding: const EdgeInsets.all(15),
                      title: Text('Settings'),
                      elevation: 3,
                      content: SettingsDialog(),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 290,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _getColumn(index);
              },
              itemCount: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getColumn(int fret) {
    List<String> columnNotes = [];

    stringsNotes.forEach((List<String> string) {
      columnNotes.add(string[fret]);
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ...columnNotes.map((String note) => _getNoteSquare(note, noteIntervalMap[note], fret)).toList(),
        _getFretSquare((settingsProvider.isLefty ? (24 - fret) : fret)),
      ],
    );
  }

  Widget _getNoteSquare(String note, String interval, int fret) {
    bool highlight = highlightedNotes.indexOf(note) != -1;

    Border cellBorder;

    if (settingsProvider.isLefty && fret == 24) {
      cellBorder = Border(
          top: BorderSide(color: Colors.black, width: 1),
          right: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 1),
          left: BorderSide(color: Colors.black, width: 3));
    } else if (!settingsProvider.isLefty && fret == 0) {
      cellBorder = Border(
          top: BorderSide(color: Colors.black, width: 1),
          right: BorderSide(color: Colors.black, width: 2),
          bottom: BorderSide(color: Colors.black, width: 1),
          left: BorderSide(color: Colors.black, width: 1));
    } else {
      cellBorder = Border.all(color: Colors.black, width: 1);
    }

    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: highlight
            ? note == widget.musicKey
                ? red
                : orange
            : Colors.grey.shade600,
        border: cellBorder,
      ),
      child: Text(
        settingsProvider.showInterval && highlight ? interval : note,
        style: TextStyle(color: highlight ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _getFretSquare(int fret) {
    bool highlight = highlightedFrets.indexOf(fret) != -1;

    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: highlight ? darkBlue : Colors.blue,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Text(
        fret.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
