// Ignore generated templates imported for route definitions.
// ignore_for_file: uri_has_not_been_generated
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/index_component.template.dart' as index;
import 'src/routes.dart';

@Component(
  selector: 'app',
  templateUrl: 'app_component.html',
  directives: [routerDirectives],
  styleUrls: ['app_component.css'],
  encapsulation: ViewEncapsulation.None,
)
class AppComponent {
  static final indexUrl = indexRoutePath.toUrl();
  // static final boardUrl = boardRoutePath.toUrl();
  // static final showUrl = showRoutePath.toUrl();
  // static final askUrl = askRoutePath.toUrl();
  // static final jobsUrl = jobsRoutePath.toUrl();

  static final routes = [
    RouteDefinition(
      routePath: indexRoutePath,
      component: index.IndexComponentNgFactory,
    ),
    // RouteDefinition(
    //   routePath: boardRoutePath,
    //   component: board.BoardComponentNgFactory,
    // ),
    // RouteDefinition(
    //   routePath: showRoutePath,
    //   component: feed.FeedComponentNgFactory,
    // ),
    // RouteDefinition(
    //   routePath: askRoutePath,
    //   component: feed.FeedComponentNgFactory,
    // ),
    // RouteDefinition(
    //   routePath: jobsRoutePath,
    //   component: feed.FeedComponentNgFactory,
    // ),
    // RouteDefinition.defer(
    //   routePath: itemRoutePath,
    //   loader: () {
    //     return item_detail.loadLibrary().then((_) {
    //       return item_detail.ItemDetailComponentNgFactory;
    //     });
    //   },
    // ),
  ];
}
