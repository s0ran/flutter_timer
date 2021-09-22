import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stopwatch/digitalclock.dart';
import 'package:stopwatch/providers.dart';
import 'button.dart';
import 'dart:async';

class StopWatchView extends ConsumerStatefulWidget {
  const StopWatchView({ Key? key }) : super(key: key);
  static const asyncfrequency=Duration(milliseconds:1000);
  static const addfrequency=Duration(milliseconds:9);
  static const List<String> startTexts=[
    "Start",
    "Stop",
    "Reset",
  ];
  static const List<String> stopTexts=[
    "",
    "",
    "Resume",
  ];

  @override
  _StopWatchViewState createState() => _StopWatchViewState();
}

class _StopWatchViewState extends ConsumerState<StopWatchView> with AutomaticKeepAliveClientMixin{  
  late Timer addtimer=Timer(Duration(seconds:1),()=>{});
  late Timer asynctimer=Timer(Duration(seconds:1),()=>{});  
  List get startCallBacks=>[
      onStart,
      onStop,
      onReset,
    ];
  List get stopCallBacks=>[
      null,
      null,
      onResume,
    ];

  @override
  bool get wantKeepAlive=>true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var duration=ref.watch(stopWathTimeProvider).value;
    var stateIndex=ref.watch(stopWatchStateProvider).state;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          SizedBox(
            height: 300,
            width: 300,
            child:Center(child:StopWatchClock(duration:duration)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: stateIndex<=1?
            [
              MyButton(StopWatchView.startTexts[stateIndex],startCallBacks[stateIndex]),
            ]:
            [  
              MyButton(StopWatchView.stopTexts[stateIndex],stopCallBacks[stateIndex]),
              MyButton(StopWatchView.startTexts[stateIndex],startCallBacks[stateIndex]),
            ],
          ),
        ]
      ), 
      
    );
  }
  void onStart(){
      ref.read(stopWatchStateProvider).state++;
      ref.read(stopWatchStateProvider).state%=3;
      var timenotifier=ref.read(stopWathTimeProvider.notifier);
      timenotifier.start();
      addtimer=Timer.periodic(StopWatchView.addfrequency,(timer)=>timenotifier.add(StopWatchView.addfrequency));
      asynctimer=Timer.periodic(StopWatchView.asyncfrequency,(timer)=>timenotifier.async());
  }
  void onStop(){
      addtimer.cancel();
      asynctimer.cancel();
      ref.read(stopWatchStateProvider).state++;
      ref.read(stopWatchStateProvider).state%=3; 
  }
  void onReset(){
      ref.read(stopWatchStateProvider).state++;
      ref.read(stopWatchStateProvider).state%=3; 
      ref.read(stopWathTimeProvider).reset();
  }
  void onResume(){
      ref.read(stopWatchStateProvider).state--;
      ref.read(stopWatchStateProvider).state%=3;
      var timenotifier=ref.read(stopWathTimeProvider.notifier);
      timenotifier.resume();
      addtimer=Timer.periodic(StopWatchView.addfrequency,(timer)=>timenotifier.add(StopWatchView.addfrequency));
      asynctimer=Timer.periodic(StopWatchView.asyncfrequency,(timer)=>timenotifier.async());
  }
}