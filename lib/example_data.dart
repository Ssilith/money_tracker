class Document {
  Document(this.documentNumber, this.kind, this.totalGrossPln, this.totalNetPln,
      this.dueDate, this.paymentState, this.client, this.isCost, this.currency);
  final String documentNumber;
  final DocumentKind kind;
  final double totalGrossPln;
  final double totalNetPln;
  final DateTime dueDate;
  final bool paymentState;
  final String client;
  final bool isCost;
  final String currency;
}

enum DocumentKind { receipt, invoice, proform, vatMarginInvoice }

String documentName(DocumentKind documentKind) {
  switch (documentKind) {
    case DocumentKind.receipt:
      return "Paragon";
    case DocumentKind.invoice:
      return "Faktura";
    case DocumentKind.proform:
      return "Faktura proforma";
    case DocumentKind.vatMarginInvoice:
      return "Faktura Marża";
  }
}

List<Document> dataTemplate = [
  Document(
      "07/04/2023",
      DocumentKind.invoice,
      1555.7,
      1190,
      DateTime(2023, 4, 30),
      true,
      'Biuro Rachunkowe DOMINO Ewa Brzezińska',
      true,
      "PLN"),
  Document(
      "06/04/2023",
      DocumentKind.invoice,
      24,
      18,
      DateTime(2023, 4, 28),
      true,
      'Kancelaria Notarialna Monika Barczuk Iwona Łacna Spółka Cywilna',
      true,
      "PLN"),
  Document("05/04/2023", DocumentKind.invoice, 6396, 5200,
      DateTime(2023, 4, 28), false, 'blsk. mateusz skalski', true, "PLN"),
  Document("04/04/2023", DocumentKind.invoice, 27020.01, 27020.01,
      DateTime(2023, 4, 30), true, 'EMD International', true, "EUR"),
  Document(
      "03/04/2023",
      DocumentKind.invoice,
      127,
      115.67,
      DateTime(2023, 4, 30),
      true,
      'Restauracja Concordia Sp. z o.o.',
      true,
      "PLN"),
  Document("02/04/2023", DocumentKind.invoice, 48.9, 69.76,
      DateTime(2023, 4, 30), true, 'STAMPLEKS.PL Sp. z o.o.', true, "PLN"),
  Document("01/04/2023", DocumentKind.invoice, 2337, 1900,
      DateTime(2023, 4, 30), false, 'IMHO Paweł Kurpisz', true, "PLN"),
  Document("11/04/2023", DocumentKind.invoice, 123, 100, DateTime(2023, 4, 30),
      true, 'Biuro Tłumaczeń WELT', true, "PLN"),
  Document("12/04/2023", DocumentKind.invoice, 272.49, 221.29,
      DateTime(2023, 4, 30), true, 'P4 Sp. z o.o.', true, "PLN"),
  Document("13/04/2023", DocumentKind.invoice, 190.9, 89.35,
      DateTime(2023, 4, 30), true, 'Grupa olx sp. z o.o.', true, "PLN"),
  Document("14/04/2023", DocumentKind.invoice, 311.78, 265.9,
      DateTime(2023, 4, 30), true, 'E.Leclerc', true, "PLN"),
  Document("15/04/2023", DocumentKind.invoice, 150, 150, DateTime(2023, 4, 30),
      true, 'Safety First Joanna Tomal', false, "PLN"),
  Document("16/04/2023", DocumentKind.invoice, 49.98, 40.63,
      DateTime(2023, 4, 30), false, 'WIMPOL Sp. z o.o.', true, "PLN"),
];

class MonthResult {
  MonthResult(this.monthName, this.revenue, this.cost, this.month,
      this.prevRevenue, this.prevCost);
  final int month;
  final String monthName;
  final double revenue;
  final double prevRevenue;
  final double cost;
  final double prevCost;
}

final List<MonthResult> financialDataTamplate = [
  MonthResult("Styczeń", 32012, 45600, 1, 28312, 33200),
  MonthResult("Luty", 38200, 48960, 2, 29013, 29000),
  MonthResult("Marzec", 89000, 46520, 3, 38500, 31520),
  MonthResult("Kwiecień", 46200, 52130, 4, 48250, 36200),
  MonthResult("Maj", 70000, 60312, 5, 33560, 89600),
  MonthResult("Czerwiec", 101203, 58123, 6, 42560, 36200),
];

groupByClient() {
  List clients = [];
  for (var i in dataTemplate) {
    int index = clients.indexWhere((element) => element['name'] == i.client);

    if (index > -1) {
      clients[index]['docs'].add(i);
    } else {
      Map clientInfo = {};
      clientInfo['name'] = i.client;
      clientInfo['docs'] = [i];
      clients.add(clientInfo);
    }
  }
  return clients;
}
