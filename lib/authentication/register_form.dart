import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:money_tracker/global.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Formularz rejestracyjny"),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 4.0, horizontal: size.width * 0.04),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Wypełnij formularz rejestracyjny i rozpocznij korzystanie z naszej aplikacji.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            const Text(
              "Gdy wyślesz poprawnie wypełniony formularz twoje konto stanie się aktywne, jednak zanim będziesz mógł zobaczyć dane swojej firmy, musisz przejść weryfikację.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: withShadow(),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: ExpandablePanel(
                    theme: const ExpandableThemeData(hasIcon: false),
                    header: const Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 8),
                        Text(
                          "Jak wygląda weryfikacja?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    collapsed: const SizedBox(),
                    expanded: const Text(
                      "Dokładamy wszelkich starań, żeby zabezpieczyć wrażliwe dane dotyczące twojej firmy, wobec czego podwójnie weryfikujemy wszystkich nowych użytkowników.\nPierwsza faza weryfikacji jest w pełni automatyczna i polega na sprawdzeniu poprawności wprowadzonych danych w naszym systemie.\nPodczas drugiej fazy nasz pracownik skontaktuję się z firmą, żeby potwierdzić zgodę na przetwarzanie danych w aplikacji.\nWeryfikacja nie powinna potrwać dłużej niż jeden dzień roboczy.",
                      textAlign: TextAlign.justify,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: withShadow(),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: ExpandablePanel(
                    theme: const ExpandableThemeData(hasIcon: false),
                    header: const Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 8),
                        Text(
                          "Skąd aplikacja zna dane mojej firmy?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    collapsed: const SizedBox(),
                    expanded: const Text(
                      "Dane naszych klientów są dobrze zabezpieczone i znajdują się na naszych własnych serwerach. Aplikacja łączy się z serwerem w celu zebrania danych o dokumentach finansowych klienta.\nDane nigdy nie będą pobierane, jeśli klient nie założy konta i nie wyrazi na to zgody. Zgoda może zostać w każdym momencie anulowana. Korzystanie z aplikacji wymaga weryfikacji - ustaw silne hasło i nie udzielaj innym osobom informacji o swoich danych do logowania.",
                      textAlign: TextAlign.justify,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: withShadow(),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: ExpandablePanel(
                    theme: const ExpandableThemeData(hasIcon: false),
                    header: const Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 8),
                        Text(
                          "Kto będzie miał dostęp do moich danych?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    collapsed: const SizedBox(),
                    expanded: const Text(
                      "Ze względów techniczych dostęp do informacji o koncie będzie miał zespół programistów. Nie udostępniamy nigdy danych użytkowników, nie zbieramy danych o użyciu aplikacji.",
                      textAlign: TextAlign.justify,
                    )),
              ),
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
                    width: size.width * 0.45, hint: "Imię", controller: _name),
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
                    hint: "E-mail",
                    controller: _mail),
                TextInputForm(
                    width: size.width * 0.45,
                    hint: "Telefon",
                    controller: _phone),
              ],
            ),
            const SizedBox(height: 10),
            TextInputForm(
                width: size.width * 0.92, hint: "Hasło", controller: _password),
            const SizedBox(height: 10),
            TextInputForm(
                width: size.width * 0.92,
                hint: "Powtórz hasło",
                controller: _passwordRepeat),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Wyślij formularz",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary))),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
