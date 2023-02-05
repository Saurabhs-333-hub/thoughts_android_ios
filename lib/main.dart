import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/firebase_options.dart';
import 'package:thoughts/providers/userProvider.dart';
import 'package:thoughts/responsive/mobileScreen.dart';
import 'package:thoughts/responsive/responsive_layout_screen.dart';
import 'package:thoughts/responsive/webScreen.dart';
import 'package:thoughts/screens/loginScreen.dart';
import 'package:thoughts/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(create: (_) {
            return UserProvider();
          })
        ],
        builder: (context, child) {
          // No longer throws
          return MaterialApp(
              title: 'Thoughts',
              theme: ThemeData.dark(useMaterial3: true),
              // home: ResponsiveLayout(
              //     mobileScreenLayout: MobileScreenLayout(),
              //     webScreenLayout: WebScreenLayout()),
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return ResponsiveLayout(
                          webScreenLayout: WebScreenLayout(),
                          mobileScreenLayout: MobileScreenLayout());
                    } else {
                      if (snapshot.hasError) {
                        return Center(child: Text("${snapshot.error}"));
                      } else {
                        // return showSnackBar(context, "success");
                      }
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {}
                  return LoginScreen();
                },
              ));
        });
  }
}
