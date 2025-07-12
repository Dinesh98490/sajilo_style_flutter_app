import 'package:flutter/material.dart';
import 'package:sajilo_style/app/app.dart';
import 'package:sajilo_style/app/service_locator/service_locator.dart';
import 'package:sajilo_style/core/network/hive_service.dart';


void main() async{
WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  await HiveService().init();
  runApp(App());
}
