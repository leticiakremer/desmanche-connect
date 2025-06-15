import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pds_front/app/models/login_request_model.dart';
import 'package:pds_front/app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  String? _loginError;

  final Color customColor = const Color(0xFF91E4E2);
  final Color focusBorderColor = Colors.white;
  final Color backgroundColor = const Color(0xFF121212);

  void _clearError() {
    if (_loginError != null) {
      setState(() {
        _loginError = null;
      });
    }
  }

    @override
  void initState() {
    super.initState();
    _usernameController.addListener(_clearError);
    _passwordController.addListener(_clearError);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_clearError);
    _passwordController.removeListener(_clearError);
    _usernameController.dispose(); 
    _passwordController.dispose();
    super.dispose();
  }


  Future _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      var loginResponse = await _userService.login(LoginRequestModel(
          username: _usernameController.text,
          password: _passwordController.text));
      final storage = await SharedPreferences.getInstance();
      if (loginResponse.data != null) {
        storage.setString(
            "AccountData", jsonEncode(loginResponse.data!.toJson()));

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      } else {
        //TODO: Mostrar na tela que n"ao foi poss
        setState(() {
          _loginError = "Usuário ou senha inválidos";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            color: const Color(0xFF1E1E1E),
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Login Administrativo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: customColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Usuário',
                        labelStyle: TextStyle(color: customColor),
                        prefixIcon: Icon(Icons.person, color: customColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: customColor.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: focusBorderColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Digite o nome de usuário';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: TextStyle(color: customColor),
                        prefixIcon: Icon(Icons.lock, color: customColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: customColor.withOpacity(0.8),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: customColor.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: focusBorderColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite a senha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    if (_loginError != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _loginError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: _handleLogin,
                        child: const Text('Entrar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
