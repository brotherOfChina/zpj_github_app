import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zpj_github_app/common/style/ZpjStringBase.dart';
import 'package:zpj_github_app/common/style/ZpjStringEn.dart';
import 'package:zpj_github_app/common/style/ZpjStringZh.dart';


class ZpjLocalizations{
  final Locale locale;
  ZpjLocalizations(this.locale);

  static Map<String,ZpjStringBase> _localizationValues={
    'en':new ZpjStringEn(),
    'zh':new ZpjStringZh(),
  };

  ///根据不同 locale.languageCode 加载不同语言对应
  ///GSYStringEn和GSYStringZh都继承了GSYStringBase
  ZpjStringBase get currentLocalized{
    return _localizationValues[locale.languageCode];
  }
  ///通过 Localizations 加载当前的 GSYLocalizations
  ///获取对应的 GSYStringBase
  static ZpjLocalizations of(BuildContext context) {
    return Localizations.of(context,ZpjLocalizations);
  }

}