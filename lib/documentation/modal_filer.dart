import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/models/transaction.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/category_service.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'package:money_tracker/widgets/simple_dark_button.dart';

class ModalFilter extends StatefulWidget {
  final Function(List filteredDocs) onFilterApplied;
  final List originalDocs;
  final String? initialSortCriteria;
  final Set<String> initialSelectedCategories;
  final Set<String> initialSelectedMonths;
  final RangeValues? initialRangeValues;

  const ModalFilter({
    super.key,
    required this.onFilterApplied,
    required this.originalDocs,
    this.initialSortCriteria,
    this.initialSelectedCategories = const {},
    this.initialSelectedMonths = const {},
    this.initialRangeValues,
  });

  @override
  State<ModalFilter> createState() => _ModalFilterState();
}

class _ModalFilterState extends State<ModalFilter> {
  String? sortCriteria;
  Set<String> selectedCategories = {};
  Set<String> selectedMonths = {};
  RangeValues? currentRangeValues;
  bool showAmountSlider = false;
  bool showCategoriesChoice = false;
  bool showMonthChoice = false;
  Future? getCategoriesNames;
  Future? getBiggestAmount;
  Map? userChoices;

  @override
  void initState() {
    getCategoriesNames = CategoryService().getCategoriesNames(user.id!);
    getBiggestAmount =
        TransactionService().getBiggestTransactionAmount(user.id!);
    sortCriteria = widget.initialSortCriteria ?? 'dateM';
    selectedCategories = widget.initialSelectedCategories;
    selectedMonths = widget.initialSelectedMonths;
    currentRangeValues = widget.initialRangeValues;
    showAmountSlider = widget.initialRangeValues != null;
    showCategoriesChoice = widget.initialSelectedCategories.isNotEmpty;
    showMonthChoice = widget.initialSelectedMonths.isNotEmpty;
    super.initState();
  }

  Map<String, dynamic> getUserSelections() {
    Map<String, dynamic> selections = {};

    if (sortCriteria != null) {
      selections['Sorting'] = sortCriteria;
    }

    if (showAmountSlider) {
      selections['Amount Range'] = {
        'Min': currentRangeValues?.start,
        'Max': currentRangeValues?.end
      };
    }

    if (selectedCategories.isNotEmpty) {
      selections['Categories'] = selectedCategories.toList();
    }

    if (selectedMonths.isNotEmpty) {
      selections['Months'] = selectedMonths.toList();
    }

    return selections;
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
                Text("Sortuj",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                RadioListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: 'dateR',
                  groupValue: sortCriteria,
                  onChanged: (value) {
                    setModalState(() {
                      sortCriteria = value;
                    });
                  },
                  title: const Text('Data rosnąco'),
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
                  title: const Text('Data malejąco'),
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
                  title: const Text('Kwota rosnąco'),
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
                  title: const Text('Kwota malejąco'),
                ),
                Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 1.2,
                    height: 10),
                Text("Filtruj",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                CheckboxListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  title: const Text('Kwota'),
                  value: showAmountSlider,
                  onChanged: (checked) {
                    setModalState(() {
                      showAmountSlider = checked!;
                      if (!showAmountSlider) {
                        currentRangeValues = null;
                      }
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
                  title: const Text('Kategorie'),
                  value: showCategoriesChoice,
                  onChanged: (checked) {
                    setModalState(() {
                      showCategoriesChoice = checked!;
                      if (!showCategoriesChoice) {
                        selectedCategories.clear();
                      }
                    });
                  },
                ),
                if (showCategoriesChoice) buildCategoryButtons(),
                CheckboxListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  title: const Text('Miesięce'),
                  value: showMonthChoice,
                  onChanged: (checked) {
                    setModalState(() {
                      showMonthChoice = checked!;
                      if (!showMonthChoice) {
                        selectedMonths.clear();
                      }
                    });
                  },
                ),
                if (showMonthChoice) buildMonthButtons(),
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
                      if (filteredDocs.isEmpty) {
                        showAmountSlider = false;
                        showCategoriesChoice = false;
                        showMonthChoice = false;
                        currentRangeValues = null;
                        selectedCategories.clear();
                        selectedMonths.clear();
                        sortCriteria = 'dateM';
                      }
                      widget.onFilterApplied(filteredDocs);
                      Navigator.of(context).pop(getUserSelections());
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
      if (selectedMonths.isNotEmpty && !isDateInSelectedMonths(t['date'])) {
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
        } else if (snapshot.hasError || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('Wystąpił błąd. Spróbuj ponownie później.'));
        } else {
          List<String> categories = snapshot.data;
          return Wrap(
            spacing: 5.0,
            children: categories.map((category) {
              return ChoiceChip(
                label: Text(
                  category,
                ),
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                    color: selectedCategories.contains(category)
                        ? Colors.white
                        : Colors.black),
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

  Widget buildMonthButtons() {
    return Wrap(
      spacing: 5.0,
      children: months.map((category) {
        return ChoiceChip(
          label: Text(
            category,
          ),
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
              color: selectedMonths.contains(category)
                  ? Colors.white
                  : Colors.black),
          selected: selectedMonths.contains(category),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedMonths.add(category);
              } else {
                selectedMonths.remove(category);
              }
            });
          },
        );
      }).toList(),
    );
  }

  int getMonthFromDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return parsedDate.month;
  }

  bool isDateInSelectedMonths(String date) {
    int monthNumber = getMonthFromDate(date);
    for (String month in selectedMonths) {
      if (monthNameToNumber[month] == monthNumber) {
        return true;
      }
    }
    return false;
  }
}
