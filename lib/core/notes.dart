import 'dart:html';

enum Note { root, b2, M2, b3, M3, p4, b5, p5, b6, M6, b7, M7 }

class Notes {
  Map<String, List<int>> scales;
  Map<String, List<int>> chords;

  List<String> keys = ['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#'];

  Notes() {
    scales = {
      //Church Modes W-W-H-W-W-W-H
      'Ionian (Major)': convertScale([Note.root, Note.M2, Note.M3, Note.p4, Note.p5, Note.M6, Note.M7]),
      'Dorian': convertScale([Note.root, Note.M2, Note.b3, Note.p4, Note.p5, Note.M6, Note.b7]),
      'Phrygian': convertScale([Note.root, Note.b2, Note.b3, Note.p4, Note.p5, Note.b6, Note.b7]),
      'Lydian': convertScale([Note.root, Note.M2, Note.M3, Note.b5, Note.p5, Note.M6, Note.M7]),
      'Mixolydian': convertScale([Note.root, Note.M2, Note.M3, Note.p4, Note.p5, Note.M6, Note.b7]),
      'Aeolian (Minor)': convertScale([Note.root, Note.M2, Note.b3, Note.p4, Note.p5, Note.b6, Note.b7]),
      'Locrian': convertScale([Note.root, Note.b2, Note.b3, Note.p4, Note.b5, Note.b6, Note.b7]),
      //Melodic Minor Modes W-H-W-W-W-W-H
      'Melodic Minor': convertScale([Note.root, Note.M2, Note.b3, Note.p4, Note.p5, Note.M6, Note.M7]),
      'Dorian b2': convertScale([Note.root, Note.b2, Note.b3, Note.p4, Note.p5, Note.M6, Note.b7]),
      'Lydian Augmented': convertScale([Note.root, Note.M2, Note.M3, Note.b5, Note.b6, Note.M6, Note.M7]),
      'Lydian Dominant': convertScale([Note.root, Note.M2, Note.M3, Note.b5, Note.p5, Note.M6, Note.b7]),
      'Mixolydian b6': convertScale([Note.root, Note.M2, Note.M3, Note.p4, Note.p5, Note.b6, Note.b7]),
      'Aeolian b5': convertScale([Note.root, Note.M2, Note.b3, Note.p4, Note.b5, Note.b6, Note.b7]),
      'Altered': convertScale([Note.root, Note.b2, Note.b3, Note.M3, Note.b5, Note.b6, Note.b7]),
      //Harmonic Minor Modes W-H-W-W-H-WH-H
      'Harmonic Minor': convertScale([Note.root, Note.M2, Note.b3, Note.p4, Note.p5, Note.b6, Note.M7]),
      'Locrian #6': convertScale([Note.root, Note.b2, Note.b3, Note.p4, Note.b5, Note.M6, Note.b7]),
      'Ionian #5': convertScale([Note.root, Note.M2, Note.M3, Note.p4, Note.b6, Note.M6, Note.M7]),
      'Dorian #4': convertScale([Note.root, Note.M2, Note.b3, Note.b5, Note.p5, Note.M6, Note.b7]),
      'Phrygian Dominant': convertScale([Note.root, Note.b2, Note.M3, Note.p4, Note.p5, Note.b6, Note.b7]),
      'Lydian #2': convertScale([Note.root, Note.b3, Note.M3, Note.b5, Note.p5, Note.M6, Note.M7]),
      'Super Locrian': convertScale([Note.root, Note.b2, Note.b3, Note.M3, Note.b5, Note.b6, Note.M6]),
    };

    chords = {

      //Triads
      'Diminished': convertScale([Note.root, Note.b3, Note.b5]),
      'Major': convertScale([Note.root, Note.M3, Note.p5]),
      'Minor': convertScale([Note.root, Note.b3, Note.p5]),
      'Augmented': convertScale([Note.root, Note.M3, Note.b6]),

      //Major
      'Major b5': convertScale([Note.root, Note.M3, Note.b5]),
      'Major 6': convertScale([Note.root, Note.M3, Note.p5, Note.M6]),
      'Major 6add9': convertScale([Note.root, Note.M3, Note.p5, Note.M6, Note.M2]),
      'Major 7': convertScale([Note.root, Note.M3, Note.p5, Note.M7]),
      'Major 7b5': convertScale([Note.root, Note.M3, Note.b5, Note.M7]),
      'Major 7#5': convertScale([Note.root, Note.M3, Note.b6, Note.M7]),
      'Major 9': convertScale([Note.root, Note.M3, Note.p5, Note.M7, Note.M2]),
      'Major add9': convertScale([Note.root, Note.M3, Note.p5, Note.M2]),
      'Major 11': convertScale([Note.root, Note.M3, Note.p5, Note.M7, Note.p4]),
      'Major 13': convertScale([Note.root, Note.M3, Note.p5, Note.M7, Note.M2, Note.p4, Note.M6]),

      //Minor

      'Minor 6': convertScale([Note.root, Note.b3, Note.p5, Note.M6]),
      'Minor 6add9': convertScale([Note.root, Note.b3, Note.p5, Note.M6, Note.M2]),
      'Minor 7': convertScale([Note.root, Note.b3, Note.p5, Note.b7]),
      'Minor 7b5': convertScale([Note.root, Note.b3, Note.b5, Note.b7]),
      'Minor 9': convertScale([Note.root, Note.b3, Note.p5, Note.b7, Note.M2]),
      'Minor add9': convertScale([Note.root, Note.b3, Note.p5, Note.M2]),
      'Minor 11': convertScale([Note.root, Note.b3, Note.p5, Note.p4]),
      'Minor 13': convertScale([Note.root, Note.b3, Note.p5, Note.b7, Note.M2, Note.p4, Note.M6]),

      //Minor Major
      'Min/Maj 7': convertScale([Note.root, Note.b3, Note.p5, Note.M7]),
      'Min/Maj 9': convertScale([Note.root, Note.b3, Note.p5, Note.M7, Note.M2]),
      'Min/Maj 11': convertScale([Note.root, Note.b3, Note.p5, Note.M7, Note.M2, Note.p4]),
      'Min/Maj 13': convertScale([Note.root, Note.b3, Note.p5, Note.M7, Note.M2, Note.p4, Note.M6]),

      //Dominant
      'Dominant': convertScale([Note.root, Note.M3, Note.p5, Note.b7]),
      'Dom 7#5': convertScale([Note.root, Note.M3, Note.b6, Note.b7]),
      'Dom 7b5': convertScale([Note.root, Note.M3, Note.b5, Note.b7]),
      'Dom 9': convertScale([Note.root, Note.M3, Note.p5, Note.b7, Note.M2]),
      'Dom 11': convertScale([Note.root, Note.M3, Note.p5, Note.b7, Note.p4]),

      //Diminished

      'Diminished 7th': convertScale([Note.root, Note.b3, Note.b5, Note.M6]),

      //Other

      'Sus2': convertScale([Note.root, Note.M2, Note.p5]),
      'Sus4': convertScale([Note.root, Note.p4, Note.p5]),



    };
  }

