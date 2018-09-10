
import 'dart:html';
import 'dart:convert';

/**
 * Helper class to decode and find JWT expiration.
 */

class JwtHelper {

  String urlBase64Decode(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;

      case 2:
        output += '==';
        break;

      case 3:
        output += '=';
        break;

      default:
        throw new Exception('Illegal base64url string!');
    }


    return Uri.decodeComponent(Uri.encodeFull(window.atob(output)));
  }

  Map decodeToken(String token) {
    List<String> parts = token.split('.');

    if (parts.length != 3) {
      throw new Exception('JWT must have 3 parts');
    }

    String decoded = this.urlBase64Decode(parts[1]);

    return jsonDecode(decoded);
  }


  dynamic getTokenExpirationDate(String token) {
    Map decodedPayload;
    decodedPayload = this.decodeToken(token);

    if (!decodedPayload.containsKey('exp')) {
      return null;
    }

    DateTime date = new DateTime.fromMillisecondsSinceEpoch(
        decodedPayload['exp'] * 1000);

    return date;
  }

  bool isTokenExpired(String token, {int offsetSeconds: 0}) {
    bool isExpired = false;

    DateTime expDate = this.getTokenExpirationDate(token);

    if (expDate != null) {
      DateTime currentDateWithOffset = new DateTime.now().add(
          new Duration(seconds: (offsetSeconds)));

      if (expDate.millisecondsSinceEpoch <
          currentDateWithOffset.millisecondsSinceEpoch) {
        isExpired = true;
      }
    }

    return isExpired;
  }

}


