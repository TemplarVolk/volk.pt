import 'dart:html';

import 'package:angular/angular.dart';

@Directive(selector: '[unsafeInnerHTML]')
class UnsafeInnerHTML {
  Element el;

  UnsafeInnerHTML(this.el);

  @Input()
  set unsafeInnerHTML(String val) => el.setInnerHtml(val, treeSanitizer: NodeTreeSanitizer.trusted);
}