  List<int> convertScale(List<Note> notes) {
    List<int> convertedNotes = [];
    notes.forEach((Note element) {
      switch (element) {
        case Note.root:
          convertedNotes.add(1);
          break;
        case Note.b2:
          convertedNotes.add(2);
          break;
        case Note.M2:
          convertedNotes.add(3);
          break;
        case Note.b3:
          convertedNotes.add(4);
          break;
        case Note.M3:
          convertedNotes.add(5);
          break;
        case Note.p4:
          convertedNotes.add(6);
          break;
        case Note.b5:
          convertedNotes.add(7);
          break;
        case Note.p5:
          convertedNotes.add(8);
          break;
        case Note.b6:
          convertedNotes.add(9);
          break;
        case Note.M6:
          convertedNotes.add(10);
          break;
        case Note.b7:
          convertedNotes.add(11);
          break;
        case Note.M7:
          convertedNotes.add(12);
          break;
      }
    });
    return convertedNotes;
  }

  String getChordFormula(String chord) {
    List<int> notes = chords.entries.firstWhere((MapEntry<String, List<int>> element) => element.key == chord).value;
    List<String> formula = [];

    for (int i = 0; i < notes.length; i++) {
      int note = notes[i];
      switch (note) {
        case 1:
          formula.add("R");
          break;
        case 2:
          formula.add("b2");
          break;
        case 3:
          if (notes[i - 1] < note) {
            formula.add("2");
          } else {
            formula.add("9");
          }
          break;
        case 4:
          formula.add("b3");
          break;
        case 5:
          formula.add("3");
          break;
        case 6:
          if (notes[i - 1] < note && formula.length < 3) {
            formula.add("4");
          } else {
            formula.add("11");
          }
          break;
        case 7:
          formula.add("b5");
          break;
        case 8:
          formula.add("5");
          break;
        case 9:
          if(formula.last != '5' && formula.last != 'b5'){
           formula.add('#5');
          }else{
            formula.add("b6");
          }
          break;
        case 10:
          if (notes[i - 1] < note && formula.length < 4) {
            formula.add("6");
          } else {
            formula.add("13");
          }
          break;
        case 11:
          formula.add("b7");
          break;
        case 12:
          formula.add("7");
          break;
      }
    }
    return formula.join(' - ');
  }

