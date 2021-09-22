import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class MyButton extends ConsumerWidget {
  final String text;
  final VoidCallback onTap;
  const MyButton(this.text,this.onTap,{ Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return SizedBox(
      height: 100,
      width: 100,
      child:ElevatedButton(
        onPressed: onTap, 
        child: Text(text,style: TextStyle(color: Colors.white,fontSize: 20),),
        style: ElevatedButton.styleFrom(
          primary: Colors.grey,
          onPrimary: Colors.black,
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.black,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }

  

}