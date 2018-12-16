import 'package:event_bus/event_bus.dart';
import 'package:zpj_github_app/common/event/HttpErrorEvent.dart';

class Code {
  static const NET_WORK_ERROR = -1;
  static const NET_TIME_OUT = -2;
  static const NET_JSON_EXCEPTION = -3;
  static const SUCCESS = 200;
  static final EventBus eventBus = new EventBus();

  static errorHandleFunction(code, msg, noTip) {
    if (noTip) {
      return msg;
    }
    eventBus.fire(new HttpErrorEvent(code, msg));
    return msg;
  }
}
