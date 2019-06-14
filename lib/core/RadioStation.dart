// foundations
import 'dart:convert';

// 3rd party

// mine

///
class RadioStation {
  String _label;
  String _url;
  String _backgroundPath;

  get label => _label;
  get url => _url;
  get backgroundPath => _backgroundPath;

  RadioStation.fromObject(Map<String, dynamic> jData ){
    _label = jData['label'];
    _url = jData['url'];
    _backgroundPath = jData['backgroundPath'];
    print(toString());
  }

  @override
  String toString() {
    return 'RadioStation{_label: $_label, _url: $_url}';
  }
}