import 'package:flutter/foundation.dart';
import 'package:money_tracker/authentication/login_screen.dart';
import 'package:money_tracker/documentation/documents_list.dart';
import 'package:money_tracker/financial/main_financial.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/main_screens/about_us.dart';
import 'package:money_tracker/main_screens/summary_screen.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/side_drawer.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Tracker',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: Color.fromARGB(255, 22, 41, 90),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 21)),
        drawerTheme: const DrawerThemeData(),
        colorScheme:
            const ColorScheme.light(secondary: Color.fromARGB(255, 22, 41, 90)),
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      home: ValueListenableBuilder<bool>(
        valueListenable: UserService().isAuthenticated,
        builder: (context, value, _) {
          if (value) {
            return const MyHomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
      supportedLocales: const [
        Locale('pl', ''),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int screenIndex = 0;
  Screens chosenScreen = Screens.summaryScreen;

  Widget mainScreen() {
    switch (chosenScreen) {
      case Screens.summaryScreen:
        return const SummaryScreen();
      case Screens.documents:
        return const DocumentList();
      case Screens.financial:
        return const MainFinancial();
      case Screens.account:
        return const AboutUs();
      case Screens.aboutUs:
        return const AboutUs();
    }
  }

  List<Widget> mainScreenList = [
    const SummaryScreen(),
    const DocumentList(),
    const MainFinancial(),
    const AboutUs()
  ];

  changeScreen(Screens newScreen) {
    setState(() {
      chosenScreen = newScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        116;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Panel Klienta",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      drawer: SideDrawer(
        onTap: (x) => changeScreen(x),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: gradientColors)),
        height: screenHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 100 : 0),
          child: mainScreenList[screenIndex],
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: screenIndex,
        onTap: (i) => setState(() => screenIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Strona główna"),
            selectedColor: Theme.of(context).colorScheme.secondary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.file_open),
            title: const Text("Dokumenty"),
            selectedColor: Theme.of(context).colorScheme.secondary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.attach_money_sharp),
            title: const Text("Finanse"),
            selectedColor: Theme.of(context).colorScheme.secondary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.account_circle),
            title: const Text("Profil"),
            selectedColor: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}

enum Screens { summaryScreen, documents, financial, account, aboutUs }
