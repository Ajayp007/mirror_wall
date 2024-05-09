import 'package:flutter/material.dart';
import 'package:mirror_wall/screens/home/provider/home_provider.dart';
import 'package:mirror_wall/screens/home/provider/web_provider.dart';
import 'package:mirror_wall/utils/app_routs.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: HomeProvider()),
        ChangeNotifierProvider.value(value: WebProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: appRouts,
      ),
    ),
  );
}
