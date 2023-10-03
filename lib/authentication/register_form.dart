import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/authentication/login_screen.dart';
import 'package:money_tracker/create_document/privacy_policy.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/message.dart';
import 'package:money_tracker/widgets/simple_dark_button.dart';
import 'package:money_tracker/widgets/text_input_form.dart';

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
            surfaceTintColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).colorScheme.secondary,
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
                      size: 40, color: Colors.white),
                );
              },
            ),
            automaticallyImplyLeading: true,
            title: const Text("Formularz rejestracyjny",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            centerTitle: true,
            floating: true,
            snap: true,
          ),
        ];
      },
      body: SizedBox(
        // color: const Color.fromARGB(255, 253, 223, 158).withOpacity(0.2),
        height: size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 4.0, horizontal: size.width * 0.04),
          child: ListView(
            children: [
              const Text(
                "Wypełnij formularz rejestracyjny i rozpocznij korzystanie z aplikacji!",
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(vertical: 5),
              //     child: ExpandablePanel(
              //         theme: const ExpandableThemeData(hasIcon: false),
              //         header: const Row(
              //           children: [
              //             Icon(Icons.info),
              //             SizedBox(width: 8),
              //             Text(
              //               "Po co nam informacja o stanie konta?",
              //               style: TextStyle(fontWeight: FontWeight.bold),
              //             ),
              //           ],
              //         ),
              //         collapsed: const SizedBox(),
              //         expanded: const Text(
              //           "Podanie informacji o stanie Twojego konta w aplikacji jest całkowicie opcjonalne. Jednak dzięki dokładnym informacjom o Twoim saldzie możemy precyzyjniej analizować Twoje przychody i wydatki. Ponadto, wiedząc dokładnie, ile masz środków, możesz łatwiej dostosować budżet do rzeczywistych potrzeb, unikając niespodziewanych deficytów.",
              //           textAlign: TextAlign.justify,
              //         )),
              //   ),
              // ),
              const SizedBox(height: 16),
              const Text("Dane użytkownika",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const Divider(thickness: 2, height: 2),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextInputForm(
                      width: size.width * 0.45,
                      hint: "Imię*",
                      controller: _name),
                  TextInputForm(
                      width: size.width * 0.45,
                      hint: "Nazwisko",
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
                    controller: _mail,
                  ),
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
                    style:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
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
                      child: SimpleDarkButton(
                        onPressed: () {
                          registerUser();
                        },
                        buttonColor: Theme.of(context).colorScheme.secondary,
                        title: "Wyślij formularz",
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  registerUser() async {
    if (privicyPolicy) {
      if (_name.text.isNotEmpty &&
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
          newUser.onboard = false;

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
