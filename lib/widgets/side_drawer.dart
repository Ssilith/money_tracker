// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_tracker/authentication/login_screen.dart';
import 'package:money_tracker/expenses/new_category_form.dart';
import 'package:money_tracker/expenses/new_type_form.dart';
import 'package:money_tracker/expenses/set_budget_form.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/profile/edit_profile_form.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/message.dart';
import 'package:money_tracker/widgets/popup_window.dart';

class SideDrawer extends StatelessWidget {
  final Function(Screens) onTap;
  const SideDrawer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width * 0.85,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 250,
              width: size.width * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: 110,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${user.name ?? ""} ${user.surname ?? ""}",
                    style: const TextStyle(
                        height: 1,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 22),
                  ),
                  Text(
                    user.email ?? "",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
            const SizedBox(height: 10),
            DrawerTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const NewCategoryForm()));
                },
                text: "Dodaj kategorię",
                icon: Icons.add_box,
                size: 26),
            DrawerTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const NewTypeForm()));
                },
                text: "Dodaj typ",
                icon: Icons.create,
                size: 26),
            DrawerTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SetBudgetForm(),
                    ),
                  );
                },
                text: "Ustaw budżet",
                icon: Icons.attach_money,
                size: 26),
            const Divider(
              color: Color.fromARGB(49, 66, 66, 66),
            ),
            DrawerTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const EditProfileForm(),
                    ),
                  );
                },
                text: "Edytuj konto",
                icon: Icons.manage_accounts,
                size: 26),
            DrawerTile(
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopupWindow(
                        title: "Usuń konto",
                        message: "Czy na pewno chcesz usunąć konto?",
                        onPressed: () async {
                          await UserService().deleteAccount(context, user.id!);
                          showInfo("Konto zostało usunięte.", Colors.green);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      );
                    }),
                text: "Usuń konto",
                icon: Icons.no_accounts,
                size: 26),
            const Divider(
              color: Color.fromARGB(49, 66, 66, 66),
            ),
            DrawerTile(
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopupWindow(
                        title: "Wyloguj się",
                        message: "Czy na pewno chcesz się wylogować?",
                        onPressed: () async {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                          await UserService().logout(context);
                        },
                      );
                    }),
                text: "Wyloguj",
                icon: Icons.logout,
                size: 26),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final int size;
  const DrawerTile(
      {super.key,
      required this.onTap,
      required this.text,
      required this.icon,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
        size: size.toDouble(),
      ),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      onTap: () => onTap(),
    );
  }
}
