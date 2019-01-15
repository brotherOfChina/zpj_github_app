import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zpj_github_app/common/config/Config.dart';
import 'package:zpj_github_app/widget/pull_load_widget.dart';

/**
 *   author：Administrator
 *   create_date:2019/1/11 0011-10:20
 *   note:上拉刷新列表的通用State
 */
mixin ListState<T extends StatefulWidget>
    on State<T>, AutomaticKeepAliveClientMixin<T> {
  bool isShow = false;
  bool isLoading = false;
  int page = 1;
  final List dataList = new List();
  final PullLoadWidgetControl control = new PullLoadWidgetControl();
  final GlobalKey<RefreshIndicatorState> key = new GlobalKey();

  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      key.currentState.show().then((e) {});
      return true;
    });
  }

  @protected
  resolveRefreshResult(res) {
    if (res != null && res.result) {
      control.dataList.clear();
      if (isShow) {
        setState(() {
          control.dataList.addAll(res.data);
        });
      }
    }
  }

  @protected
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var res = await requestRefresh();
    resolveRefreshResult(res);
    resolveDataResult(res);
    if (res.next != null) {
      var resNext = await res.next;
      resolveRefreshResult(resNext);
      resolveDataResult(resNext);
    }
    isLoading = false;
    return null;
  }

  @protected
  resolveDataResult(res) {
    if (isShow) {
      setState(() {
        control.needLoadMore = (res != null &&
            res.data != null &&
            res.data.length == Config.PAGE_SIZE);
      });
    }
  }

  @protected
  clearData() {
    if (isShow) {
      setState(() {
        control.dataList.clear();
      });
    }
  }

  ///下拉刷新数据
  @protected
  requestRefresh() async {}

  ///上拉加载更多
  @protected
  requestLoadMore() async {}

  ///是否需要第一次进入自动刷新
  @protected
  bool get isRefreshFirst;

  ///是否需要头部
  @protected
  bool get needHeader => false;

  ///是否需要保持数据
  bool get wanKeepAlive => true;

  List get getDataList => dataList;

  @override
  void initState() {
    isShow = true;
    super.initState();
    control.needHeader = needHeader;
    control.dataList = dataList;
    if (control.dataList.length == 0 && isRefreshFirst) {
      showRefreshLoading();
    }
  }

  @override
  dispose() {
    isShow = false;
    isLoading = false;
    super.dispose();
  }
}
