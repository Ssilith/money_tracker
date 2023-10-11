import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_tracker/authentication/login_screen.dart';
import 'package:money_tracker/documentation/documents_list.dart';
import 'package:money_tracker/expenses/new_expense_form.dart';
import 'package:money_tracker/financial/main_financial.dart';
import 'package:money_tracker/main_screens/exchange_rates.dart';
import 'package:money_tracker/main_screens/summary_screen.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/initialization_service.dart';
import 'package:money_tracker/resources/notification_service.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/side_drawer.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await InitializationService.initializeApp();
  await Future.delayed(const Duration(seconds: 1));
  await initializeDateFormatting();
  FlutterNativeSplash.remove();
  tz.initializeTimeZones();
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
            backgroundColor: Color(0xFF005b3d),
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
        Locale('pl'),
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
      case Screens.transactions:
        return const DocumentList();
      case Screens.financial:
        return const MainFinancial();
      case Screens.currencies:
        return const ExchangeRates();
    }
  }

  List<Widget> mainScreenList = [
    const SummaryScreen(),
    const DocumentList(),
    const MainFinancial(),
    const ExchangeRates(),
  ];

  changeScreen(Screens newScreen) {
    setState(() {
      chosenScreen = newScreen;
    });
  }

  final notificationService = NotificationService();
  @override
  void initState() {
    super.initState();
    _requestExactAlarmPermission();
  }

  _requestExactAlarmPermission() async {
    // ...
    await notificationService.scheduleMonthlyNotification(
        DateTime.now().day, DateTime.now().hour, DateTime.now().minute + 2);
    // ...
  }

  // Future<void> _requestExactAlarmPermission() async {
  //   if (user.notifications ?? true) {
  //     final notificationService = NotificationService();
  //     notificationService.scheduleMonthlyNotification(11, 20, 40);
  //     print('Scheduling notification for:');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Scaffold(
      drawer: SideDrawer(
        onTap: (x) => changeScreen(x),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const NewExpenseForm(),
            ),
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: const CircleBorder(),
        // elevation: 0,
        child: const Icon(Icons.add),
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
            padding: const EdgeInsets.symmetric(horizontal: 0),
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
            title: const Text("Transakcje"),
            selectedColor: Theme.of(context).colorScheme.secondary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.attach_money_sharp),
            title: const Text("Finanse"),
            selectedColor: Theme.of(context).colorScheme.secondary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(FontAwesomeIcons.arrowTrendUp, size: 18),
            title: const Text("Kursy walut"),
            selectedColor: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}

enum Screens { summaryScreen, transactions, financial, currencies }
