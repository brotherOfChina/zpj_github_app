import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:zpj_github_app/common/config/Config.dart';
import 'package:zpj_github_app/common/dao/event_dao.dart';
import 'package:zpj_github_app/widget/list_state.dart';

class DynamicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

class _DanamicPageState extends State<DynamicPage>
    with
        AutomaticKeepAliveClientMixin<DynamicPage>,
        ListState<DynamicPage>,
        WidgetsBindingObserver {
  @override
  Future<Null> handleRefresh()async {
    if(isLoading){
      return null;
    }
    isLoading=true;
    page=1;
    return super.handleRefresh();
  }
  @override
  bool get wantKeepAlive => null;

  @override
  bool get isRefreshFirst => null;
}
