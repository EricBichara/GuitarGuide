import 'package:flutter/material.dart';
import 'package:guitar_guide/core/my_styles.dart';
import 'package:guitar_guide/core/notes.dart';
import 'package:guitar_guide/core/notes_provider.dart';
import 'package:guitar_guide/core/sl_factory.dart';

class ChordProgression extends StatefulWidget {
  final String scaleKey;
  final MapEntry<String, List<int>> selectedScale;
  final Function selectChordCallback;

  ChordProgression({required this.scaleKey, required this.selectedScale, required this.selectChordCallback});

  @override
  _ChordProgressionState createState() => _ChordProgressionState();
}

class _ChordProgressionState extends State<ChordProgression> {
  late Notes notes;
  late NotesProvider notesProvider;
  List<List<Map<String, List<int>>>> chords = [];
  List<String> keysForScale = [];
  List<String> scaleTone = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII'];
  String? selectedChord;
  String? selectedChordKey;

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
            height: 400,
            width: double.infinity,
            alignment: Alignment.center,
            child: ListView.builder(
              itemCount: chords.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                String name = '';
                switch (chords[index][0].keys.first) {
                  case 'maj':
                    name = scaleTone[index].toUpperCase();
                    break;
                  case 'min':
                    name = scaleTone[index].toLowerCase();
                    break;
                  case 'dim':
                    name = scaleTone[index].toLowerCase() + '\u1d52';
                    break;
                  case 'aug':
                    name = scaleTone[index].toLowerCase() + '\u207A';
                    break;
                  default:
                    name = scaleTone[index];
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          name,
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
                            padding: const EdgeInsets.only(left: 10),
                            child: ListView.builder(
                              itemCount: chords[index].length,
                              itemBuilder: (context, innerIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    selectChord(chords[index][innerIndex].keys.first, keysForScale[index]);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Text(
                                      chords[index][innerIndex].keys.first,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: chords[index][innerIndex].keys.first == selectedChord &&
                                                keysForScale[index] == selectedChordKey
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: chords[index][innerIndex].keys.first == selectedChord &&
                                                keysForScale[index] == selectedChordKey
                                            ? Colors.blue.shade300
                                            : Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            width: 130,
                            height: 250,
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
