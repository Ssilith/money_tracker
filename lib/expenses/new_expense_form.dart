// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/expenses/new_category_form.dart';
import 'package:money_tracker/expenses/new_type_form.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/models/transaction.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/category_service.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/resources/type_service.dart';
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
  String typeId = "";
  Future<List<String>>? getCategoriesNames;
  Future<List<String>>? getTypeNames;
  String? category;
  String categoryId = "";
  List<String> categories = [];
  List<String> types = ["Wydatek", "Przychód"];
  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    if (widget.previousData != null) {
      _amount.text = widget.previousData!.amount;
      _date.text = widget.previousData!.date;
      type = widget.previousData!.type;
      category = widget.previousData!.category;
    } else {
      _date.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      type = "Wydatek";
    }
  }

  void _loadData() async {
    categories = await CategoryService().getCategoriesNames(user.id!);
    List<String> fetchedTypes = await TypeService().getTypesNames(user.id!);
    types.addAll(fetchedTypes);

    if (categories.isEmpty) {
      categories = ['Dodaj nową kategorię'];
      category = 'Dodaj nową kategorię';
    } else {
      category = category ?? categories.first;
    }

    setState(() {
      dataFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!dataFetched) {
      return const Indicator();
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
            body: SizedBox(
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
                    TextInputForm(
                      width: size.width * 0.92,
                      hint: "Kwota*",
                      controller: _amount,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        DropdownInputForm(
                          key: ValueKey(categories),
                          width: size.width * 0.795,
                          hint: "Typ*",
                          selectedValue: type,
                          items: types,
                          onChanged: (value) {
                            setState(() {
                              type = value ?? types[0];
                            });
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            IconButton(
                              onPressed: () async {
                                ExpenseFormData currentData = ExpenseFormData(
                                  amount: _amount.text,
                                  date: _date.text,
                                  type: type,
                                  category: category!,
                                );
                                final returnedData = await Navigator.of(context)
                                    .push<ExpenseFormData>(
                                  MaterialPageRoute(
                                    builder: (context) => NewTypeForm(
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
                                    if (returnedData.newType != null) {
                                      types.add(returnedData.newType!);
                                      type = returnedData.newType!;
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
                        DropdownInputForm(
                          width: size.width * 0.795,
                          hint: "Kategoria*",
                          selectedValue: category,
                          items: categories,
                          addNew:
                              category == "Dodaj nową kategorię" ? true : false,
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
                                ExpenseFormData currentData = ExpenseFormData(
                                  amount: _amount.text,
                                  date: _date.text,
                                  type: type,
                                  category: category!,
                                );
                                final returnedData = await Navigator.of(context)
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
                                    if (returnedData.newCategory != null) {
                                      categories.add(returnedData.newCategory!);
                                      category = returnedData.newCategory!;
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
                          width: size.width * 0.795,
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
            )));
  }

  selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        locale: const Locale('pl'),
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
        controller.text = formattedDate;
      });
    }
  }

  addNewTransaction() async {
    var cat = await CategoryService().getCategoryIdByName(category!);
    var typ;
    if (type != "Wydatek" && type != "Przychod" && type != "Przychód") {
      typ = await TypeService().getTypeIdByName(type);
    } else {
      typ = {'success': true};
    }
    if (cat['success'] && typ['success']) {
      if (_amount.text.isNotEmpty && _date.text.isNotEmpty) {
        Transaction transaction = Transaction();
        transaction.amount =
            double.parse(_amount.text.trim().replaceAll(',', '.'));
        DateTime parsedDate = DateTime.parse(_date.text);
        DateTime newDate = parsedDate.add(const Duration(hours: 2));
        transaction.date = newDate;
        transaction.category = cat['category']['_id'].toString();
        if (type != "Wydatek" && type != "Przychod" && type != "Przychód") {
          transaction.type = typ['type']['_id'].toString();
        } else {
          transaction.type = type;
        }
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
  final String? newType;

  ExpenseFormData({
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.newCategory,
    this.newType,
  });
}
