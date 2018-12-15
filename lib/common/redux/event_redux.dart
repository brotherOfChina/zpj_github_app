import 'package:zpj_github_app/common/model/Event.dart';
import 'package:redux/redux.dart';

/**
 *   author：zpj
 *   create_date:10:36
 *   note:事件提供者
 */
final EventReducer = combineReducers<List<Event>>([
  TypedReducer<List<Event>, RefreshEventAction>(_refresh),
  TypedReducer<List<Event>, LoadMoreEventAction>(_refresh),

]);

List<Event> _refresh(List<Event> list, action) {
  list.clear();
  if (action.list == null) {
    return list;
  } else {
    list.addAll(action.list);
    return list;
  }
}
List<Event> _loadMore(List<Event> list,action){
  if(action.list!=null){
    list.addAll(action.list);
  }
  return list;
}

class RefreshEventAction{
  final List<Event> list;
  RefreshEventAction(this.list);

}

class LoadMoreEventAction{
  final List<Event> list;
  LoadMoreEventAction(this.list);
}
