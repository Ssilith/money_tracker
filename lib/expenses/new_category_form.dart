// ignore_for_file: use_build_context_synchronously

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/expenses/new_expense_form.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/models/category.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/category_service.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/message.dart';
import 'package:money_tracker/widgets/simple_dark_button.dart';
import 'package:money_tracker/widgets/text_input_form.dart';

class NewCategoryForm extends StatefulWidget {
  final bool inExpenseFrom;
  final ExpenseFormData? currentData;
  const NewCategoryForm(
      {super.key, this.inExpenseFrom = false, this.currentData});

  @override
  State<NewCategoryForm> createState() => _NewCategoryFormState();
}

class _NewCategoryFormState extends State<NewCategoryForm> {
  final TextEditingController _name = TextEditingController();
  Color chosenColor = Colors.white;

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
                        if (widget.inExpenseFrom) {
                          _returnToPreviousPage();
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(),
                            ),
                          );
                        }
                      },
                      child: Icon(MdiIcons.arrowLeftCircle,
                          size: 40, color: Colors.white),
                    );
                  },
                ),
                automaticallyImplyLeading: true,
                title: const Text("Formularz dodania kategorii",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                centerTitle: true,
                floating: true,
                snap: true,
              ),
            ];
          },
          body: Container(
            color: const Color.fromARGB(255, 253, 223, 158).withOpacity(0.2),
            height: size.height,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: 4.0,
                  left: size.width * 0.04,
                  right: size.width * 0.04),
              child: ListView(
                children: [
                  const Text("Dane kategorii",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const Divider(thickness: 2, height: 2),
                  const SizedBox(height: 10),
                  TextInputForm(
                    width: size.width * 0.92,
                    hint: "Nazwa*",
                    controller: _name,
                  ),
                  ColorPicker(
                    title: Text(
                      'Kolor',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    color: chosenColor,
                    onColorChanged: (Color color) =>
                        setState(() => chosenColor = color),
                    width: 44,
                    height: 44,
                    borderRadius: 22,
                    subheading: Text(
                      'Wybierz odcień',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: SimpleDarkButton(
                          width: 300,
                          onPressed: () {
                            addNewCategory();
                          },
                          title: "Wyślij formularz"),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  _returnToPreviousPage() {
    if (widget.inExpenseFrom && _name.text.isNotEmpty) {
      Navigator.of(context).pop(ExpenseFormData(
        amount: widget.currentData?.amount ?? "",
        date: widget.currentData?.date ?? "",
        type: widget.currentData?.type ?? "",
        category: widget.currentData?.category ?? "",
        newCategory: _name.text,
      ));
    } else {
      Navigator.of(context).pop(widget.currentData);
    }
  }

  addNewCategory() async {
    if (_name.text.isNotEmpty) {
      Category category = Category();
      category.name = _name.text.trim();
      category.color = '0xFF${chosenColor.hex}';

      var res = await CategoryService().addCategory(category);
      if (res['success']) {
        user.categoryId.add(res['newCategory']['_id']);
        await UserService().updateUserInfo(user);
        if (widget.inExpenseFrom) {
          _returnToPreviousPage();
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
        }
        showInfo('Kategoria została utworzona.', Colors.green);
      } else {
        showInfo('Wystąpił błąd poodczas tworzenia kategorii.', Colors.red);
      }
    } else {
      showInfo('Musisz uzupełnić pola oznaczone gwiazdką*.', Colors.blue);
    }
  }
}
