import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'global.dart';

class LastDocuments extends StatefulWidget {
  const LastDocuments({super.key});

  @override
  State<LastDocuments> createState() => _LastDocumentsState();
}

class _LastDocumentsState extends State<LastDocuments> {
  Future? lastTenTransaction;

  @override
  void initState() {
    lastTenTransaction =
        TransactionService().getLastTenTransactionsForUser(user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width,
          child: FutureBuilder(
              future: lastTenTransaction,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Indicator();
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Wystąpił błąd. Spróbuj ponownie później.'));
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nie znaleziono transakcji.'));
                } else {
                  List documents = snapshot.data!;
                  return CarouselSlider.builder(
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
                        return DocumentContainer(
                            document: documents[itemIndex],
                            width: size.width * 0.8);
                      },
                      options: CarouselOptions(
                          autoPlay: true,
                          height: 85,
                          animateToClosest: false,
                          initialPage: 0,
                          scrollDirection: Axis.horizontal,
                          viewportFraction: 0.8,
                          enableInfiniteScroll: true));
                }
              }),
        ),
      ],
    );
  }
}

class DocumentContainer extends StatelessWidget {
  final double width;
  final dynamic document;
  final bool showDescription;
  const DocumentContainer({
    super.key,
    required this.document,
    required this.width,
    this.showDescription = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(249, 243, 246, 254),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Text(
                    document['category']['name'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(int.parse(
                            document['category']['color'] ?? "0xFF000000"))),
                  ),
                ),
                Text(
                  currencyFormat('PLN').format(document['amount']),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(Icons.calendar_month, size: 20),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd')
                          .format(DateTime.parse(document['date'])),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                PaymentStatusChip(
                    isPaid: document['type'] == 'Przychód'
                        ? 0
                        : document['type'] == 'Wydatek'
                            ? 1
                            : 2,
                    data: document['transactionType'])
              ],
            ),
            showDescription && document['description'] != ""
                ? Text(document['description'])
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

class PaymentStatusChip extends StatelessWidget {
  final int isPaid;
  final Map? data;
  const PaymentStatusChip({super.key, required this.isPaid, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 30,
      decoration: BoxDecoration(
          color: isPaid == 0
              ? const Color.fromARGB(255, 38, 174, 108)
              : isPaid == 1
                  ? const Color.fromARGB(255, 241, 81, 70)
                  : Color(int.parse(data!['color'] ?? "0xFF000000")),
          borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Icon(
            isPaid == 0
                ? Icons.check_circle
                : isPaid == 1
                    ? Icons.cancel_rounded
                    : parseToIconData(data!['icon']),
            size: 16),
        const SizedBox(width: 5),
        Text(
          isPaid == 0
              ? "Przychód"
              : isPaid == 1
                  ? "Wydatek"
                  : data!['name'],
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ]),
    );
  }
}

parseToIconData(int datapoint) {
  IconData icons = IconData(datapoint, fontFamily: 'MaterialIcons');
  return icons;
}
