import 'package:flutter/material.dart';
import 'package:zpj_github_app/page/home_page.dart';
/**
*   author：Administrator
*   create_date:2018/12/28 0028-9:02
*   note:
*/
class NavigatorUtils{
  ///主页
  static goHome(BuildContext context){
    Navigator.pushReplacementNamed(context, HomePage.sName);

  }
}