import 'package:flutter/material.dart';
import 'package:zpj_github_app/common/style/ZPJStyle.dart';
import 'package:zpj_github_app/common/utils/CommonUtils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PullLoadWidget extends StatefulWidget {
  ///item渲染
  final IndexedWidgetBuilder itemBuilder;

  ///加载更多回调
  final RefreshCallback onLoadMore;

  ///下拉刷新回调
  final RefreshCallback onRefresh;

  final PullLoadWidgetControl control;
  final Key refreshKey;

  PullLoadWidget(
      this.itemBuilder, this.onLoadMore, this.onRefresh, this.control,
      {this.refreshKey});

  ///刷新加载控制器

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

class _PullLoadWidgetState extends State<PullLoadWidget> {
  ///item渲染
  final IndexedWidgetBuilder itemBuilder;

  ///加载更多回调
  final RefreshCallback onLoadMore;

  ///下拉刷新回调
  final RefreshCallback onRefresh;

  final PullLoadWidgetControl control;
  final Key refreshKey;

  _PullLoadWidgetState(this.control, this.itemBuilder, this.onRefresh,
      this.onLoadMore, this.refreshKey);

  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    ///增加滑动监听
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (this.control.needLoadMore) {
          this.onLoadMore?.call();
        }
      }
    });
    super.initState();
  }

  _getListCount() {
    if (control.needHeader) {
      return (control.dataList.length > 0)
          ? control.dataList.length + 2
          : control.dataList.length + 1;
    } else {
      if (control.dataList.length == 0) {
        return 1;
      }
      return (control.dataList.length > 0)
          ? control.dataList.length + 1
          : control.dataList.length;
    }
  }

  _getItem(int index) {
    if (!control.needHeader &&
        index == control.dataList.length &&
        control.dataList.length != 0) {
      ///如果不需要头部，并且数据不为0，当index等于数据长度时，渲染加载更多Item（因为index是从0开始）
      return _buildProgressIndicator();
    } else if (control.needHeader &&
        index == _getListCount() - 1 &&
        control.dataList.length != 0) {
      ///如果需要头部，并且数据不为0，当index等于实际渲染长度 - 1时，渲染加载更多Item（因为index是从0开始）

      return _buildProgressIndicator();
    } else if (!control.needHeader && control.dataList.length == 0) {
      return _buildEmpty();
    } else {
      return itemBuilder(context, index);
    }
  }

  Widget _buildEmpty() {
    return new Container(
      height: MediaQuery.of(context).size.height - 100,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: () {},
              child: new Image(
                image: new AssetImage(ZpjICons.DEFAULT_USER_ICON),
                width: 70.0,
                height: 70.0,
              )),
          Container(
            child: Text(
              CommonUtils.getLocale(context).app_empty,
              style: ZpjConstant.normalText,
            ),
          )
        ],
      ),
    );
  }

  ///上拉加载更多
  Widget _buildProgressIndicator() {
    Widget bottomWidget = (control.needLoadMore)
        ? new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SpinKitFadingCircle(color: Theme.of(context).primaryColor),
              new Container(
                width: 4.0,
              ),
              new Text(
                CommonUtils.getLocale(context).load_more_text,
                style: TextStyle(
                    color: Color(0xFF121917),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        : new Container();
    return new Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Center(
        child: bottomWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      child: new ListView.builder(

          ///保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题。
          physics: const AlwaysScrollableScrollPhysics(),

          itemBuilder: (context,index){
            return _getItem(index);
          },
        itemCount: _getListCount(),
        controller: _scrollController,
      ),

      onRefresh: onRefresh,
      key: refreshKey,
    );
  }
}

class PullLoadWidgetControl {
  List dataList = new List();
  bool needLoadMore = true;
  bool needHeader = false;
}
