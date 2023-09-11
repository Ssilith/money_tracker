import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/example_data.dart';

class LastDocuments extends StatefulWidget {
  const LastDocuments({super.key});

  @override
  State<LastDocuments> createState() => _LastDocumentsState();
}

class _LastDocumentsState extends State<LastDocuments> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kIsWeb)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Ostatnie dokumenty",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        SizedBox(
          height: 174,
          width: kIsWeb ? size.width - 200 : size.width,
          child: CarouselSlider.builder(
              itemCount: dataTemplate.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return DocumentContainer(
                    document: dataTemplate[itemIndex],
                    width: kIsWeb ? size.width - 200 : (size.width * 0.8));
              },
              options: CarouselOptions(
                  autoPlay: true,
                  animateToClosest: false,
                  initialPage: 0,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 0.8,
                  enableInfiniteScroll: true)),
        ),
      ],
    );
  }
}

class DocumentContainer extends StatelessWidget {
  final double width;
  final Document document;
  const DocumentContainer({
    super.key,
    required this.document,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: kIsWeb ? 20 : 5, horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        // width: ((size.width - 200) * 0.2),
        decoration: BoxDecoration(
          color: Colors.white54,
          // boxShadow: const [
          //   BoxShadow(
          //     color: Color.fromARGB(255, 107, 107, 107),
          //     offset: Offset(5, 5),
          //     blurRadius: 10,
          //   ),
          // ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      documentName(document.kind),
                      style: const TextStyle(
                          fontSize: 9, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      document.documentNumber,
                      style: const TextStyle(
                          fontSize: 9, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                  child: AutoSizeText(
                    document.client,
                    maxLines: 2,
                    minFontSize: 10,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                // const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: (width - 40) * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currencyFormat(document.currency)
                                .format(document.totalGrossPln),
                            style: const TextStyle(
                                height: 1,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.red),
                          ),
                          const Text(
                            "BRUTTO",
                            style: TextStyle(
                                height: 1.1,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: (width - 40) * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "VAT",
                                style: TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                currencyFormat(document.currency).format(
                                    document.totalGrossPln -
                                        document.totalNetPln),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "NETTO",
                                style: TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                currencyFormat(document.currency)
                                    .format(document.totalNetPln),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 20),
                    Text(
                      DateFormat("dd.MM.yyyy").format(document.dueDate),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                PaymentStatusChip(
                  isPaid: document.paymentState,
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
      //width: 140,
      height: 30,
      decoration: BoxDecoration(
          color: isPaid ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(45)),
      child: Row(children: [
        Icon(isPaid ? Icons.check_circle : Icons.cancel_rounded, size: 16),
        const SizedBox(width: 5),
        Text(
          isPaid ? "Opłacone" : "Nieopłacone",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )
      ]),
    );
  }
}
