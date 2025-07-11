// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/models/budget.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/budget_service.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/message.dart';
import 'package:money_tracker/widgets/simple_dark_button.dart';
import 'package:money_tracker/widgets/text_input_form.dart';

class SetBudgetForm extends StatefulWidget {
  const SetBudgetForm({super.key});

  @override
  State<SetBudgetForm> createState() => _SetBudgetFormState();
}

class _SetBudgetFormState extends State<SetBudgetForm> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  DateTime now = DateTime.now();
  int value = 90;
  int over = 100;

  @override
  void initState() {
    _startDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _endDate.text = DateFormat('yyyy-MM-dd')
        .format(DateTime(now.year, now.month + 1, now.day));
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
                title: const Text("Formularz ustawiania budżetu",
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
                right: size.width * 0.04,
              ),
              child: ListView(
                children: [
                  const Text("Dane budżetu",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const Divider(thickness: 2, height: 2),
                  const SizedBox(height: 10),
                  TextInputForm(
                    width: size.width * 0.92,
                    hint: "Kwota*",
                    controller: _amount,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      TextInputForm(
                        width: size.width * 0.391,
                        hint: "Data początkowa*",
                        controller: _startDate,
                      ),
                      const SizedBox(width: 5),
                      TextInputForm(
                        width: size.width * 0.39,
                        hint: "Data końcowa*",
                        controller: _endDate,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          IconButton(
                            onPressed: () =>
                                selectDateRange(_startDate, _endDate),
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ],
                      )
                    ],
                  ),
                  if (user.notifications ?? false)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text("Powiadomienia",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        const Divider(thickness: 2, height: 2),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                                child: Text("O wykorzystanym limicie budżetu")),
                            Container(
                              width: 77,
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: value,
                                  isExpanded: true,
                                  onChanged: (val) {
                                    setState(() {
                                      value = val ?? 90;
                                    });
                                  },
                                  items:
                                      [95, 90, 85, 80, 70, 50].map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(
                                        value.toString(),
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                                child: Text("O przekroczeniu limitu budżetu")),
                            Container(
                              width: 77,
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: over,
                                  isExpanded: true,
                                  onChanged: (val) {
                                    setState(() {
                                      over = val ?? 100;
                                    });
                                  },
                                  items: [115, 110, 105, 100].map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(
                                        value.toString(),
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
                      ],
                    ),
                  if (!(user.notifications ?? false))
                    const SizedBox(height: 10),
                  Center(
                    child: SimpleDarkButton(
                        width: 300,
                        onPressed: () {
                          setNewBudget();
                        },
                        title: "Wyślij formularz"),
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

  setNewBudget() async {
    if (_amount.text.isNotEmpty &&
        _startDate.text.isNotEmpty &&
        _endDate.text.isNotEmpty) {
      Map<String, dynamic> notification = {
        'budgetValue': value,
        'budgetOver': over
      };

      Budget budget = Budget();
      budget.amount = double.parse(_amount.text.trim().replaceAll(',', '.'));
      DateTime parsedStartDate = DateTime.parse(_startDate.text);
      DateTime newStartDate = parsedStartDate.add(const Duration(hours: 2));
      DateTime parsedEndDate = DateTime.parse(_endDate.text);
      DateTime newEndDate = parsedEndDate.add(const Duration(hours: 2));
      budget.startDate = newStartDate;
      budget.endDate = newEndDate;
      budget.notification = notification;

      var res = await BudgetService().addNewBudget(budget, user.id!);

      if (res['success']) {
        user.budgetId.add(res['budget']['_id']);
        await UserService().updateUserInfo(user);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
        showInfo('Budżet został ustawiony.', Colors.green);
      } else if (res['msg'] == 'budgetOverlaps') {
        showInfo(
            'Termin nowego budżetu pokrywa się z terminem ustalonego wcześniej budżetu.',
            Colors.blue);
      } else {
        showInfo('Wystąpił błąd podczas ustawiania budżetu.', Colors.red);
      }
    } else {
      showInfo('Musisz uzupełnić pola oznaczone gwiazdką*.', Colors.blue);
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
