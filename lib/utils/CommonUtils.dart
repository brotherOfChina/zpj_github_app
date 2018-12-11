import 'package:flutter/material.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';
import 'package:path_provider/path_provider.dart';//路径提供
import 'package:permission_handler/permission_handler.dart';//权限
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:redux/redux.dart';
/// 自定义///
import 'package:zpj_githup_app/net/Address.dart';
import 'package:zpj_githup_app/style/ZPJStyle.dart';
import 'package:zpj_githup_app/redux/ThemeRedux.dart';

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
  static String getDateStr(DateTime date){
      if(date==null||date.toString()==null){
        return "";
      }else if(date.toString().length<10){
        return date.toString();
      }
      return date.toString().substring(0,10);
  }

  static String getUserChartAddress(String userName){
    return Address.graphicHost+"/"+userName;
  }
  ///日期格式转换
  static String getNewsTimeStr(DateTime date){
    int subTime=DateTime.now().millisecondsSinceEpoch-date.millisecondsSinceEpoch;
    if(subTime<MILLIS_LIMIT){
      return "刚刚";
    }else if (subTime < SECONDS_LIMIT) {
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
  static getLocalPath() async{
    Directory appDir;
    if(Platform.isIOS){
      appDir=await getApplicationDocumentsDirectory();
    }else{
      appDir=await getExternalStorageDirectory();
    }
    PermissionStatus permissionStatus=await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if(permissionStatus!=PermissionStatus.granted){
      Map <PermissionGroup,PermissionStatus> permissionMap=await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      if(permissionMap[PermissionGroup.storage]!=PermissionStatus.granted){
        SnackBar(content: Text("申请权限失败,无法进行存储"));
        return null;
      }
    }
    String appDocPath=appDir.path+"/zpjgithubappflutter";
    Directory appPath=Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath;
    
  }
  ///按路径拆分文件名
  static splitFileNameByPath(String path) {
    return path.substring(path.lastIndexOf("/"));
  }
   static saveImage(String url)async{
    Future<String> _findPath(String  imgUrl) async{
      final cache=await CacheManager.getInstance();
      final file=await cache.getFile(imgUrl);
      if(file==null){
        return null;
      }
      Directory localPath=await CommonUtils.getLocalPath();
      if(localPath==null){
        return null;
      }
      final name=splitFileNameByPath(file.path);
      final result=await file.copy(localPath.path+name);
      return result.path;

    }

   }
   static getFullName(String repositoryUrl){
      if(repositoryUrl!=null&&repositoryUrl.substring(repositoryUrl.length-1)=="/"){
        repositoryUrl=repositoryUrl.substring(0,repositoryUrl.length-1);

      }
      String fullName="";
      if(repositoryUrl!=null){
        List<String> splicUrl=repositoryUrl.split("/");
        if(splicUrl.length>2){
          fullName=splicUrl[splicUrl.length-2]+"/"+splicUrl[splicUrl.length-1];
        }
      }
      return fullName;
   }
   static pushTheme(Store store,int index){
      ThemeData themeData;
      List<Color> colors=getThemeListColor();
      themeData=new ThemeData(primarySwatch: colors[index],platform: TargetPlatform.iOS);
//      store.dispatch(new )


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




































}
