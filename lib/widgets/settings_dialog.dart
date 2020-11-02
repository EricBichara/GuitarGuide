import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:guitar_guide/core/settings_provider.dart';
import 'package:guitar_guide/core/sl_factory.dart';

class SettingsDialog extends StatefulWidget {
  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool isLefty = false;
  bool showInterval = false;
  List<String> stringNotes;
  List<DropdownMenuItem> keyOptions = [];
  List<String> _notesOrg = ['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#'];

  SettingsProvider settingsProvider;

  @override
  void initState() {
    settingsProvider = sl<SettingsProvider>();

    isLefty = settingsProvider.isLefty;
    showInterval = settingsProvider.showInterval;
    stringNotes = settingsProvider.stringNotes;

    createKeyOptions();
    super.initState();
  }

  void createKeyOptions() {
    keyOptions = ['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#']
        .map((String key) => DropdownMenuItem(
              child: Text(key),
              value: key,
            ))
        .toList();
  }

  Widget createDropdownButton(int index) {
    return DropdownButton(
      items: keyOptions,
      onChanged: (dynamic value) {
        setState(() {
          stringNotes[index] = value;
        });
      },
      value: stringNotes[index],
    );
  }

  void saveSettings() {
    settingsProvider.saveSetting(isLefty, showInterval, stringNotes);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Righty'),
              PlatformSwitch(
                  value: isLefty,
                  onChanged: (bool value) {
                    setState(() {
                      isLefty = value;
                    });
                  }),
              Text('Lefty')
            ],
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 20,
          ),
          Row(
            children: [
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
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 20,
          ),
          Text(
            'Tuning',
            textAlign: TextAlign.start,
          ),
          Wrap(
            children: [
              createDropdownButton(5),
              SizedBox(width: 3),
              createDropdownButton(4),
              SizedBox(width: 3),
              createDropdownButton(3),
              SizedBox(width: 3),
              createDropdownButton(2),
              SizedBox(width: 3),
              createDropdownButton(1),
              SizedBox(width: 3),
              createDropdownButton(0),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                color: Colors.red,
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 5,
              ),
              FlatButton(
                color: Colors.deepPurpleAccent,
                onPressed: () {
                  saveSettings();
                },
                child: Text('Save'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
