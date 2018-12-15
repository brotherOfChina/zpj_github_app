import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';
import 'package:path_provider/path_provider.dart'; //路径提供
import 'package:permission_handler/permission_handler.dart'; //权限
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:redux/redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// 自定义///
import 'package:zpj_github_app/net/Address.dart';
import 'package:zpj_github_app/common/style/ZPJStyle.dart';
import 'package:zpj_github_app/common/redux/ThemeRedux.dart';
import 'package:zpj_github_app/common/redux/ZpjRedux.dart';
import 'package:zpj_github_app/common/redux/LocaleRedux.dart';
import 'package:zpj_github_app/common/style/ZpjStringBase.dart';
import 'package:zpj_github_app/common/localization/DefaultLocalizations.dart';
import 'package:zpj_github_app/common/localization/ZpjLocalizationsDelegate.dart';
import 'package:zpj_github_app/widget/IssueEditDialog.dart';
import 'package:zpj_github_app/widget/FlexButton.dart';

/**
 * 通用工具类
 * createtime: 2018/12/11
 * author:zpj
 * updateTime:
 */
class CommonUtils {
  static final double MILLIS_LIMIT = 1000.0;

  static final double SECONDS_LIMIT = 60 * MILLIS_LIMIT;

  static final double MINUTES_LIMIT = 60 * SECONDS_LIMIT;

  static final double HOURS_LIMIT = 24 * MINUTES_LIMIT;

  static final double DAYS_LIMIT = 30 * HOURS_LIMIT;

  static double sStaticBarHeight = 0.0;

  static void initStatusBarHeight(context) async {
    sStaticBarHeight =
        await FlutterStatusbar.height / MediaQuery.of(context).devicePixelRatio;
  }

  // 日期转换string
  static String getDateStr(DateTime date) {
    if (date == null || date.toString() == null) {
      return "";
    } else if (date.toString().length < 10) {
      return date.toString();
    }
    return date.toString().substring(0, 10);
  }

  static String getUserChartAddress(String userName) {
    return Address.graphicHost + "/" + userName;
  }

  ///日期格式转换
  static String getNewsTimeStr(DateTime date) {
    int subTime =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    if (subTime < MILLIS_LIMIT) {
      return "刚刚";
    } else if (subTime < SECONDS_LIMIT) {
      return (subTime / MILLIS_LIMIT).round().toString() + " 秒前";
    } else if (subTime < MINUTES_LIMIT) {
      return (subTime / SECONDS_LIMIT).round().toString() + " 分钟前";
    } else if (subTime < HOURS_LIMIT) {
      return (subTime / MINUTES_LIMIT).round().toString() + " 小时前";
    } else if (subTime < DAYS_LIMIT) {
      return (subTime / HOURS_LIMIT).round().toString() + " 天前";
    } else {
      return getDateStr(date);
    }
  }

