import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/homepage/screens/homepage.dart';
import 'package:ulasbuku/login/register.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String uname = "";

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                        image: AssetImage("assets/panda.png"),
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
                    "Let's Login!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Container(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(children: [
                    TextField(
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255)),
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
                        // floatingLabelAlignment: FloatingLabelAlignment.center
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 1, 51, 168)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        labelText: 'Password',
                        fillColor: Colors.white,
                        filled: true,
                        // floatingLabelAlignment: FloatingLabelAlignment.center
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        String username = _usernameController.text;
                        String password = _passwordController.text;

                        // Cek kredensial

                        // Untuk menyambungkan Android emulator dengan Django pada localhost,
                        // gunakan URL http://10.0.2.2/
                        final response = await request.login(
                            "https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/auth/login/",
                            {
                              'username': username,
                              'password': password,
                            });

                        // final response = await request.login("https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/auth/login/", {
                        //   'username': username,
                        //   'password': password,
                        // });

                        if (request.loggedIn) {
                          String message = response['message'];
                          String uname = response['username'];
                          LoginPage.uname = uname;
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                content:
                                    Text("$message Selamat datang, $uname.")));
                        } else {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Login Gagal'),
                              content: Text(response['message']),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
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
                        'Login',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700),

                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
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
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ])),
              // const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}
