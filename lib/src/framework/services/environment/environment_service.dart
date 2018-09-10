import 'dart:html';
import 'dart:async';


import 'package:app_scaffold/src/framework/app/app_logging.dart';

import 'package:angular/core.dart';



/**
 * Service to configure the application
 */

@Injectable()
class EnvironmentService {

  bool isRunningLocally;
  bool isRunningOnDev;
  bool isRunningOnStaging;
  bool isRunningInProduction;

  bool isDevMode;


  EnvironmentService() {
    _init();
  }


  void _init() {

    _setProdDefaults();
    _detectRunningLocation();

    // override the settings for staging servers
    if (isRunningOnStaging) {

    }

    // override the settings for dev servers
    if (isRunningOnDev) {

    }

    // override the settings for local dev
    if (isRunningLocally) {

    }

  }

  void _setProdDefaults() {
    isDevMode = false;

    isRunningOnStaging = false;
    isRunningLocally = false;
    isRunningOnDev = false;
    isRunningInProduction = true;


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