  String getScaleFormula(List<int> notes) {
    List<String> formula = [];

    for (int i = 0; i < notes.length; i++) {
      int note = notes[i];
      switch (note) {
        case 1:
          formula.add("R");
          break;
        case 2:
          formula.add("b2");
          break;
        case 3:
          formula.add("2");
          break;
        case 4:
          if (formula.last == 'R') {
            formula.add('#2');
          } else {
            formula.add("b3");
          }
          break;
        case 5:
          if (formula.last == '#2') {
            formula.add('3');
          } else if (notes[i - 1] == 4) {
            formula.add("b4");
          } else {
            formula.add("3");
          }
          break;
        case 6:
          if (notes[i - 1] < note) {
            formula.add("4");
          } else {
            formula.add("11");
          }
          break;
        case 7:
          if (notes[i - 1] != 6 && formula.last != 'b4') {
            formula.add("#4");
          } else {
            formula.add("b5");
          }
          break;
        case 8:
          formula.add("5");
          break;
        case 9:
          if (formula.last == '4' || formula.last == '#4') {
            formula.add("#5");
          } else {
            formula.add("b6");
          }
          break;
        case 10:
          if (formula.last == '6' || formula.last == 'b6') {
            formula.add("bb7");
          } else {
            formula.add('6');
          }
          break;
        case 11:
          formula.add("b7");
          break;
        case 12:
          formula.add("7");
          break;
      }
    }
    return formula.join(' - ');
  }

  List<int> getChordIntervals(List<int> chordNotes) {
    List<int> intervals = [];
    intervals.add(1);
    for (int i = 0; i < chordNotes.length - 1; i++) {
      intervals.add(chordNotes[i + 1] - chordNotes[0] + 1);
    }

    return intervals;
  }

  List<Map<String, List<int>>> findChords(List<int> scaleNotes) {
    List<Map<String, List<int>>> validChords = [];

    chords.forEach((String key, List<int> value) {
      if (scaleNotes.toSet().containsAll(value)) {
        validChords.add({key: value.toList()});
      }
    });

    return validChords;
  }

  List<List<Map<String, List<int>>>> getChordsForScale(String scaleKey, List<int> scaleNotes) {
    List<List<Map<String, List<int>>>> chordsForScale = [];
    List<int> extendedScaleNotes = List.from(scaleNotes);

    //create extended List
    scaleNotes.forEach((int note) {
      extendedScaleNotes.add(note + 12);
    });

    for (int i = 0; i < 7; i++) {
      List<int> chordNotes = getChordIntervals(extendedScaleNotes.sublist(0, 7));
      List<Map<String, List<int>>> validChords = findChords(chordNotes);
      chordsForScale.add(validChords);
      extendedScaleNotes.removeAt(0);
    }

    return chordsForScale;
  }

  List<String> getScaleKeys(String key, List<int> scaleNotes) {
    List<String> extendedKeys = List.from(keys);
    extendedKeys.addAll(keys);

    int firstIndex = extendedKeys.indexOf(key);
    List<String> keysForScale = [];

    scaleNotes.forEach((int note) {
      if (keysForScale.isEmpty) {
        keysForScale.add(extendedKeys[firstIndex + (note - 1)]);
      } else {
        String eh = getKeyEnharmonic(keysForScale.last, extendedKeys[firstIndex + (note - 1)]);
        keysForScale.add(eh);
      }
    });

    return keysForScale;
  }

  String getKeyEnharmonic(String prev, String current) {
    switch (current) {
      case 'A':
        if (prev == 'F##') {
          return 'G##';
        }
        break;
      case 'A#':
        if (prev == 'A' || prev == 'Ab') {
          return 'Bb';
        }
        break;
      case 'C':
        if (prev == 'A#') {
          return 'B#';
        }
        break;
      case 'C#':
        if (prev == 'C' || prev == 'Cb') {
          return 'Db';
        }
        break;
      case 'D':
        if (prev == 'B#') {
          return 'C##';
        }
        break;
      case 'D#':
        if (prev == 'D' || prev == 'Db') {
          return 'Eb';
        }
        break;
      case 'E':
        if (prev == 'Eb') {
          return 'Fb';
        }
        break;
      case 'F':
        if (prev == 'D#') {
          return 'E#';
        }
        break;
      case 'F#':
        if (prev == 'F' || prev == 'Fb') {
          return 'Gb';
        }
        break;
      case 'G':
        if (prev == 'E#') {
          return 'F##';
        }
        break;
      case 'G#':
        if (prev == 'G' || prev == 'Gb') {
          return 'Ab';
        }
        break;
    }

    return current;
  }

  String convertBackEnharmonic(String key) {
    if (key == 'G##') {
      return 'A';
    } else if (key == 'Bb') {
      return 'A#';
    } else if (key == 'A##' || key == 'Cb') {
      return 'B';
    } else if (key == 'B#') {
      return 'C';
    } else if (key == 'Db') {
      return 'C#';
    } else if (key == 'C##') {
      return 'D';
    } else if (key == 'Eb') {
      return 'D#';
    } else if (key == 'D##' || key == 'Fb') {
      return 'E';
    } else if (key == 'E#') {
      return 'F';
    } else if (key == 'E##' || key == 'Gb') {
      return 'F#';
    } else if (key == 'F##') {
      return 'G';
    } else if (key == 'Ab') {
      return 'G#';
    } else {
      return key;
    }
  }
}
