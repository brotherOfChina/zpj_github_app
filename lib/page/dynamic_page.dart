import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:zpj_github_app/common/config/Config.dart';
import 'package:zpj_github_app/common/dao/event_dao.dart';
import 'package:zpj_github_app/common/dao/event_dao.dart';
import 'package:zpj_github_app/widget/list_state.dart';
import 'package:zpj_github_app/common/redux/ZpjRedux.dart';

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
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var result =
        await EventDao.getEventReceived(_getStore(), page: page, needDb: true);
    setState(() {
      control.needLoadMore =
          (result != null && result.length == Config.PAGE_SIZE);
    });
    isLoading = false;
    return null;
  }

  @override
  Future<Null> onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    var result = await EventDao.getEventReceived(_getStore(), page: page);
    setState(() {
      control.needLoadMore = (result != null);
    });
    isLoading = false;
    return null;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() {
    return super.requestRefresh();
  }

  @override
  requestLoadMore() {
    return super.requestLoadMore();
  }

  @override
  bool get isRefreshFirst => false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }

  Store<ZpjState> _getStore() {
    return StoreProvider.of(context);
  }
}
