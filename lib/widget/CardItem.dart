import 'package:flutter/material.dart';
import 'package:zpj_github_app/common/style/ZPJStyle.dart';
class CardItem extends  StatelessWidget{
  final Widget child;
  final EdgeInsets margin;
  final Color color;
  final RoundedRectangleBorder shape;
  final double elevation;
  CardItem({this.color,this.child,this.elevation,this.margin,this.shape});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    EdgeInsets magin=this.margin;
    RoundedRectangleBorder shape=this.shape;
    Color color=this.color;
    magin ??= EdgeInsets.only(left: 10.0,right: 10.0,top: 8.0,bottom: 8.0);
    shape??=new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)));
    color ??=new Color(ZPJColors.cardWhite);
    return new Card(
      elevation: elevation,
      shape: shape,
      child: child,
      color: color,
      margin: magin,
    );
  }

}
