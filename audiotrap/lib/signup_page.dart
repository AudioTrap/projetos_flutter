import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onSignupSuccess;

  const SignupPage({super.key, required this.onSignupSuccess});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;
  String? errorMessage;

  Future<void> signup() async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() => isLoading = false);
      return;
    }
    _formKey.currentState!.save();

    if (password != confirmPassword) {
      setState(() {
        errorMessage = "As senhas não coincidem.";
        isLoading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      widget.onSignupSuccess();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Erro ao criar usuário.";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erro inesperado.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator:
                    (value) =>
                        value != null && value.contains('@')
                            ? null
                            : 'Email inválido',
                onSaved: (value) => email = value ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator:
                    (value) =>
                        (value != null && value.length >= 6)
                            ? null
                            : 'Senha deve ter ao menos 6 caracteres',
                onSaved: (value) => password = value ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirmar senha'),
                validator:
                    (value) =>
                        (value != null && value.length >= 6)
                            ? null
                            : 'Confirme a senha',
                onSaved: (value) => confirmPassword = value ?? '',
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: signup,
                    child: const Text('Cadastrar'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
