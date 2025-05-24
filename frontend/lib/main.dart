import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pds_front/app/pages/home/home_page.dart';
import 'package:pds_front/ui/home/home.dart';
import 'package:pds_front/ui/splash/splash_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}