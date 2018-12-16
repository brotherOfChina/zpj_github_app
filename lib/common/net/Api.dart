import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:zpj_github_app/common/config/Config.dart';
import 'package:zpj_github_app/common/net/ResultData.dart';
import 'package:zpj_github_app/common/net/Code.dart';
import 'package:zpj_github_app/common/local/LocalStorage.dart';
/**
 *   created by zpj
 *   updateTime:
 *   createdTime: 2018/12/16 13:54

 */

///http请求
class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static Map optionParams = {
    "timeOutMs": 15000,
    "token": null,
    "authorizationCode": null
  };

  static netFetch(url, params, Map<String, String> header, Options option,
      {noTip = false}) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return new ResultData(
          Code.errorHandleFunction(Code.NET_WORK_ERROR, "", noTip),
          false,
          Code.NET_WORK_ERROR);
    }
    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }
    if (optionParams["authorizationCode"] == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        optionParams["authorization"] = authorizationCode;
      }
    }
    headers["Authorization"] = optionParams["authorizationCode"];
    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = headers;
    }

    ///超时
    option.connectTimeout = 15000;
    Dio dio = new Dio();
    Response response;
    try {
      response = await dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 509);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = Code.NET_TIME_OUT;
      }
      if (Config.DEBUG) {
        print("请求异常" + e.toString());
        print("请求异常url" + url);
      }
      return new ResultData(
          Code.errorHandleFunction(errorResponse.statusCode, e.message, noTip),
          false,
          errorResponse.statusCode);
    }
    if (Config.DEBUG) {
      print("请求头:" + option.headers.toString());
      print("请求url:" + url);

      if (params != null) {
        print("请求参数" + params.toString());
      }
      if (response != null) {
        params("返回参数：" + response.toString());
      }
      if (optionParams["authorizationCode"] != null) {
        print('authorizationCode: ' + optionParams["authorizationCode"]);
      }
    }
    try {
      if (option.contentType != null &&
          option.contentType.primaryType == "text") {
        return new ResultData(response.data, true, Code.SUCCESS);
      } else {
        var responseJson = response.data;
        if (response.statusCode == 201 && responseJson["token"] != null) {
          optionParams["authorizationCode"] = "token" + responseJson["token"];
          await LocalStorage.save(
              Config.TOKEN_KEY, optionParams["authorizationCode"]);
        }
      }
      if(response.statusCode==200||response.statusCode==201){
        return new ResultData(response.data, true, Code.SUCCESS,headers: response.headers);
      }
    } catch (e) {
      print(url + "\n" + e.toString());
      return new ResultData(
          Code.errorHandleFunction(response.statusCode, "", noTip),
          false,
          response.statusCode);
    }
    return new ResultData(Code.errorHandleFunction(response.statusCode, "", noTip), false, response.statusCode);
  }
  ///清除授权码
  static clearAuthorization()async{
    optionParams["authorizationCode"]=null;
    LocalStorage.remove(Config.TOKEN_KEY);

  }
  ///获取授权码
  static getAuthorization() async {
    String token = await LocalStorage.get(Config.TOKEN_KEY);

    if (token == null) {
      String basic = await LocalStorage.get(Config.USER_BASIC_CODE);

      if (basic == null) {
        //提示输入账号密码
      } else {
        //通过 basic 去获取token，获取到设置，返回token
        return "Basic $basic";
      }
    } else {
      optionParams["authorizationCode"] = token;
      return token;
    }
  }
}
