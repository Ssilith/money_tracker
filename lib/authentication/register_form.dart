import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/authentication/login_screen.dart';
import 'package:money_tracker/create_document/privacy_policy.dart';
import 'package:money_tracker/global.dart';
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
  final ExpandableController _addMoreController = ExpandableController();
  List<TextEditingController> nameMoreNot = [TextEditingController()];
  List<TextEditingController> dayMoreNot = [TextEditingController()];
  List<TextEditingController> hourMoreNot = [TextEditingController()];
  bool isMoreThanOne = false;
  String value = "90";

  @override
  void initState() {
    dayMoreNot[0].text = DateFormat('dd').format(DateTime.now());
    hourMoreNot[0].text = DateFormat('HH:mm').format(DateTime.now());
    super.initState();
  }

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
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ExpandablePanel(
                      theme: const ExpandableThemeData(hasIcon: false),
                      header: const Row(
                        children: [
                          Icon(Icons.info),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Po co nam informacja o terminie podatków?",
                              maxLines: 2,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      collapsed: const SizedBox(),
                      expanded: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    "Podanie informacji o terminie płatności Twoich podatków w aplikacji jest całkowicie opcjonalne. Jednakże, znając dokładną datę, możemy pomóc Ci lepiej zarządzać Twoim budżetem i przypomnieć o zbliżającym się terminie, co może pomóc uniknąć nieprzyjemnych sytuacji związanych z opóźnionymi płatnościami.\nPamiętaj, że zaznaczając opcję ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins")),
                            TextSpan(
                                text: '"Chcę otrzymywać powiadomienia"',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontFamily: "Poppins")),
                            TextSpan(
                                text:
                                    ' zgadzasz się na wysyłanie powiadomień przez aplikację.',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins")),
                          ],
                        ),
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
              AnimatedToggleSwitch<bool>.size(
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  borderColor: Theme.of(context).colorScheme.secondary,
                  indicatorSize: Size.fromWidth(size.width * 0.46),
                  onChanged: (i) {
                    setState(() {
                      isMoreThanOne = i;
                      _addMoreController.expanded = i;
                    });
                  },
                  iconBuilder: (value, size) {
                    String text = value
                        ? "Chcę otrzymywać powiadomienia"
                        : "Nie chcę otrzymywać powiadomień";
                    Color color =
                        value == isMoreThanOne ? Colors.white : Colors.black;
                    return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        alignment: Alignment.center,
                        child: Text(
                          text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: color),
                          textAlign: TextAlign.center,
                        ));
                  },
                  current: isMoreThanOne,
                  values: const [false, true]),
              const SizedBox(height: 15),
              ExpandablePanel(
                  controller: _addMoreController,
                  collapsed: const SizedBox(),
                  expanded: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                              child: Text("O wykorzystanym limicie budżetu")),
                          Container(
                            width: 77,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: value,
                                isExpanded: true,
                                onChanged: (val) {
                                  setState(() {
                                    value = val ?? "90";
                                  });
                                },
                                items: ["95", "90", "85", "80", "70", "50"]
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                                dropdownColor: Theme.of(context).canvasColor,
                                iconEnabledColor:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          const Text("%")
                        ],
                      ),
                      const Text(
                        "Wpisz nazwę oraz dzień i godzinę, w których chcesz otrzymywać comiesięczne powiadomienie o płatnościach.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      for (var i = 0; i < nameMoreNot.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              TextInputForm(
                                  width: size.width * 0.92,
                                  hint: "Nazwa powiadomienia nr ${i + 2}*",
                                  controller: nameMoreNot[i]),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextInputForm(
                                      width: size.width * 0.32,
                                      hint: "Dzień*",
                                      controller: dayMoreNot[i]),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 20),
                                      IconButton(
                                        onPressed: () =>
                                            selectDate(dayMoreNot[i]),
                                        icon: const Icon(Icons.calendar_today),
                                      ),
                                    ],
                                  ),
                                  TextInputForm(
                                      width: size.width * 0.32,
                                      hint: "Godzina*",
                                      controller: hourMoreNot[i]),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 20),
                                      IconButton(
                                        onPressed: () =>
                                            selectHour(hourMoreNot[i]),
                                        icon: const Icon(Icons.access_time),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      TextButton(
                          onPressed: () {
                            TextEditingController newNotController =
                                TextEditingController();
                            setState(() {
                              nameMoreNot.add(newNotController);
                              dayMoreNot.add(newNotController);
                              hourMoreNot.add(newNotController);
                            });
                          },
                          child: Text(
                            "Dodaj kolejne powiadomienie",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ))
                    ],
                  )),
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

  selectHour(TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          DateFormat('HH:mm').parseStrict(controller.text)),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: getMaterialColor(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      String formattedHour = DateFormat('HH:mm').format(
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        ),
      );
      setState(() {
        controller.text = formattedHour;
      });
    }
  }

  selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        locale: const Locale('pl'),
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: getMaterialColor(
                      Theme.of(context).colorScheme.secondary)),
            ),
            child: child!,
          );
        });
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd').format(pickedDate);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }
}
