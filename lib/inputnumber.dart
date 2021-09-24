import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';



class InputView extends ConsumerWidget {
  static const Widget ColonDivider=SizedBox(height:40,width:30,child:Text(" : "));
  const InputView({ Key? key }) : super(key: key);
  

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    //print("rebuild");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberBox(provider:hourProvider),
        ColonDivider,
        NumberBox(provider:minuteProvider,maxValue:60),
        ColonDivider,
        NumberBox(provider:secondProvider,maxValue:60),
      ],
           
    );
  }
}


class NumberBox extends ConsumerStatefulWidget {
  final provider;
  final minValue;
  final maxValue;
  var timer;

  NumberBox({this.minValue:0, this.maxValue:1000,required this.provider, Key? key }) : super(key: key);
  

  @override
  _NumberBoxState createState() => _NumberBoxState();
}

class _NumberBoxState extends ConsumerState<NumberBox> {
  late var myController;

  @override
  void initState(){
    super.initState();
    myController=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    myController.text=ref.watch(widget.provider).state.toString().padLeft(2,"0");
    myController.selection=TextSelection.fromPosition(TextPosition(offset: myController.text.length));
    return Row(
      children:[
        SizedBox(
            height: 60,
            width: myController.text.length*20.0,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              style: TextStyle(fontSize: 30),
              controller: myController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (String? value){
                if (value==null||value.isEmpty){
                  return null;
                }else if (int.parse(value)<widget.minValue) {
                  return "${widget.minValue}以上の数値を入力してください。";
                }else {
                  if(int.parse(value)>widget.maxValue){
                  return  "${widget.maxValue}未満の数値を入力してください。";
                  }
                }
              },
              onFieldSubmitted: (text){
                if (text.isEmpty){
                  if (ref.read(widget.provider).state==widget.minValue){
                    ref.read(widget.provider).state=widget.minValue-1;
                    ref.read(widget.provider).state=widget.minValue;
                  }else{
                    ref.read(widget.provider).state=widget.minValue;
                  }
                  //print(ref.read(widget.provider).state);
                }else if (int.parse(text)>widget.maxValue){
                  ref.read(widget.provider).state=widget.maxValue-1;
                }else if (int.parse(text)<widget.minValue){
                  ref.read(widget.provider).state=widget.minValue;
                }
              },
              onChanged: (text){          
                text=="" || int.parse(text)<widget.minValue?
                ref.read(widget.provider).state=widget.minValue:
                ref.read(widget.provider).state=int.parse(text);
              }
            ),
      ),
      Counter(widget.provider),
      ]
    );        
  }

  Widget Counter(provider){
    return SizedBox(height: 60,width:30,child:Column(children: [
      SizedBox(
        height:30,
        width:30,
        child: GestureDetector(
          //iconSize:20,
          onTap: (){
            ref.read(provider).state++;
            ref.read(provider).state%=widget.maxValue;
            myController.text=ref.read(provider).state.toString().padLeft(2,"0");
          }, 
          onLongPress: (){
            ref.read(longPressTimerProvider).state=Timer.periodic(Duration(milliseconds:300), (timer) {
              if (ref.read(provider).state+10<widget.maxValue){
                ref.read(provider).state+=10;
                myController.text=ref.read(provider).state.toString().padLeft(2,"0");
              }else{
                ref.read(provider).state=widget.maxValue-1;
                myController.text=ref.read(provider).state.toString().padLeft(2,"0");
                ref.read(longPressTimerProvider).state.cancel();
              }
            });
          },
          onLongPressUp: (){
            ref.read(longPressTimerProvider).state.cancel();
          },
          child: Icon(Icons.add,size:20),  
        ),
        ),
      SizedBox(
        height:30,
        width:30,
        child: GestureDetector(
          //iconSize:20,
          onTap: (){
            ref.read(provider).state--;
            ref.read(provider).state%=widget.maxValue;
            myController.text=ref.read(provider).state.toString().padLeft(2,"0");
          }, 
          onLongPress: (){
            ref.read(longPressTimerProvider).state=Timer.periodic(Duration(milliseconds:300), (timer) { 
              if (ref.read(provider).state-10>=widget.minValue){
                ref.read(provider).state-=10;
                myController.text=ref.read(provider).state.toString().padLeft(2,"0");
              }else{
                ref.read(provider).state=0;
                myController.text=ref.read(provider).state.toString().padLeft(2,"0");
                ref.read(longPressTimerProvider).state.cancel();
              }
            });
          },
          onLongPressUp: (){
            ref.read(longPressTimerProvider).state.cancel();
          },
          child: Icon(Icons.horizontal_rule,size:20)
          )
        ),
      ],));
    }
}