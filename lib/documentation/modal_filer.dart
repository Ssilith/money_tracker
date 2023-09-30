import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
  String? _sortCriteria;
  Set<String> _selectedCategories = {};
  late RangeValues _currentRangeValues;
  final RangeValues _initialRangeValues = const RangeValues(0, 50000);
  bool _showAmountSlider = false;
  bool _showCategoriesChoice = false;

  @override
  void initState() {
    _currentRangeValues = _initialRangeValues;
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
                  groupValue: _sortCriteria,
                  onChanged: (value) {
                    setModalState(() {
                      _sortCriteria = value;
                    });
                  },
                  title: const Text('Data rosnąco'),
                ),
                RadioListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: 'dateM',
                  groupValue: _sortCriteria,
                  onChanged: (value) {
                    setModalState(() {
                      _sortCriteria = value;
                    });
                  },
                  title: const Text('Data malejąco'),
                ),
                RadioListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: 'amountR',
                  groupValue: _sortCriteria,
                  onChanged: (value) {
                    setModalState(() {
                      _sortCriteria = value;
                    });
                  },
                  title: const Text('Kwota rosnąco'),
                ),
                RadioListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: 'amountM',
                  groupValue: _sortCriteria,
                  onChanged: (value) {
                    setModalState(() {
                      _sortCriteria = value;
                    });
                  },
                  title: const Text('Kwota malejąco'),
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
                  value: _showAmountSlider,
                  onChanged: (checked) {
                    setModalState(() {
                      _showAmountSlider = checked!;
                    });
                  },
                ),
                if (_showAmountSlider)
                  RangeSlider(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    inactiveColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.3),
                    values: _currentRangeValues,
                    min: _initialRangeValues.start,
                    max: _initialRangeValues.end,
                    onChanged: (RangeValues values) {
                      setModalState(() {
                        _currentRangeValues = values;
                      });
                    },
                    divisions: 2000,
                    labels: RangeLabels(
                      _currentRangeValues.start.round().toString(),
                      _currentRangeValues.end.round().toString(),
                    ),
                  ),
                CheckboxListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  title: const Text('Kategorii'),
                  value: _showCategoriesChoice,
                  onChanged: (checked) {
                    setModalState(() {
                      _showCategoriesChoice = checked!;
                    });
                  },
                ),
                SimpleDarkButton(
                    onPressed: () {
                      List docs = widget.originalDocs;
                      String? categoryId = _selectedCategories.isNotEmpty
                          ? _selectedCategories.first
                          : null;

                      double? minAmount =
                          _showAmountSlider ? _currentRangeValues.start : null;
                      double? maxAmount =
                          _showAmountSlider ? _currentRangeValues.end : null;
                      List filteredDocs = filterTransactions(
                          docs, minAmount, maxAmount, categoryId);

                      if (_sortCriteria != null) {
                        filteredDocs =
                            sortTransactions(filteredDocs, _sortCriteria!);
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

  List filterTransactions(List transactions, double? minAmount,
      double? maxAmount, String? categoryId) {
    return transactions.where((t) {
      if (minAmount != null && t['amount'] < minAmount) return false;
      if (maxAmount != null && t['amount'] > maxAmount) return false;
      if (categoryId != null && t['category']['_id'] != categoryId) {
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
}
