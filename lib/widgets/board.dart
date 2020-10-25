import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:guitar_tutor_win/core/notes.dart';

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
  List<String> _stringNotes = ['E', 'B', 'G', 'D', 'A', 'E'];

  List<int> highlightedFrets = [0, 3, 5, 7, 9, 12, 15, 17, 19, 21, 24];
  List<String> highlightedNotes = [];
  List<List<String>> stringsNotes = [];
  String chordFormula = "";

  Map<String, String> noteIntervalMap = Map<String, String>();

  bool isLefty = true;
  bool showInterval = false;

  Color darkBlue = Color.fromRGBO(0, 48, 73, 1);
  Color red = Color.fromRGBO(214, 40, 40, 1);
  Color orange = Color.fromRGBO(247, 127, 0, 1);

  Notes notes = Notes();

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
    setup();
    super.initState();
  }

  void setup() {
    _notes = isLefty ? _notesOrg : _notesOrg.reversed.toList();
    stringsNotes.clear();
    _stringNotes.forEach((String note) {
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

  void createNoteIntervalMap(){
    List<String> cf = chordFormula.split(' - ');
    for(int i = 0; i<cf.length; i++){
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
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 500,
                child: Text(
                  '${widget.musicKey} ${widget.chord} : $chordFormula',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Text('Right-handed'),
              PlatformSwitch(
                  value: isLefty,
                  onChanged: (bool value) {
                    setState(() {
                      isLefty = value;
                      setup();
                    });
                  }),
              Text('Left-handed'),
              SizedBox(
                width: 90,
              ),
              Text('Note'),
              PlatformSwitch(
                  value: showInterval,
                  onChanged: (bool value) {
                    setState(() {
                      showInterval = value;
                    });
                  }),
              Text('Interval'),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 320,
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
        //_getFretSquare((widget.isLefty ? (24 - fret) : fret)),
        ...columnNotes.map((String note) => _getNoteSquare(note, noteIntervalMap[note])).toList(),
        _getFretSquare((isLefty ? (24 - fret) : fret)),
      ],
    );
  }

  Widget _getNoteSquare(String note, String interval) {
    bool highlight = highlightedNotes.indexOf(note) != -1;

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
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Text(
        showInterval && highlight ? interval : note,
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
