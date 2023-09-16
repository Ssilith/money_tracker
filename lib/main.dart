import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_tracker/authentication/login_screen.dart';
import 'package:money_tracker/documentation/documents_list.dart';
import 'package:money_tracker/financial/main_financial.dart';
import 'package:money_tracker/main_screens/about_us.dart';
import 'package:money_tracker/main_screens/summary_screen.dart';
import 'package:money_tracker/resources/initialization_service.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/side_drawer.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await InitializationService.initializeApp();
  await Future.delayed(const Duration(seconds: 1));
  await initializeDateFormatting();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      title: 'Money Tracker',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: Color(0xFF005b3d),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 21)),
        drawerTheme: const DrawerThemeData(),
        colorScheme: const ColorScheme.light(secondary: Color(0xFF005b3d)),
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
      drawer: SideDrawer(
        onTap: (x) => changeScreen(x),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              surfaceTintColor: Theme.of(context).colorScheme.secondary,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.alignLeft,
                      size: 25,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              centerTitle: true,
              title: SvgPicture.asset('assets/logo.svg', height: 50),
              automaticallyImplyLeading: false,
              expandedHeight: 30,
              floating: true,
              snap: true,
            )
          ];
        },
        body: SizedBox(
          height: screenHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 100 : 0),
            child: mainScreenList[screenIndex],
          ),
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
