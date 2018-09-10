import 'package:angular/angular.dart';

import 'src/framework/app/app_logging.dart';

import 'src/todo_list/todo_list_component.dart';
import 'src/framework/services/environment/environment_service.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components


const List<dynamic> appProviders =[
  EnvironmentService,


];


@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [TodoListComponent],
  providers: appProviders
)
class AppComponent implements OnInit {


  final Logger log = new Logger('AppComponent');

  final EnvironmentService envService;

  AppComponent(
      this.envService
    ) {


  }

  @override
  void ngOnInit()  {
     if(this.envService.isDevMode) {
       _setupAppLogging();
     }
  }


  _setupAppLogging () {

    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.loggerName} - ${rec.level.name}: ${rec.time}: ${rec.message}');
    });

    log.config('Logging has been enabled');

  }

}
