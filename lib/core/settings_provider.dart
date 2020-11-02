import 'package:flutter/cupertino.dart';

class SettingsProvider with ChangeNotifier {
  List<String> _stringNotesSetting = ['E', 'B', 'G', 'D', 'A', 'E'];
  bool _isLeftySetting = false;
  bool _showIntervalSetting = false;

  bool get isLefty {
    return _isLeftySetting;
  }

  bool get showInterval {
    return _showIntervalSetting;
  }

  List<String> get stringNotes {
    return _stringNotesSetting;
  }

  void saveSetting(bool isLefty, bool showInterval, List<String> stringNotes){
    this._stringNotesSetting = stringNotes;
    this._isLeftySetting = isLefty;
    this._showIntervalSetting = showInterval;
    notifyListeners();
  }
}
