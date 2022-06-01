import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/storage.dart';
import 'package:spotter/providers/app_state.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

uploadImage(BuildContext context, File _image) async {
  try {
    final SecureStorage storage = SecureStorage();
    Provider.of<AppState>(context, listen: false).enableSpinner();
    var request = http.MultipartRequest('POST',
        Uri.parse('${productionApiUrls.user}/api/v1/users/profile_picture'));
    String token = await storage.getUserToken();
    String permalink = await storage.getPermalink();
    String deviceId = await storage.getDeviceId();
    request.headers["Authorization"] = 'Bearer $token';
    request.headers["SpotterUserId"] = permalink;
    request.headers["SpotterDeviceId"] = deviceId;
    request.files.add(await http.MultipartFile.fromPath('image', _image.path));
    var res = await request.send();

    var response = jsonDecode(await res.stream.bytesToString());
    if (response["statusCode"] == 200) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      await storage.saveUserImgUrl(response["url"]);
      Provider.of<AppState>(context, listen: false)
          .setUserImgUrl(response["url"]);
    }
  } catch (e) {
    print("error");
    print(e);
  }
}

uploadMultiImages(BuildContext context, List<XFile> _images) async {
  try {
    Provider.of<AppState>(context, listen: false).enableSpinner();
    var request = http.MultipartRequest(
        'POST', Uri.parse('${productionApiUrls.company}/company_images'));
    final SecureStorage storage = SecureStorage();
    String companyPermalink = await storage.getCompanyPermalink();
    String token = await storage.getUserToken();
    String permalink = await storage.getPermalink();
    String deviceId = await storage.getDeviceId();
    request.headers["Authorization"] = 'Bearer $token';
    request.headers["SpotterUserId"] = permalink;
    request.headers["SpotterDeviceId"] = deviceId;
    _images.forEach((_image) async {
      request.files
          .add(await http.MultipartFile.fromPath('image[]', _image.path));
    });
    request.fields.addAll({"permalink": companyPermalink});
    var res = await request.send();

    var response = jsonDecode(await res.stream.bytesToString());
    if (response["statusCode"] == 200) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print(response);
      if (response["urls"].length > 0) {
        await storage.saveUserImgUrl(response["urls"][0]["url"]);
        Provider.of<AppState>(context, listen: false)
            .setUserImgUrl(response["urls"][0]["url"]);
      }
    }
  } catch (e) {
    print("error");
    print(e);
    Provider.of<AppState>(context, listen: false).disableSpinner();
  }
}
