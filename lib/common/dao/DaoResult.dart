import 'dart:async';

class DaoResult {
  var data;
  bool result;
  Future next;

  DaoResult(this.data, this.result, {this.next});
}
