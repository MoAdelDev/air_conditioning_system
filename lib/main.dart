import 'package:air_conditioning_system/features/auth/logic/cubit/auth_cubit.dart';
import 'package:air_conditioning_system/features/auth/ui/login_screen.dart';
import 'package:air_conditioning_system/features/home/ui/home_screen.dart';
import 'package:air_conditioning_system/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: FirebaseAuth.instance.currentUser?.uid != null
            ? const HomeScreen()
            : const LoginScreen(),
      ),
    );
  }
}
