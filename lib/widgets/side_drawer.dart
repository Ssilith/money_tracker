import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_tracker/authentication/login_screen.dart';
import 'package:money_tracker/expenses/new_expense_form.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/main_screens/exchange_rates.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/profile/edit_profile_form.dart';
import 'package:money_tracker/resources/user_service.dart';
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const NewExpenseForm(),
                    ),
                  );
                },
                text: "Dodaj transakcję",
                icon: Icons.add,
                size: 26),
            DrawerTile(
                onTap: () {
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //     builder: (context) => const AddCompanyForm(),
                  //   ),
                  // );
                },
                text: "Dodaj kategorię",
                icon: Icons.folder,
                size: 26),
            DrawerTile(
                onTap: () {
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //     builder: (context) => const AddCompanyForm(),
                  //   ),
                  // );
                },
                text: "Ustaw budżet",
                icon: Icons.pie_chart,
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
                onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ExchangeRates(),
                      ),
                    ),
                text: "Kursy walut",
                icon: FontAwesomeIcons.arrowTrendUp,
                size: 22),
            const Divider(
              color: Color.fromARGB(49, 66, 66, 66),
            ),
            // DrawerTile(
            //     onTap: () => Navigator.of(context).pushReplacement(
            //           MaterialPageRoute(
            //             builder: (context) => const AboutUs(),
            //           ),
            //         ),
            //     text: "O nas",
            //     icon: Icons.info,
            //     size: 26),
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
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       InkWell(
            //           onTap: () {},
            //           // => Navigator.of(context).pushReplacement(
            //           //       MaterialPageRoute(
            //           //         builder: (context) => const ContactPage(),
            //           //       ),
            //           //     ),
            //           child: const Text("Kontakt")),
            //       const SizedBox(height: 8),
            //       InkWell(onTap: () {}, child: const Text("Regulamin")),
            //       const SizedBox(height: 8),
            //       InkWell(
            //           onTap: () => privacyPolicyPdf(),
            //           child: const Text("Polityka prywatności")),
            //     ],
            //   ),
            // ),
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
