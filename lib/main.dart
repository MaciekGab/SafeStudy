import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/wrappers/AuthWrapper.dart';
import 'package:test_auth_with_rolebased_ui/services/AuthService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
          context
              .read<AuthService>()
              .authStateChanges,
        ),

        //Samo to działa więcj jak to z góry nie będzie chciało to zostaje to
        // update: wydaje się że tamto działa, poczekamy zobaczymy
        // StreamProvider<User>.value(
        //     value: FirebaseAuth.instance.authStateChanges())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}




