import 'package:flutter/material.dart';
import 'package:zpj_githup_app/widget/InputIconWidget.dart';
import 'package:zpj_githup_app/common/utils/CommonUtils.dart';
import 'package:zpj_githup_app/common/style/ZPJStyle.dart';
import 'package:zpj_githup_app/widget/CardItem.dart';

class IssueEditDialog extends StatefulWidget {
  final String dialogTitle;

  final ValueChanged<String> onTitleChanged;

  final ValueChanged<String> onContentChanged;

  final VoidCallback onPressed;

  final TextEditingController titleController;

  final TextEditingController valueController;

  final bool needTitle;

  IssueEditDialog(this.dialogTitle, this.onTitleChanged, this.onContentChanged,
      this.onPressed,
      {this.titleController, this.valueController, this.needTitle = true});

  @override
  State<StatefulWidget> createState() {
    return _IssueEditDialogState();
  }
}

class _IssueEditDialogState extends State<IssueEditDialog> {
  ///标题输入框
  renderTitleInput() {
    return (widget.needTitle)
        ? new Padding(
            padding: new EdgeInsets.all(5.0),
            child: InputIconWidget(
              onChanged: widget.onTitleChanged,
              controller: widget.titleController,
              hintText:
                  CommonUtils.getLocale(context).issue_edit_issue_title_tip,
              obscureText: false,
            ),
          )
        : new Container();
  }

  ///快速输入框
  _renderFastInputContainer() {
    ///因为是Column下包含了listview ,所以需要设置告诉
    return new Container(
      height: 30.0,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return new RawMaterialButton(
            onPressed: () {
              String text = FAST_INPUT_LIST[index].content;
              String newText = "";
              if (widget.valueController.value != null) {
                newText = widget.valueController.value.text;
              }
              newText = newText + text;
              setState(() {
                widget.valueController.value =
                    new TextEditingValue(text: newText);
              });
              widget.onContentChanged?.call(newText);
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
            constraints: const BoxConstraints(minHeight: 0.0, minWidth: 0.0),
            child: Icon(
              FAST_INPUT_LIST[index].iconData,
              size: 16.0,
            ),
          );
        },
        itemCount: FAST_INPUT_LIST.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black12,
      child: new GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new Center(
          child: new Center(
            child: new Card(
              margin: EdgeInsets.all(10.0),
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: new Padding(
                padding: const EdgeInsets.all(12.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                      child: new Center(
                        child: new Text(
                          widget.dialogTitle,
                          style: ZpjConstant.normalTextBold,
                        ),
                      ),
                    ),
                    renderTitleInput(),
                    new Container(
                      height: MediaQuery.of(context).size.width * 3 / 4,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                        color: Color(ZPJColors.white),
                        border: new Border.all(
                            color: Color(ZPJColors.subTextColor), width: .3),
                      ),
                      padding: new EdgeInsets.only(
                          left: 20.0, top: 12.0, right: 20.0, bottom: 12.0),
                      child: new Column(
                        children: <Widget>[
                          new Expanded(
                            child: new TextField(
                              autofocus: false,
                              maxLines: 999,
                              onChanged: widget.onContentChanged,
                              controller: widget.valueController,
                              decoration: new InputDecoration.collapsed(
                                  hintText: CommonUtils.getLocale(context)
                                      .issue_edit_issue_title_tip,
                                  hintStyle: ZpjConstant.middleSubText),
                              style: ZpjConstant.middleText,
                            ),
                          ),
                          _renderFastInputContainer(),
                        ],
                      ),
                    ),
                    new Container(height: 10.0,),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child:new RawMaterialButton(onPressed: (){
                          Navigator.of(context).pop();
                        },materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.all(4.0),
                            constraints: const BoxConstraints(maxWidth: 0.0,minHeight: 0.0),
                            child: new Text(CommonUtils.getLocale(context).app_cancel,style: ZpjConstant.normalSubText,),
                        ),

                        ),
                        new Container(width: 0.3,height:25.0,color: Color(ZPJColors.subTextColor),
                        ),
                        new Expanded(child: new RawMaterialButton(onPressed: widget.onPressed,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.all(4.0),
                        constraints: const BoxConstraints(minWidth: 0.0,minHeight: 0.0),
                        child: Text(CommonUtils.getLocale(context).app_ok,style: ZpjConstant.normalTextBold,),)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var FAST_INPUT_LIST = [
  FastInputIconModel(ZpjICons.ISSUE_EDIT_H1, "\n# "),
  FastInputIconModel(ZpjICons.ISSUE_EDIT_H2, "\n## "),
  FastInputIconModel(ZpjICons.ISSUE_EDIT_H3, "\n### "),
  FastInputIconModel(ZpjICons.ISSUE_EDIT_BOLD, "****"),
  FastInputIconModel(ZpjICons.ISSUE_EDIT_ITALIC, "__"),
  FastInputIconModel(ZpjICons.ISSUE_EDIT_QUOTE, "` `"),
  FastInputIconModel(ZpjICons.ISSUE_EDIT_CODE, " \n``` \n\n``` \n"),
  FastInputIconModel(ZpjICons.ISSUE_EDIT_LINK, "[](url)"),
];

class FastInputIconModel {
  final IconData iconData;
  final String content;

  FastInputIconModel(this.iconData, this.content);
}
