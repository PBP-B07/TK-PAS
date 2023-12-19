import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/login/login.dart';
//import 'package:ulasbuku/homepage/screens/homepage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFCFFAFE),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 237,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Center(
                  // atau Align(alignment: Alignment.center, ...)
                  child: Container(
                    width: 188,
                    height: 165,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      image: const DecorationImage(
                        image: AssetImage("panda.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: 'Ulas',
                            style: TextStyle(color: Color(0xFF0919CD)),
                          ),
                          TextSpan(
                            text: 'Buku',
                            style: TextStyle(color: Color(0xFFC51605)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Let's Sign Up!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 1, 51, 168)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              labelText: 'Username',
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 1, 51, 168)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 1, 51, 168)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 18,
                          ),
                          Text(
                            "Fill your personal information!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),

                          // Input field for surname
                          const SizedBox(height: 12.0),
                          TextFormField(
                            style: const TextStyle(fontFamily: 'Poppins'),
                            controller: _surnameController,
                            decoration: const InputDecoration(
                              labelText: 'Surname',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 1, 51, 168)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your surname';
                              }
                              return null;
                            },
                          ),

                          // Input field for description
                          const SizedBox(height: 12.0),
                          TextFormField(
                            style: const TextStyle(fontFamily: 'Poppins'),
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 1, 51, 168)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),

                          // Switch for admin registration
                          const SizedBox(height: 12.0),
                          Row(
                            children: [
                              Text('Register as Admin'),
                              const Spacer(),
                              Switch(
                                value: _isAdmin,
                                onChanged: (value) {
                                  setState(() {
                                    _isAdmin = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 15.0),
                          const SizedBox(height: 15.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String username = _usernameController.text;
                                String password = _passwordController.text;
                                String confirmPassword =
                                    _confirmPasswordController.text;
                                String surname = _surnameController.text;
                                String description =
                                    _descriptionController.text;

                                if (password != confirmPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Passwords do not match"),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  if (password.length < 8) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Password must be at least 8 characters long"),
                                      ),
                                    );
                                    return;
                                  }
                                  if (!RegExp(
                                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])')
                                      .hasMatch(password)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Password must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number"),
                                      ),
                                    );
                                    return;
                                  }

                                  final response = await http.post(
                                    Uri.parse(
                                        'http://localhost:8000/auth/register/'),
                                    //Uri.parse('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/auth/register/'),
                                    body: {
                                      'username': username,
                                      'password': password,
                                      'surname': surname,
                                      'description': description,
                                      'admin': _isAdmin.toString()
                                    },
                                  );

                                  if (response.statusCode == 400) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Registration failed. Please try again."),
                                      ),
                                    );
                                    // Navigate to login page or other screen
                                  } else if (response.statusCode == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Registration successful!"),
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                    );
                                  } else if (response.statusCode == 500) {
                                    // Handle 500 Internal Server Error
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Server error. Please try again later."),
                                      ),
                                    );
                                  } else if (response.statusCode == 405) {
                                    // Handle 405 Method Not Allowed
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("Invalid request method."),
                                      ),
                                    );
                                  } else {
                                    // Handle other status codes
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "An error occurred. Please try again later."),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print("Error during registration: $e");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "An error occurred. Please try again later."),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5038BC),
                              minimumSize: const Size.fromHeight(50),
                              padding: const EdgeInsets.all(
                                  20.0), // Mengatur padding tombol
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    40.0), // Mengatur radius tombol
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
