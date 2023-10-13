import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/models/notification.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/notification_service.dart';
import 'package:money_tracker/resources/user_service.dart';

class OnboardingPages extends StatefulWidget {
  const OnboardingPages({super.key});

  @override
  State<OnboardingPages> createState() => _OnboardingPagesState();
}

class _OnboardingPagesState extends State<OnboardingPages> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final notificationService = NotificationService();

  void _onIntroEnd(context) async {
    user.onboard = true;
    await UserService().updateUserInfo(user);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MyHomePage()),
    );
  }

  @override
  void initState() {
    setCyclicNotifications();
    super.initState();
  }

  setCyclicNotifications() async {
    if (user.notifications ?? false) {
      int id = 13;
      List<MyNotification> notif =
          await NotificationService().getNotifications(user.id!);
      for (MyNotification n in notif) {
        await notificationService.scheduleMonthlyNotification(
            n.date!.day, n.date!.hour, n.date!.minute, n.name!, id);
        id++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: bodyStyle,
        bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: Colors.white,
        imagePadding: EdgeInsets.zero,
        imageFlex: 3);

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,
      pages: [
        PageViewModel(
          title: "Steruj finansami!",
          body: "",
          image: SvgPicture.asset(
            'assets/logo.svg',
            width: size.width * 0.7,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Na kursie oszczędności!",
          body: "",
          image: SvgPicture.asset(
            'assets/nko.svg',
            width: size.width,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Niech pieniądze płyną!",
          body: "",
          image: SvgPicture.asset(
            'assets/npp.svg',
            width: size.width,
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.secondary,
      ),
      skip: Text('Pomiń',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary)),
      next: Icon(Icons.arrow_forward,
          color: Theme.of(context).colorScheme.secondary),
      done: Text('Zaczynamy!',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: const Color(0xFFBDBDBD),
        activeSize: const Size(22.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
