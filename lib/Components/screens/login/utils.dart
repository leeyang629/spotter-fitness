import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:provider/provider.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/storage.dart';
import 'package:spotter/providers/app_state.dart';

String transformPersona(String value) {
  if (value == "user") {
    return "User";
  }
  if (value == "trainer") {
    return "Trainer";
  }
  if (value == "owner") {
    return "Gym Owner";
  }
  return "User";
}

class LoginUtil {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>["email"]);
  final FacebookLogin facebookLogin = FacebookLogin();
  bool isUserSignedIn = false;
  final SecureStorage storage = SecureStorage();
  String persona = "";

  LoginUtil() {
    initApp();
  }

  void initApp() async {
    this.persona = transformPersona(await storage.getPersona());
  }

  Future onFbSignIn(String persona) async {
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        // print('''
        //  FB Logged in!

        //  Token: ${accessToken.token}
        //  User id: ${accessToken.userId}
        //  Expires: ${accessToken.expires}
        //  Permissions: ${accessToken.permissions}
        //  Declined permissions: ${accessToken.declinedPermissions}
        //  ''');
        // final graphResponse = await get(
        //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}');
        // final profile = json.decode(graphResponse.body);
        // _sendTokenToServer(result.accessToken.token);
        // _showLoggedInUI();
        // print(profile);
        final apiCall = HttpClient(productionApiUrls.user);
        final apiResult = await apiCall.post(
            '/api/v1/users/facebook_login?id_token=${accessToken.token}&role=$persona',
            {});
        if (apiResult["statusCode"] == 200) {
          return apiResult;
        }
        return {};
        // navigateToOnboarding();
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('FB Log In cancelled');
        // _showCancelledMessage();
        break;
      case FacebookLoginStatus.error:
        print('FB login Error');
        // _showErrorOnUI(result.errorMessage);
        break;
    }
  }

  Future signIn(String username, String password) async {
    final apiCall = HttpClient(productionApiUrls.user);
    final result = await apiCall
        .post('/api/v1/users/login?username=$username&password=$password', {});
    print(result);
    if (result['statusCode'] == 200) {
      return result;
    }
    return {};
  }

  Future handleGoogleSignIn(String persona) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      // username.text = googleAuth.idToken;
      // print('googleAuth');
      // print(googleAuth.accessToken);
      // print(googleAuth.idToken);
      // Clipboard.setData(ClipboardData(text: googleAuth.idToken));
      // username.text = googleAuth.idToken;
      // print(googleUser.email);
      // print(googleUser.displayName);
      // print(googleUser.id);
      // print(googleUser.photoUrl);
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final apiCall = HttpClient(productionApiUrls.user);
      final result = await apiCall.post(
          '/api/v1/users/google_login?id_token=${googleAuth.idToken}&role=$persona',
          {});
      if (result["statusCode"] == 200) {
        await _googleSignIn.disconnect();
        return result;
      }
      return null;
    }
    return null;
  }
}
