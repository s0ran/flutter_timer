import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stopwatch/providers.dart';
import 'package:stopwatch/watch.dart';
import 'dart:async';
import 'stopwatch.dart';
import 'timer.dart';

void main() {
  runApp(ProviderScope(child:MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor:Colors.grey,
        scaffoldBackgroundColor: Colors.black12,
        colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue
      ).copyWith(
        secondary: Colors.lightBlue,    
      ),
      textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black,fontSize: 32)),
    ),
      home: MyHomePage(),
    );
  }
}

/*class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage({ Key? key }) : super(key: key);
  static const stopWatchView = StopWatchView();
  

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {*/
class MyHomePage extends ConsumerWidget{
  static const List<String> pageTitles=["時計","ストップウォッチ","タイマー"];
  //static const Widget StopWatch=StopWatchView();
  //final String pageTitle=pageTitles[0];
  //late PageController pageController=PageController(initialPage: ref.read(pageIndexProvider).state,);
  late PageController pageController;
  late Timer timer;
  late Timer addtimer=Timer(Duration(seconds:1),()=>{});
  late Timer addtimer2=Timer(Duration(seconds:1),()=>{});
  late Timer asynctimer=Timer(Duration(seconds:1),()=>{});
  late Timer asynctimer2=Timer(Duration(seconds:1),()=>{});
  Widget stopWatchView = StopWatchView();
  Widget watchView= WatchView();
  Widget timerView=TimerView();

  MyHomePage({Key? key}):super(key: key);

  /*void timerStart2(subfrequency,asyncfrequency){
    addtimer2=Timer.periodic(subfrequency,(timer) { ref.read(timeProvider2).state-=subfrequency;});
    asynctimer2=Timer.periodic(asyncfrequency, (timer) { ref.read(timeProvider2).state=ref.read(targetTimeProvider).state.difference(ref.read(nowTimeProvider).state);});  
  }

  void timerCancel2(){
    addtimer2.cancel();
    asynctimer2.cancel();
  }*/

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    //print("MyHomePage State rebuild");
    pageController=PageController(initialPage: 1);
    final pageIndex=ref.watch(pageIndexProvider).state;
    final onTapBottomBar=_onTapBottomBar(ref);
    return Scaffold(
      appBar: AppBar(title: Text(pageTitles[pageIndex],)),
      body: PageView(
        controller: pageController,
        onPageChanged: (int index)=>_onPageChanged(ref,index),
        children: [
          //WatchView(ref.watch(nowTimeProvider).state),
          watchView,
          stopWatchView,
          timerView,
          //StopWatchView(ref.watch(timeProvider).state,ref.watch(stopWatchStateProvider).state,timerStart,timerCancel),
          //TimerView(ref.watch(timeProvider2).state,ref.watch(timerStateProvider).state,timerStart2,timerCancel2),
        ],
        
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.watch_outlined),label:pageTitles[0]),
            BottomNavigationBarItem(icon: Icon(Icons.watch_later_rounded),label:pageTitles[1]),
            BottomNavigationBarItem(icon: Icon(Icons.timer),label:pageTitles[2]),
          ],
          onTap: (int index)=>onTapBottomBar(index),
          //(int index)=>_onTapBottomBar(index),
          currentIndex: pageIndex,
        )
    );
  }
/*
  @override
  void dispose(){
    super.dispose();
    timer.cancel();
  }*/

  void _onPageChanged(WidgetRef ref,int index){
    ref.read(pageIndexProvider).state=index;
  }

  void Function(int) _onTapBottomBar(ref){
    return (int index){
      pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      _onPageChanged(ref,index);
    };  
  }
/*
  void _onTapBottomBar(int index){
    pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    _onPageChanged(index);
  }*/
}
