

import 'dart:html';
import 'dart:async';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:app_scaffold/src/framework/endpoints/vo_interface.dart';

import 'ep_resp.dart';

class Endpoint {

  int maxRetry = 3;
  int currentAttempt = 1;
  int timerAmount = 1;

  Completer completer;
  HttpRequest _httpRequest;
  Logger _logger = new Logger('Endpoint');

  /// ID that will be returned once the load is complete
  String _id;

  IVO _data;
  String _url;
  String _method;
  String _contentType;
  String _authToken;

  /**
   * Requests the endpoint service for any url and data given
   *
   *     retrun Future
   */
  Future sendData(String url, {String method: 'POST',
  String authToken: '',
  IVO data: null,
  String loaderId : '0',
  String contentType:'application/json'}){

    _url = url;
    _method = method;
    _data = data;
    _id = loaderId;
    _contentType = contentType;
    _authToken = authToken;

    completer = new Completer();

    this._actualSend();

    return completer.future;

  }

  void _actualSend() {

    _logger.info('$runtimeType: contacting $_url');

    _httpRequest = new HttpRequest()
      ..open(_method, _url)
      ..setRequestHeader('Authorization', 'Bearer ' + _authToken)
      ..setRequestHeader('Content-type', _contentType)
      ..onLoadEnd.listen((e) => _loadEnd(_httpRequest, _url));
      //..overrideMimeType(_contentType)
    if(_data != null) {
      _httpRequest.send(_data.toString());
    }else{
      _httpRequest.send();
    }

  }

  void _startRetryTimeout() {

    int delay = pow(timerAmount*currentAttempt, 2);

    _logger.info('$runtimeType: delaying call for ${delay} sec to $_url');

    Duration d = new Duration(seconds: delay);
    new Timer(d, (){
      this._actualSend();
    });
  }


  void _loadEnd(HttpRequest request, String url) {

    EndpointRespVO respVO = new EndpointRespVO();

    respVO.loaderId = this._id;
    respVO.respData = request.responseText;
    respVO.statusCode = request.status;

    switch(request.status) {


      case  200:
      case  204:
        _logger.info('$runtimeType: success - $url ');

        respVO.success = true;
        completer.complete(respVO);
        break;

      case 409:
        _logger.warning('$runtimeType: 409 conflict - ${url} ');
        respVO.success = false;
        completer.completeError(respVO);
        break;

      // if there is a 500 or an options error we want to try a few more times
      case 0:
      case 500:
        _logger.warning('$runtimeType: 500 error - ${url} ');

        if(currentAttempt <= maxRetry) {

          _logger.info('$runtimeType: retrying - $url ');
          currentAttempt++;
          _startRetryTimeout();

        } else {

          _logger.shout('$runtimeType: 500 error - HIT MAX RETRYS FOR: $url ');
          respVO.success = false;
          completer.completeError(respVO);

        }

        break;

      default:
        _logger.warning('$runtimeType: FAILED ${request.status} - $url');
        _logger.warning(respVO.respData);

        respVO.success = false;
        completer.completeError(respVO);


    }

  }
}