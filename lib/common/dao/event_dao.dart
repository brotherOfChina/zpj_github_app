import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:zpj_github_app/common/model/User.dart';
import 'package:zpj_github_app/common/redux/ZpjRedux.dart';

class EventDao{
  static getEventReceived(Store<ZpjState> store,{page=1,bool needDn=false})async{
    User user=store.state.userInfo;
    if(user ==null || user.login==null){
      return null;
    }

  }
}