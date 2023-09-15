import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/authentication/login_screen.dart';
import 'package:money_tracker/create_document/privacy_policy.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/message.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordRepeat = TextEditingController();
  final TextEditingController _mail = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool privicyPolicy = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            surfaceTintColor: Colors.white.withOpacity(0.7),
            backgroundColor: Colors.white.withOpacity(0.7),
            leading: Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: Icon(MdiIcons.arrowLeftCircle,
                      size: 40, color: Theme.of(context).colorScheme.secondary),
                );
              },
            ),
            automaticallyImplyLeading: true,
            title: Text("Formularz rejestracyjny",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600)),
            centerTitle: true,
            floating: true,
            snap: true,
          ),
        ];
      },
      body: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 4.0, horizontal: size.width * 0.04),
        child: ListView(
          children: [
            const Text(
              "Wypełnij formularz rejestracyjny i rozpocznij korzystanie z aplikacji.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            const SizedBox(height: 16),
            const Text("Dane użytkownika",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const Divider(thickness: 2, height: 2),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextInputForm(
                    width: size.width * 0.45, hint: "Imię*", controller: _name),
                TextInputForm(
                    width: size.width * 0.45,
                    hint: "Nazwisko*",
                    controller: _surname),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextInputForm(
                    width: size.width * 0.45,
                    hint: "E-mail*",
                    controller: _mail),
                TextInputForm(
                    width: size.width * 0.45,
                    hint: "Telefon",
                    controller: _phone),
              ],
            ),
            const SizedBox(height: 10),
            TextInputForm(
                width: size.width * 0.92,
                hint: "Hasło*",
                controller: _password),
            const SizedBox(height: 10),
            TextInputForm(
                width: size.width * 0.92,
                hint: "Powtórz hasło*",
                controller: _passwordRepeat),
            const SizedBox(height: 10),
            CheckboxListTile(
              activeColor: Theme.of(context).colorScheme.secondary,
              controlAffinity: ListTileControlAffinity.leading,
              value: privicyPolicy,
              onChanged: (bool? value) {
                setState(() {
                  privicyPolicy = !privicyPolicy;
                });
              },
              title: const Text(
                  "Zgadzam się na przetwarzanie moich danych osobowych.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
              subtitle: InkWell(
                  onTap: () => privacyPolicyPdf(),
                  child: const Text(
                      "Pełną klauzulę informacyjną znajdziesz pod tym adresem.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 12))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {
                        registerUser();
                      },
                      child: Text("Wyślij formularz",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary))),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  registerUser() async {
    if (privicyPolicy) {
      if (_name.text.isNotEmpty &&
          _surname.text.isNotEmpty &&
          _mail.text.isNotEmpty &&
          _password.text.isNotEmpty &&
          _passwordRepeat.text.isNotEmpty) {
        if (_password.text == _passwordRepeat.text) {
          User newUser = User();
          newUser.name = _name.text.trim();
          newUser.surname = _surname.text.trim();
          newUser.email = _mail.text.trim();
          newUser.telephone = _phone.text;
          newUser.permissions = privicyPolicy;

          if (!mounted) return;
          Map<String, dynamic> userRes = await UserService()
              .addUser(context, newUser, _password.text.trim());

          if (userRes['success']) {
            if (!mounted) return;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
            showInfo('Twoje konto zostało utworzone.', Colors.green);
          } else {
            showInfo('Wystąpił błąd poodczas tworzenia konta.', Colors.red);
          }
        } else {
          showInfo('Wpisane hasła nie są takie same.', Colors.blue);
        }
      } else {
        showInfo('Musisz uzupełnić pola oznaczone gwiazdką*.', Colors.blue);
      }
    } else {
      showInfo('Musisz zaakceptować zgody.', Colors.blue);
    }
  }
}

class TextInputForm extends StatelessWidget {
  final double width;
  final String hint;
  final TextEditingController controller;
  const TextInputForm(
      {super.key,
      required this.width,
      required this.hint,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600),
          ),
          TextField(
            controller: controller,
            cursorColor: Theme.of(context).colorScheme.secondary,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.secondary)),
                focusColor: Theme.of(context).colorScheme.secondary,
                border: const OutlineInputBorder(),
                hintText: hint),
          ),
        ],
      ),
    );
  }
}
