import 'package:angular/angular.dart';
// import 'package:angular/experimental.dart';
import 'package:angular_router/angular_router.dart';
import 'package:volkpt/util.dart';

// import '../api_service.dart';

@Component(
  selector: 'index',
  templateUrl: 'index_component.html',
  styleUrls: ['index_component.css'],
  directives: [
    // NgForIdentity,
    // NgIf,
    routerDirectives,
  ],
  encapsulation: ViewEncapsulation.None,
)
class IndexComponent implements OnActivate {
  // final ApiService _apiService;

  List<Map> items;

  IndexComponent(/*this._apiService*/);

  @override
  void onActivate(_, RouterState current) {
    init();
  }
}
