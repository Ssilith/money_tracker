import 'package:flutter/material.dart';
import 'package:money_tracker/authentication/login_screen.dart';
import 'package:money_tracker/main.dart';

class SideDrawer extends StatelessWidget {
  final Function(Screens) onTap;
  const SideDrawer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      //  backgroundColor: const Color.fromARGB(192, 255, 255, 255),
      width: size.width * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 107, 107, 107),
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 250,
                width: size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: SizedBox(
                        width: size.width * 0.5,
                        child: const Image(
                          image: AssetImage('assets/long_logo_gold.png'),
                        ),
                      ),
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.account_circle,
                            color: Colors.white54, size: 60),
                        Text(
                          "Michał Janiszewski",
                          style: TextStyle(
                              height: 1,
                              color: Colors.white54,
                              fontWeight: FontWeight.w600,
                              fontSize: 19),
                        ),
                        Text(
                          "mj@syma-group.com",
                          style: TextStyle(
                              color: Colors.white54,
                              fontStyle: FontStyle.italic,
                              fontSize: 12),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.factory, color: Colors.white70),
                            SizedBox(width: 8),
                            Text(
                              "RenX Polska sp. z o.o.",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text("Konto założone 15.06.2023"),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text("Najstarsze dane w bazie: 16.07.2021"),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text("Konto połączone z 7 firmami",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
              ),
              DrawerTile(
                  onTap: () {}, text: "Zmień firmę", icon: Icons.switch_left),
              DrawerTile(
                  onTap: () {}, text: "Dodaj firmę", icon: Icons.add_business),
              const Divider(
                color: Color.fromARGB(117, 66, 66, 66),
              ),
              DrawerTile(
                  onTap: () => onTap(Screens.account),
                  text: "Edytuj konto",
                  icon: Icons.manage_accounts),
              DrawerTile(
                  onTap: () => onTap(Screens.account),
                  text: "Usuń konto",
                  icon: Icons.no_accounts),
              DrawerTile(
                  onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                  text: "Wyloguj",
                  icon: Icons.logout),
              const Divider(
                color: Color.fromARGB(117, 66, 66, 66),
              ),
              DrawerTile(
                  onTap: () => onTap(Screens.aboutUs),
                  text: "O nas",
                  icon: Icons.info),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: size.width * 0.85,
                    child: const Wrap(
                      spacing: 12,
                      children: [
                        Text("Polityka prywatności"),
                        Text("Regulamin"),
                        Text("Kontakt"),
                      ],
                    )),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  "Żyrek Ferrara Client App, version 1.0",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const DrawerTile(
      {super.key, required this.onTap, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
        size: 26,
      ),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      onTap: () => onTap(),
    );
  }
}
