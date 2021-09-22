import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'clock.dart';
import 'dart:async';
import 'digitalclock.dart';



class WatchView extends ConsumerStatefulWidget {
  const WatchView({ Key? key }) : super(key: key);

  @override
  _WatchViewState createState() => _WatchViewState();
}

class _WatchViewState extends ConsumerState<WatchView> with AutomaticKeepAliveClientMixin{
  late Timer timer;
  var now;
  //const WatchView({ Key? key } ) : super(key: key);
  @override
  bool get wantKeepAlive=>true;


  @override
  void initState(){
    super.initState();
    timer=Timer.periodic(Duration(seconds:1), (timer) {ref.read(clockTimeProvider).update();});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //print("rebuild");
    var now=ref.watch(clockTimeProvider).nowTime;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.topCenter,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          SizedBox(
            height: 300,
            width: 300,
            child: CustomPaint(painter: ClockPainter(now),)
            ),
          Text("${now.year}年 ${now.month}月 ${now.day}日"),
          DigitalClock(now),
          ]
      )
    );
  }
  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }
}