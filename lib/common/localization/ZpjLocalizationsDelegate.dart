import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zpj_githup_app/common/localization/DefaultLocalizations.dart';

  /**
  *   author：Administrator
  *   create_date:14:32
  *   note:多语言处理
  */
class ZpjLocalizationsDelegate extends LocalizationsDelegate<ZpjLocalizations>{
    ZpjLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) {
    ///支持中文和英语
    return ['en','zh'].contains(locale.languageCode);
  }

  @override
  Future<ZpjLocalizations> load(Locale locale) {
    ///根据locale，创建一个对象用于提供当前locale下的文本显示
    return new SynchronousFuture(new ZpjLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<ZpjLocalizations> old) {
    // TODO: implement shouldReload
    return false;
  }
  ///全局静态的代理
  static ZpjLocalizationsDelegate delegate=new ZpjLocalizationsDelegate();

}
