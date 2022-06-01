import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();
  final _keyUserToken = "userToken";
  final _keyPermalink = "permalink";
  final _keyDeviceId = "deviceId";
  final _persona = "persona";
  final _username = "username";
  final _userImgUrl = "userImgUrl";
  final _companyPermalink = "companyPermalink";
  final _keyRadius = "radius";
  final _keyNotifications = "notifications";

  saveUserToken(String value) async {
    await _storage.write(key: _keyUserToken, value: value);
  }

  Future<String> getUserToken() async {
    return await _storage.read(key: _keyUserToken);
  }

  deleteUserToken() async {
    await _storage.delete(key: _keyUserToken);
  }

  savePermalink(String value) async {
    await _storage.write(key: _keyPermalink, value: value);
  }

  Future<String> getPermalink() async {
    return await _storage.read(key: _keyPermalink);
  }

  deletePermalink() async {
    await _storage.delete(key: _keyPermalink);
  }

  saveDeviceId(String value) async {
    await _storage.write(key: _keyDeviceId, value: value);
  }

  Future<String> getDeviceId() async {
    return await _storage.read(key: _keyDeviceId);
  }

  deleteDeviceId() async {
    await _storage.delete(key: _keyDeviceId);
  }

  savePersona(String value) async {
    await _storage.write(key: _persona, value: value);
  }

  Future<String> getPersona() async {
    return await _storage.read(key: _persona);
  }

  deletePersona() async {
    await _storage.delete(key: _persona);
  }

  saveUsername(String value) async {
    await _storage.write(key: _username, value: value);
  }

  Future<String> getUsername() async {
    return await _storage.read(key: _username);
  }

  deleteUsername() async {
    await _storage.delete(key: _username);
  }

  saveUserImgUrl(String value) async {
    await _storage.write(key: _userImgUrl, value: value);
  }

  Future<String> getUserImgUrl() async {
    return await _storage.read(key: _userImgUrl);
  }

  deleteUserImgUrl() async {
    await _storage.delete(key: _userImgUrl);
  }

  saveCompanyPermalink(String value) async {
    await _storage.write(key: _companyPermalink, value: value);
  }

  Future<String> getCompanyPermalink() async {
    return await _storage.read(key: _companyPermalink);
  }

  deleteCompanyPermalink() async {
    await _storage.delete(key: _companyPermalink);
  }

  saveRadius(String value) async {
    await _storage.write(key: _keyRadius, value: value);
  }

  Future<String> getRadius() async {
    return await _storage.read(key: _keyRadius);
  }

  deleteRadius() async {
    await _storage.delete(key: _keyRadius);
  }

  saveNotifications(String value) async {
    await _storage.write(key: _keyNotifications, value: value);
  }

  Future<String> getNotifications() async {
    return await _storage.read(key: _keyNotifications);
  }

  deleteNotifications() async {
    await _storage.delete(key: _keyNotifications);
  }

  deleteUserData() async {
    await _storage.delete(key: _keyUserToken);
    await _storage.delete(key: _keyPermalink);
    await _storage.delete(key: _keyDeviceId);
    await _storage.delete(key: _username);
    await _storage.delete(key: _userImgUrl);
    await _storage.delete(key: _companyPermalink);
    await _storage.delete(key: _keyRadius);
    await _storage.delete(key: _keyNotifications);
  }

  clearAll() async {
    await _storage.deleteAll();
  }
}
