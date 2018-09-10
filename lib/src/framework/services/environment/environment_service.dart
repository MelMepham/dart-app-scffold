import 'dart:html';
import 'dart:async';


import 'package:app_scaffold/src/framework/app/app_logging.dart';

import 'package:angular/core.dart';



/**
 * Service to configure the application
 */

@Injectable()
class EnvironmentService {

  bool isRunningLocally       = false;
  bool isRunningOnDev         = false;
  bool isRunningOnStaging     = false;
  bool isRunningInProduction  = true;

  bool isDevMode = false;


  EnvironmentService() {
    _init();
  }


  void _init() {

    _detectRunningLocation();

  }
  

  void _detectRunningLocation() {

    isRunningLocally = (window.location.host.contains('localhost'));
    isRunningOnDev = (window.location.host.contains('dev'));
    isRunningOnStaging = (window.location.host.contains('staging'));

    if(isRunningLocally || isDevMode || isRunningOnStaging) {
      isRunningInProduction = false;
      isDevMode = true;
    }



  }

}
