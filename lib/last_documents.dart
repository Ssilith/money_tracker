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
                } else if (!snapshot.hasData) {
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
                          height: 120,
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
  const DocumentContainer({
    super.key,
    required this.document,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        // constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
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
            SizedBox(
              child: Text(
                document['category']['name'],
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(int.parse(
                        document['category']['color'] ?? "0xFFFFFFFF"))),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Cena",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  currencyFormat('PLN').format(document['amount']),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.red),
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
                  isPaid: document['type'] == 'Przychód',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentStatusChip extends StatelessWidget {
  final bool isPaid;
  const PaymentStatusChip({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 30,
      decoration: BoxDecoration(
          color: isPaid ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Icon(isPaid ? Icons.check_circle : Icons.cancel_rounded, size: 16),
        const SizedBox(width: 5),
        Text(
          isPaid ? "Przychód" : "Wydatek",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ]),
    );
  }
}
