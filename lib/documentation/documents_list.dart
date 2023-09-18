import 'package:flutter/material.dart';
import 'package:money_tracker/documentation/chip_filter.dart';

class DocumentList extends StatefulWidget {
  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  int? selectedFilter;

  bool view = true;

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    // double screenHeight = size.height -
    //     MediaQuery.of(context).padding.top -
    //     MediaQuery.of(context).padding.bottom -
    //     116;
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
                    // groupByClient();
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
        // SizedBox(
        //   height: screenHeight - 94,
        //   child:
        //       ListView.builder(
        //     padding: EdgeInsets.zero,
        //     itemCount: dataTemplate.length,
        //     itemBuilder: (context, index) {
        //       return DocumentContainer(
        //           document: dataTemplate[index], width: size.width * 0.94);
        //     },
        //   ),

        // ),
      ],
    );
  }
}
