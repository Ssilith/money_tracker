import 'package:flutter/material.dart';

class AppDetails extends StatefulWidget {
  const AppDetails({super.key});

  @override
  State<AppDetails> createState() => _AppDetailsState();
}

class _AppDetailsState extends State<AppDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Panel Klienta",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
        Divider(
          color: Theme.of(context).colorScheme.secondary,
          thickness: 3,
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            InfoPageContainer(
              title: "Podsumowanie finansów twojej firmy",
              description:
                  "Pełen monitoring sytuacji finansowej spółki: składniki kosztów, poziom przychodów, rozliczenie podatków VAT, CIT oraz inne wskaźniki finansowe operte na twoich dokumentach finansowych. Wszystko w graficznej formie tabel, wykresów i z możliwością eksportu do pliku Excel.",
            ),
            SizedBox(width: 20),
            InfoPageContainer(
              title: "Spis całej dokumentacji finansowej",
              description:
                  "Przeglądaj wygodnie faktury, paragony, pożyczki i inne dokumenty finansowe. Panel klienta umożliwia dowolne filtrowanie wyników i grupuje dostawców oraz odbiorców, dostarcza również kompleksowe podsumowanie kontrahentów.",
            ),
            SizedBox(width: 20),
            InfoPageContainer(
              title: "Sprawozdania finansowe",
              description:
                  "Sprawdź swoje sprawozdania finansowe oraz uzyskaj prognozy na wybrany okres.",
            ),
          ],
        ),
      ],
    );
  }
}

class InfoPageContainer extends StatelessWidget {
  final String title;
  final String description;
  const InfoPageContainer(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 107, 107, 107),
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(60))),
      height: 500,
      width: 400,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ]),
    );
  }
}
