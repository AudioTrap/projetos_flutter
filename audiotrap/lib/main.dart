import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // 👉  dados que o Firebase mostrou quando você registrou o app Web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBr8qosE2dzkdukmLyt1I16kv51Z9pB6g",
        authDomain: "audiotrap-23.firebaseapp.com",
        projectId: "audiotrap-23",
        storageBucket: "audiotrap-23.appspot.com",
        messagingSenderId: "49187410477",
        appId: "1:49187410477:web:9b8bc5bf98025e56775ea4",
        measurementId: "G-7JBEKHJSPT",          // opcional
      ),
    );
  } else {
    // 👉  Android usa o google-services.json
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

/* ────────────────────────────────────
   A partir daqui é o seu app normal
   ──────────────────────────────────── */

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((u) => setState(() => user = u));
  }

  void onLoginSuccess() => setState(() => user = FirebaseAuth.instance.currentUser);
  Future<void> signOut() async => FirebaseAuth.instance.signOut();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AudioTrap',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: user == null
          ? LoginPage(onLoginSuccess: onLoginSuccess)
          : HomePage(onSignOut: signOut),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onSignOut});
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? 'Usuário';
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, $email'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), tooltip: 'Sair', onPressed: onSignOut),
        ],
      ),
      body: const Center(child: Text('App autenticado!')),
    );
  }
}