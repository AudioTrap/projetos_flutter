import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState(); //oiii
}

class _MyAppState extends State<MyApp> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? newUser) {
      setState(() {
        user = newUser;
      });
    });
  }

  void onLoginSuccess() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AudioTrap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: user == null
          ? LoginPage(onLoginSuccess: onLoginSuccess)
          : HomePage(onSignOut: signOut),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onSignOut;
  const HomePage({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "Usuário";
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, $userEmail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onSignOut,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: const Center(child: Text('App autenticado!')),
    );
  }
}
