// ignore_for_file: use_build_context_synchronously

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/expenses/new_expense_form.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/models/type.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/type_service.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/message.dart';
import 'package:money_tracker/widgets/simple_button.dart';
import 'package:money_tracker/widgets/simple_dark_button.dart';
import 'package:money_tracker/widgets/text_input_form.dart';

class NewTypeForm extends StatefulWidget {
  final bool inExpenseFrom;
  final ExpenseFormData? currentData;
  const NewTypeForm({super.key, this.inExpenseFrom = false, this.currentData});

  @override
  State<NewTypeForm> createState() => _NewTypeFormState();
}

class _NewTypeFormState extends State<NewTypeForm> {
  final TextEditingController _type = TextEditingController();
  Color chosenColor = Colors.white;
  IconData _iconData = Icons.create;

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(
      context,
      title: const Text("Wybierz ikonę"),
      iconPackModes: [IconPack.material],
      backgroundColor: Theme.of(context).colorScheme.secondary,
      searchHintText: "Szukaj",
      iconColor: Colors.white,
      searchIcon: const Icon(
        Icons.search,
        color: Colors.white,
      ),
      searchClearIcon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      noResultsText: "Brak wyników",
      closeChild: Center(
        child: SimpleButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: "Anuluj"),
      ),
    );
    _iconData = icon ?? Icons.create;
    setState(() {});
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
                title: const Text("Formularz dodania typu",
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
                  const Text("Dane typu",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const Divider(thickness: 2, height: 2),
                  const SizedBox(height: 10),
                  TextInputForm(
                    width: size.width * 0.92,
                    hint: "Nazwa*",
                    controller: _type,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: InkWell(
                      onTap: _pickIcon,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ikona',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Icon(
                            _iconData,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
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
                          onPressed: () async {
                            if (_type.text.isEmpty) {
                              showInfo("Należy podać nazwę.", Colors.blue);
                              return;
                            }
                            MyType type = MyType();
                            type.name = _type.text;
                            type.icon = parseToCodePoint(_iconData);
                            type.color = '0xFF${chosenColor.hex}';
                            var res = await TypeService().addNewType(type);
                            if (res['success']) {
                              user.typeId.add(res['type']['_id']);
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
                              showInfo("Typ został dodany.", Colors.green);
                            } else {
                              showInfo("Wystąpił błąd podczas dodawania typu.",
                                  Colors.red);
                            }
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
    if (widget.inExpenseFrom && _type.text.isNotEmpty) {
      Navigator.of(context).pop(ExpenseFormData(
        amount: widget.currentData?.amount ?? "",
        date: widget.currentData?.date ?? "",
        type: widget.currentData?.type ?? "",
        category: widget.currentData?.category ?? "",
        newType: _type.text,
      ));
    } else {
      Navigator.of(context).pop(widget.currentData);
    }
  }

  parseToCodePoint(IconData? icon) {
    return icon?.codePoint;
  }
}
