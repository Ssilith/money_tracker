import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/models/transaction.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/category_service.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'package:money_tracker/widgets/simple_dark_button.dart';

class ModalFilter extends StatefulWidget {
  final Function(List filteredDocs) onFilterApplied;
  final List originalDocs;

  const ModalFilter(
      {super.key, required this.onFilterApplied, required this.originalDocs});

  @override
  State<ModalFilter> createState() => _ModalFilterState();
}

class _ModalFilterState extends State<ModalFilter> {
  String? sortCriteria;
  Set<String> selectedCategories = {};
  RangeValues? currentRangeValues;
  bool showAmountSlider = false;
  bool showCategoriesChoice = false;
  Future? getCategoriesNames;
  Future? getBiggestAmount;

  @override
  void initState() {
    getCategoriesNames = CategoryService().getCategoriesNames(user.id!);
    getBiggestAmount =
        TransactionService().getBiggestTransactionAmount(user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sortuj za pomocą:',
                  style: TextStyle(fontSize: 18),
                ),
                RadioListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: 'dateR',
                  groupValue: sortCriteria,
                  onChanged: (value) {
                    setModalState(() {
                      sortCriteria = value;
                    });
                  },
                  title: const Text('Daty rosnąco'),
                ),
                RadioListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: 'dateM',
                  groupValue: sortCriteria,
                  onChanged: (value) {
                    setModalState(() {
                      sortCriteria = value;
                    });
                  },
                  title: const Text('Daty malejąco'),
                ),
                RadioListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: 'amountR',
                  groupValue: sortCriteria,
                  onChanged: (value) {
                    setModalState(() {
                      sortCriteria = value;
                    });
                  },
                  title: const Text('Kwoty rosnąco'),
                ),
                RadioListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: 'amountM',
                  groupValue: sortCriteria,
                  onChanged: (value) {
                    setModalState(() {
                      sortCriteria = value;
                    });
                  },
                  title: const Text('Kwoty malejąco'),
                ),
                Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 1.2,
                    height: 10),
                const Text(
                  'Filtruj za pomocą:',
                  style: TextStyle(fontSize: 18),
                ),
                CheckboxListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  title: const Text('Kwoty'),
                  value: showAmountSlider,
                  onChanged: (checked) {
                    setModalState(() {
                      showAmountSlider = checked!;
                    });
                  },
                ),
                if (showAmountSlider)
                  FutureBuilder(
                      future: getBiggestAmount,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Indicator();
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text(
                                  'Wystąpił błąd. Spróbuj ponownie później.'));
                        } else {
                          Transaction transaction = snapshot.data;
                          double maxAmount = transaction.amount!;

                          currentRangeValues ??= RangeValues(0, maxAmount);
                          ;
                          return RangeSlider(
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            inactiveColor: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.3),
                            values: currentRangeValues!,
                            min: 0,
                            max: maxAmount,
                            onChanged: (RangeValues values) {
                              setModalState(() {
                                currentRangeValues = values;
                              });
                            },
                            divisions: 2000,
                            labels: RangeLabels(
                              currentRangeValues!.start.round().toString(),
                              currentRangeValues!.end.round().toString(),
                            ),
                          );
                        }
                      }),
                CheckboxListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  title: const Text('Kategorii'),
                  value: showCategoriesChoice,
                  onChanged: (checked) {
                    setModalState(() {
                      showCategoriesChoice = checked!;
                    });
                  },
                ),
                if (showCategoriesChoice) buildCategoryButtons(),
                SimpleDarkButton(
                    onPressed: () {
                      List docs = widget.originalDocs;
                      double? minAmount =
                          showAmountSlider ? currentRangeValues!.start : null;
                      double? maxAmount =
                          showAmountSlider ? currentRangeValues!.end : null;
                      List filteredDocs =
                          filterTransactions(docs, minAmount, maxAmount);
                      if (sortCriteria != null) {
                        filteredDocs =
                            sortTransactions(filteredDocs, sortCriteria!);
                      }
                      widget.onFilterApplied(filteredDocs);
                      Navigator.of(context).pop();
                    },
                    title: "Zapisz")
              ],
            ),
          ),
        );
      },
    );
  }

  List sortTransactions(List transactions, String criteria) {
    if (criteria == 'dateR') {
      transactions.sort((a, b) =>
          DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
    } else if (criteria == 'dateM') {
      transactions.sort((a, b) =>
          DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
    } else if (criteria == 'amountR') {
      transactions.sort((a, b) => a['amount'].compareTo(b['amount']));
    } else if (criteria == 'amountM') {
      transactions.sort((a, b) => b['amount'].compareTo(a['amount']));
    }
    return transactions;
  }

  List filterTransactions(
      List transactions, double? minAmount, double? maxAmount) {
    return transactions.where((t) {
      if (minAmount != null && t['amount'] < minAmount) return false;
      if (maxAmount != null && t['amount'] > maxAmount) return false;
      if (selectedCategories.isNotEmpty &&
          !selectedCategories.contains(t['category']['name'])) {
        return false;
      }
      return true;
    }).toList();
  }

  Map<int, List> groupTransactionsByMonth(List transactions) {
    return groupBy(
      transactions,
      (transaction) => DateTime.parse(transaction['date']).month,
    );
  }

  Widget buildCategoryButtons() {
    return FutureBuilder(
      future: getCategoriesNames,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Indicator();
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Wystąpił błąd. Spróbuj ponownie później.'));
        } else {
          List<String> categories = snapshot.data;
          return Wrap(
            spacing: 5.0,
            children: categories.map((category) {
              return ChoiceChip(
                label: Text(category),
                selected: selectedCategories.contains(category),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedCategories.add(category);
                    } else {
                      selectedCategories.remove(category);
                    }
                  });
                },
              );
            }).toList(),
          );
        }
      },
    );
  }
}
