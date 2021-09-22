import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';

import 'providers.dart';
import 'digitalclock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'button.dart';
import 'inputnumber.dart';


class TimerView extends ConsumerStatefulWidget {
  static const asyncfrequency=Duration(milliseconds:1000);
  static const subfrequency=Duration(milliseconds:20);
  static const List<String> startTexts=[
    "Start",
    "Cancel",
    "Cancel",
  ];
  static const List<String> stopTexts=[
    "Reset",
    "Stop",
    "Resume",
  ];
  const TimerView({ Key? key }) : super(key: key);

  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends ConsumerState<TimerView> with AutomaticKeepAliveClientMixin{
  late Timer subtimer=Timer(Duration(seconds:1),()=>{});
  late Timer asynctimer=Timer(Duration(seconds:1),()=>{});  
  
  List get startCallBacks=>[
      onStart,
      onCancel,
      onCancel,
    ];
  List get stopCallBacks=>[
      onReset,
      onStop,
      onResume,
    ];

  @override
  bool get wantKeepAlive=>true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var duration=ref.watch(timerTimeProvider).value;
    var stateIndex=ref.watch(timerStateProvider).state;
    if(duration<=Duration(milliseconds:0) && stateIndex==1){
      Timer(Duration(seconds:3),()=>ref.read(timerStateProvider).state=0);
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child:SizedBox(
          height:300,
          width:400,
          child:Center(child:Text("Finish!",style: TextStyle(fontSize: 40),),),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          SizedBox(
            height: 300,
            width: 400,
            child:Center(child:stateIndex==0?InputView():StopWatchClock(duration:duration+Duration(milliseconds:900),needmillisecond: false,)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: 
            [  
              MyButton(TimerView.stopTexts[stateIndex],stopCallBacks[stateIndex]),
              MyButton(TimerView.startTexts[stateIndex],startCallBacks[stateIndex]),
            ],
          ),
        ]
      ), 
      
    );
  }

  void onStart(){
      
      var inputTime=Duration(hours: ref.read(hourProvider).state,minutes:ref.read(minuteProvider).state,seconds:ref.read(secondProvider).state);
      var timeNotifier=ref.read(timerTimeProvider.notifier);
      timeNotifier.start(inputTime);
      subtimer=Timer.periodic(TimerView.subfrequency, (timer)=>timeNotifier.sub(TimerView.subfrequency));
      asynctimer=Timer.periodic(TimerView.asyncfrequency, (timer)=>timeNotifier.async());
      ref.read(timerStateProvider).state++;
      ref.read(timerStateProvider).state%=3;
      //ref.read(targetTimeProvider).state=ref.read(nowTimeProvider).add(inputTime);
      //ref.read(timeProvider2).state=inputTime;
      //subtimer=Timer.periodic(TimerView.subfrequency,(timer)=>ref.read(timeProvider2).state-=TimerView.subfrequency);
      //asynctimer=Timer.periodic(TimerView.asyncfrequency, (timer)=>ref.read(timeProvider2).state=ref.read(asyncTimeProvider2));
  }

  void onStop(){
    subtimer.cancel();
    asynctimer.cancel();
    ref.read(timerStateProvider).state++;
    ref.read(timerStateProvider).state%=3; 
  }

  void onCancel(){
    subtimer.cancel();
    asynctimer.cancel();
    ref.read(timerStateProvider).state=0;
  }

  void onReset(){
    ref.read(timerStateProvider).state=0; 
    ref.read(hourProvider).state=0;    
    ref.read(minuteProvider).state=0;  
    ref.read(secondProvider).state=0;  
  }
  void onResume(){
    ref.read(timerStateProvider).state--;
    ref.read(timerStateProvider).state%=3;
    var timeNotifier=ref.read(timerTimeProvider.notifier);
    timeNotifier.resume();
    subtimer=Timer.periodic(TimerView.subfrequency, (timer)=>timeNotifier.sub(TimerView.subfrequency));
    asynctimer=Timer.periodic(TimerView.asyncfrequency, (timer)=>timeNotifier.async());

    //ref.read(targetTimeProvider).state=ref.read(nowTimeProvider).add(ref.read(timeProvider2).state);
    //subtimer=Timer.periodic(TimerView.subfrequency,(timer)=>ref.read(timeProvider2).state-=TimerView.subfrequency);
    //asynctimer=Timer.periodic(TimerView.asyncfrequency, (timer)=>ref.read(timeProvider2).state=ref.read(asyncTimeProvider2));
  }
}

