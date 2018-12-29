import 'dart:convert';
import 'dart:io';
import 'package:zpj_github_app/common/dao/DaoResult.dart';
import 'package:zpj_github_app/common/db/repos/repository_issue.dart';
import 'package:zpj_github_app/common/model/Issue.dart';
import 'package:zpj_github_app/common/net/Address.dart';
import 'package:zpj_github_app/common/net/Api.dart';

/**
 *   author：Administrator
 *   create_date:2018/12/29 0029-8:49
 *   note:issue相关
 */
class IssueDao {
  ///获取仓库 issue
  static getRepositoryIssueDao(userName, repository, state,
      {sort, direction, page = 0, needDb = false}) async {
    String fullName = userName + "/" + repository;
    String dbState = state ?? "*";
    RepositoryIssueDbProvider provider = new RepositoryIssueDbProvider();
    next() async {
      String url =
          Address.getReposIssue(userName, repository, state, sort, direction) +
              Address.getPageParams("&", page);
      var res = await HttpManager.netFetch(
          url,
          null,
          {
            "Accept":
                'application/vnd.github.html,application/vnd.github.VERSION.raw'
          },
          null);
      if (res != null && res.result) {
        List<Issue> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DaoResult(list, true);
        } else {
          return new DaoResult(null, false);
        }
      }
      if (needDb) {
        List<Issue> list = await provider.getData(fullName, dbState);
        if (list == null) {
          return await next();
        }
        DaoResult daoResult = new DaoResult(list, true, next: next());
        return daoResult;
      }
      return await next();
    }
  }

  ///搜索仓库issue
  static searchRepositoryIssue(q, name, reposName, state, [page = 1]) async {
    String qu;
    if (state == null || state == "all") {
      qu = q + "repo%3A$name%2F$reposName";
    } else {
      qu = q + "repo%3A$name%2F$reposName+state%3A$state";
    }
    String url =
        Address.repositoryIssueSearch(qu) + Address.getPageParams("&", page);
    var res = await HttpManager.netFetch(url, null, null, null);
    if(res!=null && res.result){
      List<Issue> list=new List();
      var data=res.data["items"];
      if(data==null || data.length==0){
        return new DaoResult(null, false);
      }
      for(int i=0;i<data.length;i++){
        list.add(Issue.fromJson(data[i]));
      }
      return new DaoResult(list, true);
    }else{
      return new DaoResult(null, false);
    }
  }
  ///issue的详情
  static getIssueInfoDao(userName,repository,number,{needDb=true})async{
    String fullName=userName+"/" +repository;

  }
}
