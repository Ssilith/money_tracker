import 'package:flutter/material.dart';
import 'package:money_tracker/documentation/chip_filter.dart';
import 'package:money_tracker/last_documents.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/widgets/indicator.dart';

class DocumentList extends StatefulWidget {
  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  int? selectedFilter;
  bool view = true;
  Future? getDocs;

  @override
  void initState() {
    getDocs = TransactionService().getAllTransactionsForUser(user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < chipFilterList.length; i++)
                ChipFilter(
                  filterData: chipFilterList[i],
                  callback: () => setState(() {
                    selectedFilter = i;
                  }),
                  isSelected: i == selectedFilter,
                )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 6),
          child: Container(
            alignment: Alignment.center,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                  icon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).colorScheme.secondary)),
                  focusColor: Theme.of(context).colorScheme.secondary,
                  border: const OutlineInputBorder(),
                  hintText: "Szukaj"),
            ),
          ),
        ),
        SizedBox(
          height: size.height - 190,
          child: FutureBuilder(
              future: getDocs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Indicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Wystąpił błąd. Spróbuj ponownie później.'));
                } else {
                  List documents = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: DocumentContainer(
                            document: documents[index],
                            width: size.width * 0.94),
                      );
                    },
                  );
                }
              }),
        ),
      ],
    );
  }
}
