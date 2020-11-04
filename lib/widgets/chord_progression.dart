import 'package:flutter/material.dart';
import 'package:guitar_guide/core/my_styles.dart';
import 'package:guitar_guide/core/notes.dart';
import 'package:guitar_guide/core/notes_provider.dart';
import 'package:guitar_guide/core/sl_factory.dart';

class ChordProgression extends StatefulWidget {
  final String scaleKey;
  final MapEntry<String, List<int>> selectedScale;
  final Function selectChordCallback;

  ChordProgression({this.scaleKey, this.selectedScale, this.selectChordCallback});

  @override
  _ChordProgressionState createState() => _ChordProgressionState();
}

class _ChordProgressionState extends State<ChordProgression> {
  Notes notes;
  NotesProvider notesProvider;
  List<List<Map<String, List<int>>>> chords = [];
  List<String> keysForScale = [];
  List<String> scaleTone = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII'];
  String selectedChord;
  String selectedChordKey;

  @override
  void didUpdateWidget(covariant ChordProgression oldWidget) {
    setState(() {
      keysForScale = notes.getScaleKeys(widget.scaleKey, widget.selectedScale.value);
      chords = notes.getChordsForScale(widget.scaleKey, widget.selectedScale.value);
    });
    super.didUpdateWidget(oldWidget);
  }

  void selectChord(String chord, String key) {
    selectedChord = chord;
    selectedChordKey = notes.convertBackEnharmonic(key);
    widget.selectChordCallback(selectedChord, selectedChordKey);
  }

  @override
  void initState() {
    notesProvider = sl<NotesProvider>();
    notes = notesProvider.notes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.scaleKey} ${widget.selectedScale.key}: ${notes.getScaleFormula(widget.selectedScale.value)}',
            style: MyStyles.header,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 300,
            width: double.infinity,
            alignment: Alignment.center,
            child: ListView.builder(
              itemCount: chords.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          scaleTone[index],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          keysForScale[index],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                            child: ListView.builder(
                              itemCount: chords[index].length,
                              itemBuilder: (context, innerIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    selectChord(chords[index][innerIndex].keys.first, keysForScale[index]);
                                  },
                                  child: Text(
                                    chords[index][innerIndex].keys.first,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: chords[index][innerIndex].keys.first == selectedChord && keysForScale[index] == selectedChordKey
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: chords[index][innerIndex].keys.first == selectedChord && keysForScale[index] == selectedChordKey
                                          ? Colors.blue.shade300
                                          : Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            width: 100,
                            height: 200,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
