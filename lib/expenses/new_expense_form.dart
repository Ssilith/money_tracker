// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/expenses/new_category_form.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/models/transaction.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/category_service.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/dropdown_input_form.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'package:money_tracker/widgets/message.dart';
import 'package:money_tracker/widgets/simple_dark_button.dart';
import 'package:money_tracker/widgets/text_input_form.dart';

class NewExpenseForm extends StatefulWidget {
  final ExpenseFormData? previousData;
  const NewExpenseForm({super.key, this.previousData});

  @override
  State<NewExpenseForm> createState() => _NewExpenseFormState();
}

class _NewExpenseFormState extends State<NewExpenseForm> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _description = TextEditingController();
  String type = "Wydatek";
  Future? getCategoriesNames;
  String? category;
  String categoryId = "";
  List<String> categories = [];

  @override
  initState() {
    getCategoriesNames = CategoryService().getCategoriesNames();
    if (widget.previousData != null) {
      _amount.text = widget.previousData!.amount;
      _date.text = widget.previousData!.date;
      type = widget.previousData!.type;
      category = widget.previousData!.category;
    } else {
      _date.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    super.initState();
  }

  void reloadCategories() {
    getCategoriesNames = CategoryService().getCategoriesNames();
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
                title: const Text("Formularz dodania transakcji",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                centerTitle: true,
              ),
            ];
          },
          body: FutureBuilder(
              future: getCategoriesNames,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Indicator();
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Wystąpił błąd. Spróbuj ponownie później.'));
                } else {
                  if (snapshot.hasData && (snapshot.data as List).isNotEmpty) {
                    categories = snapshot.data!;
                    category = category ?? categories[0];
                  } else {
                    categories = ['Dodaj nową kategorię'];
                    category = 'Dodaj nową kategorię';
                  }
                  return Container(
                    color: const Color.fromARGB(255, 253, 223, 158)
                        .withOpacity(0.2),
                    height: size.height,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 4.0,
                          left: size.width * 0.04,
                          right: size.width * 0.04),
                      child: ListView(
                        children: [
                          const Text("Dane transakcji",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          const Divider(thickness: 2, height: 2),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextInputForm(
                                width: size.width * 0.45,
                                hint: "Kwota*",
                                controller: _amount,
                              ),
                              DropdownInputForm(
                                key: ValueKey(categories),
                                width: size.width * 0.45,
                                hint: "Typ*",
                                selectedValue: type,
                                items: const ["Wydatek", "Przychód"],
                                onChanged: (value) {
                                  setState(() {
                                    type = value ?? "Wydatek";
                                  });
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              DropdownInputForm(
                                width: size.width * 0.8,
                                hint: "Kategoria*",
                                selectedValue: category,
                                items: categories,
                                addNew: category == "Dodaj nową kategorię"
                                    ? true
                                    : false,
                                onChanged: (val) {
                                  setState(() {
                                    category = val ?? categories[0];
                                  });
                                },
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 20),
                                  IconButton(
                                    onPressed: () async {
                                      ExpenseFormData currentData =
                                          ExpenseFormData(
                                        amount: _amount.text,
                                        date: _date.text,
                                        type: type,
                                        category: category!,
                                      );
                                      final returnedData =
                                          await Navigator.of(context)
                                              .push<ExpenseFormData>(
                                        MaterialPageRoute(
                                          builder: (context) => NewCategoryForm(
                                            inExpenseFrom: true,
                                            currentData: currentData,
                                          ),
                                        ),
                                      );

                                      if (returnedData != null) {
                                        setState(() {
                                          _amount.text = returnedData.amount;
                                          _date.text = returnedData.date;
                                          type = returnedData.type;
                                          category = returnedData.category;
                                          if (returnedData.newCategory !=
                                              null) {
                                            if (categories[0] ==
                                                'Dodaj nową kategorię') {
                                              categories.clear();
                                              reloadCategories();
                                            }
                                            categories
                                                .add(returnedData.newCategory!);
                                            category =
                                                returnedData.newCategory!;
                                          }
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              TextInputForm(
                                width: size.width * 0.8,
                                hint: "Data*",
                                controller: _date,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 20),
                                  IconButton(
                                    onPressed: () => selectDate(_date),
                                    icon: const Icon(Icons.calendar_today),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextInputForm(
                            width: size.width * 0.92,
                            hint: "Opis",
                            controller: _description,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: SimpleDarkButton(
                                  width: 300,
                                  onPressed: () {
                                    addNewTransaction();
                                  },
                                  title: "Wyślij formularz"),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              })),
    );
  }

  selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        locale: const Locale('pl', 'PL'),
        initialDate: DateFormat('yyyy-MM-dd').parseStrict(controller.text),
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
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _date.text = formattedDate;
      });
    }
  }

  addNewTransaction() async {
    var cat = await CategoryService().getCategoryIdByName(category!);
    if (cat['success']) {
      if (_amount.text.isNotEmpty && _date.text.isNotEmpty) {
        Transaction transaction = Transaction();
        transaction.amount =
            double.parse(_amount.text.trim().replaceAll(',', '.'));
        transaction.date = DateTime.parse(_date.text);
        transaction.category = cat['category']['_id'].toString();
        transaction.type = type;
        transaction.description = _description.text;

        var res = await TransactionService().addNewTransaction(transaction);

        if (res['success']) {
          user.transactionId.add(res['transaction']['_id']);
          await UserService().updateUserInfo(user);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
          showInfo('Transakcja została utworzona.', Colors.green);
        } else {
          showInfo('Wystąpił błąd podczas tworzenia transakcji.', Colors.red);
        }
      } else {
        showInfo('Musisz uzupełnić pola oznaczone gwiazdką*.', Colors.blue);
      }
    } else {
      showInfo('Sprawdź czy kategoria jest poprawna.', Colors.red);
    }
  }
}

class ExpenseFormData {
  final String amount;
  final String date;
  final String type;
  final String category;
  final String? newCategory;

  ExpenseFormData({
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.newCategory,
  });
}
