// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sajilo_style/app/service_locator/service_locator.dart';
// import 'package:sajilo_style/app/theme/app_theme.dart';
// import 'package:sajilo_style/features/splash/presentation/view/splash_view.dart';
// import 'package:sajilo_style/features/splash/presentation/view_model/splash_view_model.dart';

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sajilo Style',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.getApplicationTheme(isDarkMode: false),
//       home: BlocProvider.value(
//         value: serviceLocator<SplashViewModel>(),
//         child: SplashView(),
//       ),
      
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/app/service_locator/service_locator.dart';
import 'package:sajilo_style/app/theme/app_theme.dart';
import 'package:sajilo_style/features/splash/presentation/view/splash_view.dart';
import 'package:sajilo_style/features/splash/presentation/view_model/splash_view_model.dart';

class App extends StatelessWidget {
  final TransitionBuilder? builder;

  const App({super.key, this.builder});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sajilo Style',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getApplicationTheme(isDarkMode: false),
      builder: builder, // ✅ Pass builder here
      home: BlocProvider.value(
        value: serviceLocator<SplashViewModel>(),
        child: SplashView(),
      ),
    );
  }
}

