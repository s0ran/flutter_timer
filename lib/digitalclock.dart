import 'package:flutter/material.dart';


class DigitalClock extends StatelessWidget {
  final DateTime dateTime;
  final bool showHour;
  final bool showMilliseconds;
  const DigitalClock(DateTime this.dateTime,{bool this.showHour=true,bool this.showMilliseconds=false,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String string="";
    string+=showHour?"${dateTime.hour.toString().padLeft(2,"0")} : ":"";
    string+="${dateTime.minute.toString().padLeft(2,"0")} : ${dateTime.second.toString().padLeft(2,"0")}";
    string+=showMilliseconds?" . ${dateTime.millisecond.toString().padLeft(2,"0").substring(0,2)}":"";
    return Text(string);
  }
}


class StopWatchClock extends StatelessWidget {
  final Duration duration;
  final bool needmillisecond;
  const StopWatchClock({required this.duration,this.needmillisecond:true,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget Hour=SizedBox(height:40,width:50,child:Text("${duration.inHours.toString().padLeft(2,"0")}"));
    Widget ColonDivider=SizedBox(height:40,width:30,child:Text(" : "));
    Widget Minute=SizedBox(height:40,width:50,child:Text("${duration.inMinutes.toString().padLeft(2,"0")}"));
    Widget Second=SizedBox(height:40,width:50,child:Text("${(duration.inSeconds%60).toString().padLeft(2,"0")}"));
    Widget CommaDivider=SizedBox(height:40,width:30,child:Text(" . "));
    //print(duration.inMilliseconds);
    Widget Millisecond=SizedBox(height:40,width:50,child:Text("${(duration.inMilliseconds%1000).toString().padLeft(3,"0").substring(0,2)}"));

    List<Widget> characters=[
        Hour,
        ColonDivider,
        Minute,
        ColonDivider,
        Second,
        //CommaDivider,
        //Millisecond,
      ];
    characters=needmillisecond?characters+[CommaDivider,Millisecond]:characters;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: characters,
    );
  }
}

