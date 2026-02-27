import 'package:flutter/material.dart';
import 'package:js_interop_part270_13/js_interop_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home:JSInteropExample() //JSInteropExample consists of Scaffold. A Scaffold must be wrapped with a MaterialApp (or WidgetsApp) because Scaffold needs: Directionality ,ThemeData ,Text direction (LTR/RTL) etc
    );
    
  }
}