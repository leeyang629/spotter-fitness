import 'package:spotter/archives/models/AssetObject.dart';

class Equipment {
  // ignore: non_constant_identifier_names
  final AssetObject TOWELS =
      AssetObject("Towel", "assets/images/spotter_logo_circular.png");
  // ignore: non_constant_identifier_names
  final AssetObject CARDIO =
      AssetObject("Cardio Machines", "assets/images/spotter_logo_circular.png");
  // ignore: non_constant_identifier_names
  final AssetObject SAUNA =
      AssetObject("Sauna", "assets/images/spotter_logo_circular.png");
  // ignore: non_constant_identifier_names
  final AssetObject RESISTANCE = AssetObject(
      "Resistance Machine", "assets/images/spotter_logo_circular.png");
  // ignore: non_constant_identifier_names
  final AssetObject GROUP =
      AssetObject("Group Exercise", "assets/images/spotter_logo_circular.png");
  String _name;

  // ignore: unnecessary_getters_setters
  String get name => _name;

  // ignore: unnecessary_getters_setters
  set name(String value) {
    _name = value;
  }

  String _imagePath;
  bool _included;

  // ignore: unnecessary_getters_setters
  String get imagePath => _imagePath;

  // ignore: unnecessary_getters_setters
  set imagePath(String value) {
    _imagePath = value;
  }

  // ignore: unnecessary_getters_setters
  bool get included => _included;

  // ignore: unnecessary_getters_setters
  set included(bool value) {
    _included = value;
  }

  Equipment(this._name, this._imagePath, this._included);

  List<Equipment> getEquipmentsFromStrings(List<String> data) {
    List<Equipment> equipments;
    return equipments;
  }

  // ignore: unused_element
  String _getImgPathFromString(String value) {
    return value;
  }
}
