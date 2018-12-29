import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:zpj_github_app/common/dao/issue_dao.dart';
import 'package:zpj_github_app/common/redux/ZpjRedux.dart';
import 'package:zpj_github_app/common/model/User.dart';
import 'package:zpj_github_app/common/style/ZPJStyle.dart';
import 'package:zpj_github_app/common/utils/CommonUtils.dart';
import 'package:zpj_github_app/common/localization/DefaultLocalizations.dart';
import 'package:zpj_github_app/common/db/repos/repository_issue.dart';
/**
 *   author：Administrator
 *   create_date:2018/12/28 0028-10:10
 *   note:首页drawer
 */
class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: new StoreBuilder<ZpjState>(builder: (context, store) {
        User user = store.state.userInfo;
        return new Drawer(
          child: new Container(
            color: store.state.themeData.primaryColor,
            child: new SingleChildScrollView(
              child: Container(
                constraints: new BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: new Material(
                  color: Color(ZPJColors.white),
                  child: new Column(
                    children: <Widget>[
                      new UserAccountsDrawerHeader(
                        accountName: new Text(
                          user.login ?? "---",
                          style: ZpjConstant.largeTextWhite,
                        ),
                        accountEmail: new Text(
                          user.email ?? "---",
                          style: ZpjConstant.normalTextLight,
                        ),
                        currentAccountPicture: new GestureDetector(
                          onTap: () {},
                          child: new CircleAvatar(
                            backgroundImage: new NetworkImage(
                                user.avatar_url ?? ZpjICons.DEFAULT_USER_ICON),
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color: store.state.themeData.primaryColor,
                        ),
                      ),
                      new ListTile(
                        title: new Text(
                          CommonUtils.getLocale(context).home_reply,
                          style: ZpjConstant.normalText,
                        ),
                        onTap: () {
                          String content = "";
                          CommonUtils.showEditDialog(
                              context,
                              CommonUtils.getLocale(context).home_reply,
                              (title) {}, (res) {
                            content = res;
                          }, () {
                            if (content == null || content.length == 0) {
                              return;
                            }
                            CommonUtils.showLoadingDialog(context);

                          },
                              titleController: new TextEditingController(),
                              valueController: new TextEditingController(),
                              needTitle: false);
                        },
                      ),
                      new ListTile(
                        title: new Text(
                          CommonUtils.getLocale(context).home_history,
                          style: ZpjConstant.normalText,
                        ),
                      ),
                      new ListTile(
                        title: new Hero(
                            tag: "home_user_info",
                            child: new Material(
                              color: Colors.transparent,
                              child: new Text(
                                CommonUtils.getLocale(context).home_user_info,
                                style: ZpjConstant.normalTextBold,
                              ),
                            )),
                        onTap: () {},
                      ),
                      new ListTile(
                        title: new Text(
                          CommonUtils.getLocale(context).home_change_theme,
                          style: ZpjConstant.normalText,
                        ),
                        onTap: () {},
                      ),
                      new ListTile(
                        title: new Text(
                          CommonUtils.getLocale(context).home_change_language,
                          style: ZpjConstant.normalText,
                        ),
                        onTap: () {},
                      ),
                      new ListTile(
                        title: new Text(
                          CommonUtils.getLocale(context).home_check_update,
                          style: ZpjConstant.normalText,
                        ),
                        onTap: () {},
                      ),
                      new ListTile(
                        title: new Text(
                          ZpjLocalizations.of(context).currentLocalized.home_about,
                          style: ZpjConstant.normalText,
                        ),
                        onTap: () {},
                      ),
                      new ListTile(
                        title: new Text(
                          CommonUtils.getLocale(context).Login_out,
                          style: ZpjConstant.normalText,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
