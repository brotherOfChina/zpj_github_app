import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget {
  //底部模式  type
  static const int BOTTOM_TAB = 1;

  ///顶部模式  type
  static const int TOP_TAB = 2;

  final int type;

  final List<Widget> tabItems;

  final List<Widget> tabViews;

  final Color backgroundColor;

  final Color indicatorColor;

  final Widget title;

  final Widget drawer;

  final Widget floatingActionButton;

  final TarWidgetControl tarWidgetControl;

  final PageController pageController;

  final ValueChanged<int> onPageChanged;

  const TabBarWidget(
      {Key key,
      this.type,
      this.tabItems,
      this.tabViews,
      this.backgroundColor,
      this.indicatorColor,
      this.title,
      this.drawer,
      this.floatingActionButton,
      this.tarWidgetControl,
      this.pageController,
      this.onPageChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TabBarWidget(
        type,
        tabViews,
        indicatorColor,
        title,
        drawer,
        floatingActionButton,

        tarWidgetControl,
        pageController,
        onPageChanged);
  }
}

class _TabBarWidget extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  final int _type;
  final List<Widget> _tabViews;
  final Color _indicatorColor;
  final Widget _title;
  final Widget _drawer;
  final Widget _floatingActionButton;
  final TarWidgetControl _tarWidgetControl;
  final PageController _pageController;
  final ValueChanged<int> _onPageChange;

  _TabBarWidget(
      this._type,
      this._tabViews,
      this._indicatorColor,
      this._title,
      this._drawer,
      this._floatingActionButton,
      this._tarWidgetControl,
      this._pageController,
      this._onPageChange)
      : super();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(length: widget.tabItems.length, vsync: this);
  }

  ///整个页面dispose时，记得把控制器dispose时，释放内存
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (this._type == TabBarWidget.TOP_TAB) {
      ///顶部tab
      return new Scaffold(
        floatingActionButton: _floatingActionButton,
        persistentFooterButtons:
            _tarWidgetControl == null ? [] : _tarWidgetControl.footerButton,
        appBar: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: _title,
          bottom: new TabBar(
            tabs: widget.tabItems,
            controller: _tabController,
            indicatorColor: _indicatorColor,
          ),
        ),
        body: new PageView(
          controller: _pageController,
          children: _tabViews,
          onPageChanged: (index) {
            _tabController.animateTo(index);
            _onPageChange?.call(index);
          },
        ),
      );
    } else {
      return new Scaffold(
        drawer: _drawer,
        appBar: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: _title,
        ),
        body: new TabBarView(
          children: _tabViews,
          controller: _tabController,
        ),
        bottomNavigationBar: new Material(
          color: Theme.of(context).primaryColor,
          child: new TabBar(
            tabs: widget.tabItems,
            controller: _tabController,
            indicatorColor: _indicatorColor,
          ),
        ),
      );
    }
  }
}

class TarWidgetControl {
  List<Widget> footerButton = [];
}
