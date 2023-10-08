import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/models/budget.dart';
import 'package:money_tracker/resources/budget_service.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'package:money_tracker/widgets/message.dart';
import 'package:money_tracker/widgets/simple_dark_button.dart';
import 'package:money_tracker/widgets/text_input_form.dart';
import '../main.dart';
import '../models/user.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _mail = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  DateTime now = DateTime.now();
  bool editBudget = false;
  Future? budgetData;
  bool isBudgetDataInitialized = false;
  String id = "";

  @override
  void initState() {
    budgetData = BudgetService().getCurrentBudget(user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _name.text = user.name ?? "";
    _surname.text = user.surname ?? "";
    _mail.text = user.email ?? "";
    _phone.text = user.telephone ?? "";
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
                            builder: (context) => const MyHomePage(),
                          ),
                        );
                      },
                      child: Icon(MdiIcons.arrowLeftCircle,
                          size: 40, color: Colors.white),
                    );
                  },
                ),
                automaticallyImplyLeading: true,
                title: const Text("Formularz edycji konta",
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
              padding: EdgeInsets.only(
                  bottom: 4.0,
                  left: size.width * 0.04,
                  right: size.width * 0.04),
              child: ListView(
                children: [
                  const Text("Dane użytkownika",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const Divider(thickness: 2, height: 2),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextInputForm(
                        width: size.width * 0.45,
                        hint: "Imię",
                        controller: _name,
                      ),
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
                        controller: _mail,
                      ),
                      TextInputForm(
                          width: size.width * 0.45,
                          hint: "Telefon",
                          controller: _phone),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Dane budżetu",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const Divider(thickness: 2, height: 2),
                  const SizedBox(height: 10),
                  AnimatedToggleSwitch<bool>.size(
                      indicatorColor: Theme.of(context).colorScheme.secondary,
                      borderColor: Theme.of(context).colorScheme.secondary,
                      indicatorSize: Size.fromWidth(size.width * 0.46),
                      onChanged: (val) {
                        setState(() {
                          editBudget = val;
                        });
                      },
                      iconBuilder: (value, size) {
                        String text = value
                            ? "Chcę zaktualizować aktualny budżet"
                            : "Nie chcę edytować aktualnego budżetu";
                        Color color =
                            value == editBudget ? Colors.white : Colors.black;
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
                      current: editBudget,
                      values: const [false, true]),
                  if (editBudget)
                    FutureBuilder(
                        future: budgetData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Indicator();
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text(
                                    'Wystąpił błąd. Spróbuj ponownie później.'));
                          } else if (snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('Nie znaleziono budżetu.'));
                          } else {
                            if (!isBudgetDataInitialized) {
                              var data = snapshot.data!;
                              id = data['budget']['_id'];
                              DateTime startDate =
                                  DateTime.parse(data['budget']['startDate']);
                              DateTime endDate =
                                  DateTime.parse(data['budget']['endDate']);
                              _amount.text =
                                  data['budget']['amount'].toString();
                              _startDate.text =
                                  DateFormat('yyyy-MM-dd').format(startDate);
                              _endDate.text =
                                  DateFormat('yyyy-MM-dd').format(endDate);
                              isBudgetDataInitialized = true;
                            }
                            return Column(
                              children: [
                                TextInputForm(
                                  width: size.width * 0.92,
                                  hint: "Kwota",
                                  controller: _amount,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    TextInputForm(
                                      width: size.width * 0.391,
                                      hint: "Data początkowa",
                                      controller: _startDate,
                                    ),
                                    const SizedBox(width: 5),
                                    TextInputForm(
                                      width: size.width * 0.39,
                                      hint: "Data końcowa",
                                      controller: _endDate,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 20),
                                        IconButton(
                                          onPressed: () {
                                            selectDateRange(
                                                _startDate, _endDate);
                                          },
                                          icon:
                                              const Icon(Icons.calendar_today),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            );
                          }
                        }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: SimpleDarkButton(
                          width: 300,
                          onPressed: () {
                            if (editBudget) {
                              updateBudget(context, _amount, _startDate,
                                  _endDate, _name, _surname, _phone, _mail, id);
                            } else {
                              updateUser(
                                  context, _name, _surname, _phone, _mail);
                            }
                          },
                          title: "Potwierdź zmiany"),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  selectDateRange(TextEditingController startDateController,
      TextEditingController endDateController) async {
    DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      locale: const Locale('pl', 'PL'),
      firstDate: setInitialDate(),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: DateFormat('yyyy-MM-dd').parseStrict(startDateController.text),
        end: DateFormat('yyyy-MM-dd').parseStrict(endDateController.text),
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch:
                  getMaterialColor(Theme.of(context).colorScheme.secondary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      String formattedStartDate =
          DateFormat('yyyy-MM-dd').format(pickedDateRange.start);
      String formattedEndDate =
          DateFormat('yyyy-MM-dd').format(pickedDateRange.end);

      setState(() {
        startDateController.text = formattedStartDate;
        endDateController.text = formattedEndDate;
      });
    }
  }
}

updateUser(
    BuildContext context,
    TextEditingController name,
    TextEditingController surname,
    TextEditingController phone,
    TextEditingController mail) async {
  if (name.text.isEmpty) {
    showInfo('Imię jest wymagane.', Colors.blue);
    return;
  }

  if (surname.text.isEmpty) {
    showInfo('Nazwisko jest wymagane.', Colors.blue);
    return;
  }

  if (mail.text.isEmpty) {
    showInfo('E-mail jest wymagany.', Colors.blue);
    return;
  }

  if (name.text.isNotEmpty ||
      surname.text.isNotEmpty ||
      mail.text.isNotEmpty ||
      phone.text.isEmpty) {
    User updatedUser = user;
    updatedUser.name = name.text.trim();
    updatedUser.surname = surname.text.trim();
    updatedUser.email = mail.text.trim();

    if (phone.text != "") {
      updatedUser.telephone = phone.text;
    }

    if (!context.mounted) return;
    Map<String, dynamic> userRes =
        await UserService().updateUserInfo(updatedUser);
    if (userRes['success']) {
      if (!context.mounted) return;
      showInfo('Twoje dane zostały zmienione.', Colors.green);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MyHomePage(),
      ));
    } else {
      if (!context.mounted) return;
      showInfo('Podczas zmiany danych użytkownika wystąpił błąd.', Colors.red);
    }
  }
}

DateTime setInitialDate() {
  DateTime now = DateTime.now();
  DateTime oneMonthAgo;

  if (now.month == 1) {
    oneMonthAgo = DateTime(now.year - 1, 12, now.day);
  } else {
    oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
  }

  return oneMonthAgo;
}

updateBudget(
    BuildContext context,
    TextEditingController amount,
    TextEditingController startDate,
    TextEditingController endDate,
    TextEditingController name,
    TextEditingController surname,
    TextEditingController phone,
    TextEditingController mail,
    String id) async {
  if (amount.text.isEmpty) {
    showInfo('Kwota jest wymagana.', Colors.blue);
    return;
  }

  if (startDate.text.isEmpty || endDate.text.isEmpty) {
    showInfo('Daty są wymagane.', Colors.blue);
    return;
  }

  if (amount.text.isNotEmpty ||
      endDate.text.isNotEmpty ||
      startDate.text.isNotEmpty) {
    Budget updatedBudget = Budget();
    updatedBudget.id = id;
    updatedBudget.amount =
        double.parse(amount.text.trim().replaceAll(',', '.'));
    DateTime parsedStartDate = DateTime.parse(startDate.text);
    DateTime newStartDate = parsedStartDate.add(const Duration(hours: 2));
    DateTime parsedEndDate = DateTime.parse(endDate.text);
    DateTime newEndDate = parsedEndDate.add(const Duration(hours: 2));
    updatedBudget.startDate = newStartDate;
    updatedBudget.endDate = newEndDate;

    if (!context.mounted) return;
    Map<String, dynamic> budgetRes =
        await BudgetService().updateBudget(updatedBudget, user.id!);
    if (budgetRes['success']) {
      if (!context.mounted) return;
      updateUser(context, name, surname, phone, mail);
      // showInfo('Twoje dane zostały zmienione.', Colors.green);
    } else {
      if (!context.mounted) return;
      showInfo('Podczas zmiany danych budżetu wystąpił błąd.', Colors.red);
    }
  }
}
