import 'package:flutter/material.dart';
import 'package:money_tracker/authentication/register_form.dart';
import 'package:money_tracker/global.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void authUser() {
    // if (_login.text == "dev" && _password.text == "1234") {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MyHomePage(),
      ),
    );
    // } else {}
  }

  void register() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Builder(
          builder: (context) {
            return const RegisterDialog();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: gradientColors)),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2))),
              child: const Image(
                image: AssetImage('assets/office-gif.gif'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration:
                        withShadow(Theme.of(context).colorScheme.secondary, 80),
                    width: size.width * 0.8,
                    height: 82,
                    child: const Image(
                      image: AssetImage('assets/long_logo_gold.png'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1, vertical: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      alignment: Alignment.center,
                      // height: 300,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white70),
                      // decoration: withShadow(
                      //     const Color.fromARGB(220, 255, 255, 255), 80),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TextField(
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                              controller: _login,
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                  focusColor:
                                      Theme.of(context).colorScheme.secondary,
                                  border: const OutlineInputBorder(),
                                  hintText: "Login"),
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 50,
                            child: TextField(
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                              controller: _password,
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                  focusColor:
                                      Theme.of(context).colorScheme.secondary,
                                  border: const OutlineInputBorder(),
                                  hintText: "Hasło"),
                              textAlignVertical: TextAlignVertical.center,
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondary, // Background color
                              ),
                              onPressed: () => authUser(),
                              child: const Text("Zaloguj się",
                                  style: TextStyle(color: Colors.white))),
                          const SizedBox(height: 8),
                          TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {},
                              child: Text("Nie pamiętam hasła",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary))),
                          const SizedBox(height: 8),
                          TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () => register(),
                              child: Text("Nie mam jeszcze konta",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary))),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Aplikacja dla klientów Żyrek-Ferrara Consulting",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterDialog extends StatelessWidget {
  const RegisterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                width: 230,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const RegisterForm(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Jestem już klientem Żyrek-Ferrara Consulting",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ))),
            SizedBox(
                width: 230,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Chciałbym zobaczyć ofertę",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ))),
          ],
        ));
  }
}
