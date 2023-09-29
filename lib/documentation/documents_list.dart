import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/last_documents.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'package:table_calendar/table_calendar.dart';

class DocumentList extends StatefulWidget {
  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  DateTime selectedDay = DateTime.now();
  int? selectedFilter;
  bool view = true;
  Future? getDocs;
  bool isCalendarView = true;
  List<dynamic> selectedDayTransactions = [];
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    getDocs = TransactionService().getAllTransactionsForUser(user.id!);
    super.initState();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: mainSwitch(),
        ),
        if (isCalendarView)
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 6),
            child: Container(
              alignment: Alignment.center,
              height: 40,
              child: TextField(
                controller: search,
                cursorColor: Theme.of(context).colorScheme.secondary,
                onSubmitted: (value) {
                  setState(() {
                    search.text = value;
                  });
                },
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
        FutureBuilder(
            future: getDocs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Indicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Wystąpił błąd. Spróbuj ponownie później.'));
              } else {
                List documents = snapshot.data!;
                return isCalendarView
                    ? buildListView(documents)
                    : buildCalendar(documents);
              }
            }),
      ],
    );
  }

  List mapDocumentsToDay(List<dynamic> documents, DateTime day) {
    return documents.where((document) {
      DateTime docDate = DateTime.parse(document['date']);
      return docDate.day == day.day &&
          docDate.month == day.month &&
          docDate.year == day.year;
    }).toList();
  }

  ListView buildListView(List<dynamic> documents) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        if (matchesSearchCriteria(documents[index])) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: DocumentContainer(
                document: documents[index], width: size.width * 0.94),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  bool matchesSearchCriteria(dynamic document) {
    String searchTextUpper = search.text.toUpperCase();
    if (document['category']['name'].toUpperCase().contains(searchTextUpper)) {
      return true;
    }
    DateTime docDate = DateTime.parse(document['date']);
    String formattedDate = DateFormat('yyyy-MM-dd').format(docDate);
    if (formattedDate.contains(search.text)) {
      return true;
    }
    if (document['amount'].toString().contains(search.text)) {
      return true;
    }
    return false;
  }

  Widget buildCalendar(List<dynamic> documents) {
    Size size = MediaQuery.of(context).size;
    selectedDayTransactions = mapDocumentsToDay(documents, selectedDay);
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        TableCalendar(
          locale: 'pl_PL',
          focusedDay: selectedDay,
          firstDay: DateTime(DateTime.now().year - 10),
          lastDay: DateTime(DateTime.now().year + 10),
          eventLoader: (day) {
            return mapDocumentsToDay(documents, day);
          },
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          onDaySelected: (day, events) {
            setState(() {
              selectedDay = day;
              selectedDayTransactions = mapDocumentsToDay(documents, day);
            });
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableGestures: AvailableGestures.all,
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            todayDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 38, 174, 108),
                      shape: BoxShape.circle),
                  width: 8.0,
                  height: 8.0,
                );
              }
              return null;
            },
          ),
        ),
        if (selectedDayTransactions.isNotEmpty)
          ...selectedDayTransactions
              .map((transaction) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DocumentContainer(
                        document: transaction, width: size.width * 0.94),
                  ))
              .toList()
      ],
    );
  }

  Widget mainSwitch() {
    return AnimatedToggleSwitch<bool>.dual(
      current: isCalendarView,
      first: true,
      second: false,
      borderColor: Colors.black,
      borderWidth: 1,
      height: 40,
      iconRadius: 70,
      onChanged: (b) {
        setState(() {
          isCalendarView = b;
        });
      },
      onTap: () {
        setState(() {
          isCalendarView = !isCalendarView;
        });
      },
      colorBuilder: (b) => b
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.secondary,
      iconBuilder: (value) => !value
          ? const Icon(
              Icons.calendar_month,
              size: 26,
            )
          : const Icon(
              Icons.list,
              size: 26,
            ),
      textBuilder: (value) => !value
          ? const Center(
              child: Text(
              'ZMIEŃ NA LISTĘ',
              style: TextStyle(fontSize: 14),
            ))
          : const Center(
              child: Text(
              'ZMIEŃ NA KALENDARZ',
              style: TextStyle(fontSize: 14),
            )),
    );
  }
}
