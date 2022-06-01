class Amenity {
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

  Amenity(this._name, this._imagePath, this._included);
}
