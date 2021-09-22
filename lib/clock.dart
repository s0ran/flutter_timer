

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:io';


class ClockPainter extends CustomPainter {
  final DateTime nowTime ;
  late bool isday=5<=nowTime.hour && nowTime.hour<=18;
  ClockPainter(this.nowTime) : super();
  @override
  void paint(Canvas canvas, Size size) {
    final center=Offset(size.width/2,size.height/2);
    final double radius=100;
    final wholePaint=Paint()
    ..color=Colors.white;

    final outlinePaint=Paint()
    ..color=Colors.black54
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

    final centerPaint=Paint()
    ..color=Colors.blue
    ..strokeWidth=1;

    final secHandPaint=Paint()
    ..strokeCap=StrokeCap.round
    ..style=PaintingStyle.stroke
    ..strokeWidth=3;
    final minHandPaint=Paint()
    ..strokeCap=StrokeCap.round
    ..style=PaintingStyle.stroke
    ..strokeWidth=5;
    final hourHandPaint=Paint()
    ..strokeCap=StrokeCap.round
    ..style=PaintingStyle.stroke
    ..strokeWidth=10;

    final seclength=95;
    final minlength=90;
    final hourlength=40;

    final second=nowTime.second;
    final minute=nowTime.minute+second/60;
    final hour=nowTime.hour+minute/60;

    final lag=pi/2; 

    final secpos=center+Offset(seclength*cos(2*pi*second/60-lag),seclength*sin(2*pi*second/60-lag));
    final minpos=center+Offset(minlength*cos(2*pi*minute/60-lag),minlength*sin(2*pi*minute/60-lag));
    final hourpos=center+Offset(hourlength*cos(2*pi*hour/12-lag),hourlength*sin(2*pi*hour/12-lag));


  
    canvas.drawCircle(center,radius,wholePaint);
    canvas.drawCircle(center,radius,outlinePaint);
    
    
    final lag2=lag;
    for (double i=0;i<60;i++){
      var size=i%5==0?7:3;
      final tickpos= center+Offset(radius*cos(2*pi*i/60-lag2),radius*sin(2*pi*i/60-lag2));
      final tickpos2= center+Offset((radius-size)*cos(2*pi*i/60-lag2),(radius-size)*sin(2*pi*i/60-lag2));
      canvas.drawLine(tickpos,tickpos2,Paint());
    }
    for (double i=1; i<13;i++){
      final tp=TextPainter(text:TextSpan(style:TextStyle(color:Colors.black,fontSize: 15), text: i.toStringAsFixed(0)),textAlign:TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout(minWidth: -30,maxWidth: 30);
      final charpos= center+Offset((radius-15)*cos(2*pi*i/12-lag2)-tp.width/2,(radius-15)*sin(2*pi*i/12-lag2)-tp.height/2);
      
      tp.paint(canvas,charpos);
      //canvas.drawPoints(PointMode.points, [charpos], centerPaint);

    }

    final icon = isday?Icons.brightness_5:Icons.brightness_2;
    //print(icon);
    TextPainter tp = TextPainter(textDirection: TextDirection.rtl);
    
    tp.text = TextSpan(text: String.fromCharCode(icon.codePoint),
        style: TextStyle(fontSize: 25.0,color: Colors.blue,fontFamily: icon.fontFamily));
    tp.layout();
    tp.paint(canvas,center+Offset(-tp.width/2,-tp.height-40)); 


    canvas.drawLine(center,secpos,secHandPaint);
    canvas.drawLine(center,minpos,minHandPaint);    
    canvas.drawLine(center,hourpos,hourHandPaint);
    canvas.drawCircle(center,3,centerPaint);
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(ClockPainter oldDelegate) => false;
}