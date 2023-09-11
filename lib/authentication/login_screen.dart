import 'package:flutter/material.dart';
import 'package:money_tracker/authentication/register_form.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

final TextEditingController _email = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void authUser() async {
    bool success =
        await UserService().login(_email.text, _password.text, context);
    if (success) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    } else {}
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
                      image: AssetImage('assets/login.png'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1, vertical: 20),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        alignment: Alignment.center,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextInput(
                              controller: _email,
                              hint: "Email",
                            ),
                            const SizedBox(height: 10),
                            TextInput(
                              controller: _password,
                              hint: "Hasło",
                              hideText: true,
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () => authUser(),
                                child: const Text("Zaloguj się",
                                    style: TextStyle(color: Colors.white))),
                            const SizedBox(height: 8),
                            TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterDialog(),
                                      ),
                                    ),
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
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
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

class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool hideText;

  const TextInput({
    super.key,
    required this.controller,
    required this.hint,
    this.hideText = false,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            textAlign: TextAlign.start,
            cursorColor: Theme.of(context).colorScheme.secondary,
            controller: widget.controller,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.secondary)),
                focusColor: Theme.of(context).colorScheme.secondary,
                border: const OutlineInputBorder(),
                hintText: widget.hint),
            textAlignVertical: TextAlignVertical.center,
            obscureText: widget.hideText ? _obscured : false,
          ),
          if (widget.hideText)
            IconButton(
              icon: Icon(
                _obscured ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: _toggleObscured,
            ),
        ],
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
                    onPressed: () async {
                      final uri = Uri.parse("https://www.zyrekferrara.com/");
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
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

class ChangePasswordDialog extends StatelessWidget {
  const ChangePasswordDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Podaj swój adres email",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(
              width: 220,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                controller: _email,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.white70)),
                    focusColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70)),
                    hintText: "E-mail",
                    hintStyle: TextStyle(color: Colors.white70)),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await UserService().sendResetPwdEmail(context, _email.text);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Wyślij",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                )),
          ],
        ));
  }
}
