// import 'package:flutter/material.dart';
// import 'package:sajilo_style/app/app.dart';
// import 'package:sajilo_style/app/service_locator/service_locator.dart';
// import 'package:sajilo_style/core/common/intenet_checker/connectivity.dart';
// import 'package:sajilo_style/core/network/hive_service.dart';


// void main() async{
// WidgetsFlutterBinding.ensureInitialized();

//   await initDependencies();

//   await HiveService().init();
//   runApp(App(      child: AppWithBanner(),
// ));

        




//   // Add this widget to wrap MaterialApp with the banner using the builder property
// class AppWithBanner extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return App(
//       builder: (context, child) => GlobalConnectivityBanner(child: child!),
//     );
//   }

// }


import 'package:flutter/material.dart';
import 'package:sajilo_style/app/app.dart';
import 'package:sajilo_style/app/service_locator/service_locator.dart';
import 'package:sajilo_style/core/common/intenet_checker/connectivity.dart';
import 'package:sajilo_style/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();
  await HiveService().init();

  runApp(AppWithBanner());
}

// AppWithBanner wraps the main App widget with the connectivity banner
class AppWithBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return App(
      builder: (context, child) => GlobalConnectivityBanner(child: child!),
    );
  }
}




