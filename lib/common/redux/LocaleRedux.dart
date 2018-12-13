import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

/**
 *   author：Administrator
 *   create_date:11:31
 *   note:语言redux
 */
final LocaleReducer = combineReducers<Locale>([
TypedReducer<Locale, RefreshLocaleAction> (_refresh)]);

Locale _refresh(Locale locale, RefreshLocaleAction action) {
  locale = action.locale;
  return locale;
}
class RefreshLocaleAction {
  final Locale locale;

  RefreshLocaleAction(this.locale);
}