  ///获取本地存储路径
  static getLocalPath() async {
    Directory appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getExternalStorageDirectory();
    }
    PermissionStatus permissionStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permissionStatus != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissionMap =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissionMap[PermissionGroup.storage] != PermissionStatus.granted) {
        SnackBar(content: Text("申请权限失败,无法进行存储"));
        return null;
      }
    }
    String appDocPath = appDir.path + "/zpjgithubappflutter";
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath;
  }

  ///按路径拆分文件名
  static splitFileNameByPath(String path) {
    return path.substring(path.lastIndexOf("/"));
  }

  static saveImage(String url) async {
    Future<String> _findPath(String imgUrl) async {
      final cache = await CacheManager.getInstance();
      final file = await cache.getFile(imgUrl);
      if (file == null) {
        return null;
      }
      Directory localPath = await CommonUtils.getLocalPath();
      if (localPath == null) {
        return null;
      }
      final name = splitFileNameByPath(file.path);
      final result = await file.copy(localPath.path + name);
      return result.path;
    }
  }

  static getFullName(String repositoryUrl) {
    if (repositoryUrl != null &&
        repositoryUrl.substring(repositoryUrl.length - 1) == "/") {
      repositoryUrl = repositoryUrl.substring(0, repositoryUrl.length - 1);
    }
    String fullName = "";
    if (repositoryUrl != null) {
      List<String> splicUrl = repositoryUrl.split("/");
      if (splicUrl.length > 2) {
        fullName =
            splicUrl[splicUrl.length - 2] + "/" + splicUrl[splicUrl.length - 1];
      }
    }
    return fullName;
  }

  static pushTheme(Store store, int index) {
    ThemeData themeData;
    List<Color> colors = getThemeListColor();
    themeData = new ThemeData(
        primarySwatch: colors[index], platform: TargetPlatform.iOS);
    store.dispatch(new RefreshThemeDataAction(themeData: themeData));
  }

  static List<Color> getThemeListColor() {
    return [
      ZPJColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  ///切换语言
  static changeLocale(Store<ZpjState> store, int index) {
    Locale locale = store.state.platformLocale;
    switch (index) {
      case 1:
        locale = Locale('zh', 'CH');
        break;
      case 2:
        locale = Locale('en', 'US');
        break;
    }
    store.dispatch(RefreshLocaleAction(locale));
  }

  static ZpjStringBase getLocale(BuildContext context) {
    return ZpjLocalizations.of(context).currentLocalized;
  }

  ///图片后缀
  static const IMAGE_END = ['.png', '.jpg', '.jpeg', '.gif', '.svg'];

  static isImageEnd(path) {
    bool image = false;
    for (String item in IMAGE_END) {
      if (path.indexof(item) + item.length == path.length) {
        image = true;
      }
    }
    return image;
  }

  //复制
  static copy(String data, BuildContext context) {
    Clipboard.setData(new ClipboardData(text: data));
    Fluttertoast.showToast(
        msg: CommonUtils.getLocale(context).option_share_copy_success);
  }

  static launchUrl(context, String url) {
    if (url == null && url.length == 0) {
      return;
    }
    Uri parseUrl = Uri.parse(url);
    bool isImage = isImageEnd(parseUrl.toString());
    if (parseUrl.toString().endsWith("?raw=true")) {
      isImage = isImageEnd(parseUrl.toString().replaceAll("?raw=truw", ""));
    }
    if (isImage) {
      //todo  跳转到查看图片的页面
      return;
    }
    if (parseUrl != null &&
        parseUrl.host == "github.com" &&
        parseUrl.path.length > 0) {
      List<String> pathNames = parseUrl.path.split("/");
      if (pathNames.length == 2) {
        //解析人
        String userName = pathNames[1];
        //todo 跳转到查看人的页面

      } else if (pathNames.length >= 3) {
        String userName = pathNames[1];
        String repoName = pathNames[2];
        if (pathNames.length == 3) {
          //todo 跳转到仓库详情页
        } else {
          LaunchWebView(context, "", url);
        }
      }
    } else if (url != null && url.startsWith("http")) {
      LaunchWebView(context, "", url);
    }
  }

  static void LaunchWebView(BuildContext context, String title, String url) {
    if (url.startsWith("http")) {
      //todo 跳转到webview
    } else {
//      NavigatorUtils.goGSYWebView(
//          context, new Uri.dataFromString(url, mimeType: 'text/html', encoding: Encoding.getByName("utf-8")).toString(), title);
    }
  }

  static LaunchOutUrl(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: CommonUtils.getLocale(context).option_web_launcher_error +
              ":" +
              url);
    }
  }

  static Future<Null> showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
            color: Colors.transparent,
            child: WillPopScope(
                child: Center(
                  child: new Container(
                    width: 250.0,
                    height: 200.0,
                    padding: const EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          child: SpinKitCubeGrid(color: Color(ZPJColors.white)),
                        ),
                        new Container(
                          height: 10.0,
                        ),
                        new Container(
                          child: new Text(
                              CommonUtils.getLocale(context).loading_text),
                        )
                      ],
                    ),
                  ),
                ),
                onWillPop: () => new Future.value(false)),
          );
        });
  }

  static Future<Null> showEditDialog(
      BuildContext context,
      String dialogTitle,
      ValueChanged<String> onTitleChanged,
      ValueChanged<String> onContentChanged,
      VoidCallback onPressed,
      {TextEditingController titleController,
      TextEditingController valueController,
      bool needTitle = true}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new IssueEditDialog(
              dialogTitle,
              onTitleChanged,
              onContentChanged,
              onPressed,
              titleController: titleController,
              valueController: valueController,
              needTitle: needTitle,
            ),
          );
        });
  }

  static Future<Null> showCommitOptionDialog(
    BuildContext context,
    List<String> commitMaps,
    ValueChanged<int> onTap, {
    width = 250.0,
    height = 400.0,
    List<Color> colorList,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new Container(
              width: width,
              height: height,
              padding: const EdgeInsets.all(4.0),
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Color(ZPJColors.white),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: new ListView.builder(
                itemBuilder: (context, index) {
                  return FlexButton(
                    maxLines: 2,
                    mainAxisAlignment: MainAxisAlignment.start,
                    fontSize: 14.0,
                    color: colorList != null
                        ? colorList[index]
                        : Theme.of(context).primaryColor,
                    text: commitMaps[index],
                    textColor: Color(ZPJColors.white),
                    onPress: () {
                      Navigator.pop(context);
                      onTap(index);
                    },
                  );
                },
                itemCount: commitMaps.length,
              ),
            ),
          );
        });
  }

  static Future<Null> showUpdateDialog(
      BuildContext context, String contentMsg) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(CommonUtils.getLocale(context).app_version_title),
            content: new Text(contentMsg),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text(CommonUtils.getLocale(context).app_cancel)),
              new FlatButton(
                  onPressed: () {
                    launch(Address.updateUrl);
                    Navigator.pop(context);
                  },
                  child: new Text(CommonUtils.getLocale(context).app_ok))
            ],
          );
        });
  }
}
