import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/authentication/register_form.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/message.dart';
import 'package:money_tracker/widgets/simple_button.dart';
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
                surfaceTintColor: Colors.white.withOpacity(0.7),
                backgroundColor: Colors.white.withOpacity(0.7),
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
                          size: 40,
                          color: Theme.of(context).colorScheme.secondary),
                    );
                  },
                ),
                automaticallyImplyLeading: true,
                title: Text("Formularz edycji konta",
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
            padding: EdgeInsets.only(
                bottom: 4.0, left: size.width * 0.04, right: size.width * 0.04),
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
                        controller: _phone)
                  ],
                ),
                const SizedBox(height: 10),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 70.0),
                //   child: AnimatedToggleSwitch<String>.size(
                //     indicatorColor: Theme.of(context).colorScheme.secondary,
                //     borderColor: Theme.of(context).colorScheme.secondary,
                //     indicatorSize: Size.fromWidth(size.width * 0.46),
                //     current: currency,
                //     values: const ["PLN", "EUR"],
                //     iconBuilder: (value, size) {
                //       Color color = currency == value ? Colors.white : Colors.black;
                //       return Container(
                //           padding: const EdgeInsets.symmetric(
                //               vertical: 5, horizontal: 5),
                //           alignment: Alignment.center,
                //           child: Text(
                //             value,
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w600,
                //                 fontSize: 14,
                //                 color: color),
                //             textAlign: TextAlign.center,
                //           ));
                //     },
                //     onChanged: (i) {
                //       setState(() {
                //         currency = i;
                //       });
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: SimpleButton(
                        width: 300,
                        onPressed: () {
                          updateUser(context, _name, _surname, _phone, _mail);
                        },
                        text: "Potwierdź zmiany"),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

updateUser(
    BuildContext context,
    TextEditingController name,
    TextEditingController surname,
    TextEditingController phone,
    TextEditingController mail) async {
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
