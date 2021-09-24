import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:core';

final pageIndexProvider=StateProvider.autoDispose((ref)=>1);

final nowTimeProvider= Provider((ref){
  final now=DateTime.now();
  print(now);
  return now;
});

final clockTimeProvider=ChangeNotifierProvider((ref)=>NowTimeNotifier());

class NowTimeNotifier extends ChangeNotifier{
  var now=DateTime.now();
  NowTimeNotifier() : super();

  DateTime get nowTime=>now;
  
  void update(){
    now=DateTime.now();
    notifyListeners();
  }
}

final stopWathTimeProvider=ChangeNotifierProvider((ref)=>StopWatchNotifier());

final timerTimeProvider=ChangeNotifierProvider((ref)=>TimerNotifier());

class StopWatchNotifier extends ChangeNotifier{
  Duration timerValue=Duration();
  DateTime initialTime=DateTime.now();

  StopWatchNotifier():super();

  Duration get value=>timerValue;

  void start(){
    initialTime=DateTime.now();
  }

  void resume(){
    initialTime=DateTime.now().add(-timerValue);
  }

  void reset(){
    timerValue=Duration();
    notifyListeners();
  }

  void add(Duration frequency){
    timerValue+=frequency;
    notifyListeners();
  }

  void async(){
    timerValue=DateTime.now().difference(initialTime);
    notifyListeners();
  }

}

class TimerNotifier extends ChangeNotifier{
  Duration timerValue=Duration(minutes:1);
  DateTime targetTime=DateTime.now();

  TimerNotifier():super();

  Duration get value=>timerValue;

  void start(Duration inputTime){
    timerValue=inputTime;
    targetTime=DateTime.now().add(inputTime);
  }

  void resume(){
    targetTime=DateTime.now().add(timerValue);
  }

  void sub(Duration frequency){
    timerValue-=frequency;
    notifyListeners();
  }

  void async(){
    timerValue=targetTime.difference(DateTime.now());
    //notifyListeners();
  }
}


final stopWatchStateProvider=StateProvider((ref){
    return 0;
  }
);

final timerStateProvider=StateProvider((ref){
    return 0;
  }
);

final hourProvider=StateProvider((ref){
  return 0;
});

final minuteProvider=StateProvider((ref){
  return 0;
});

final secondProvider=StateProvider((ref){
  return 0;
});

final longPressTimerProvider=StateProvider((ref){
  return Timer.periodic(Duration(seconds:1),(timer)=>{});
});

final textFaceProvider=StateProvider.family((ref,provider){
  
});

