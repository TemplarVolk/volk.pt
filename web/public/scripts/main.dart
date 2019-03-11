import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

// We are ignoring files that will be generated at compile-time.
// ignore: uri_has_not_been_generated
import 'package:volkpt/app_component.template.dart' as app;
import 'package:volkpt/api_service.dart';

// We are ignoring files that will be generated at compile-time.
// ignore: uri_has_not_been_generated
import 'main.template.dart' as ng;

@GenerateInjector([
  // HTTP and Services.
  FactoryProvider(ApiService, getApiService),

  // SPA Router.
  routerProviders,
])
final InjectorFactory volkptApp = ng.volkptApp$Injector;

ApiService _service;
ApiService getApiService() => _service;

void main() {

  _service = ApiService(apiBaseUrl);
  // Future future;
  // final path = window.location.pathname;
  // if (window.location.search.isEmpty && !path.startsWith('/item')) {
  //   future = _service.getBoards();
  // }

  // future.then((_) {
  //   runApp(
  //     app.AppComponentNgFactory,
  //     createInjector: volkptApp,
  //   );
  // });

  runApp(
    app.AppComponentNgFactory,
    createInjector: volkptApp,
  );
}