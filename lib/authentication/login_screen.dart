import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_tracker/authentication/register_form.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/input_dialog.dart';
import 'package:money_tracker/widgets/message.dart';
import '../main.dart';

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
  final TextEditingController _remindEmail = TextEditingController();

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
    } else {
      showInfo('Podano nieprawidłowe dane.', Colors.red, 300);
    }
  }

  void changePassword() {
    _remindEmail.clear();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Builder(
          builder: (context) {
            return InputDialog(
              controller: [_remindEmail],
              title: 'Podaj swój adres email',
              hint: const ['E-mail'],
              onPressed: () async {
                Navigator.pop(context);
                var res = await UserService()
                    .sendResetPwdEmail(context, _remindEmail.text);
                if (res) {
                  showInfo("Email został wysłany.", Colors.green);
                } else {
                  showInfo(
                      "Wystąpił błąd podczas wysyłania maila.", Colors.red);
                }
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                Color.fromARGB(255, 0, 162, 108),
                Color.fromARGB(255, 0, 184, 121),
                Color.fromARGB(255, 0, 181, 212),
                Color.fromARGB(255, 253, 191, 94),
                Color.fromARGB(255, 253, 223, 158)
              ]))),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  if (MediaQuery.of(context).viewInsets.bottom == 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: SvgPicture.asset(
                        'assets/logo.svg',
                        height: 200,
                      ),
                    ),
                  const SizedBox(height: 30),
                  const Text(
                    "Money Tracker",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 62, 41),
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ],
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
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => changePassword(),
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
                            onPressed: () =>
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterForm(),
                                  ),
                                ),
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
            ],
          ),
        ],
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
