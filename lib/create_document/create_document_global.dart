import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class MyTitle extends StatelessWidget {
  final String text;
  final Font ttf;

  MyTitle({
    required this.text,
    required this.ttf,
  });

  @override
  Widget build(Context context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, font: ttf),
      ),
    );
  }
}

class MyHeader extends StatelessWidget {
  final String text;
  final int level;
  final Font ttf;

  MyHeader({
    required this.text,
    this.level = 1,
    required this.ttf,
  });

  @override
  Widget build(Context context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 20 - level.toDouble(),
            fontWeight: FontWeight.bold,
            font: ttf),
      ),
    );
  }
}

class MyParagraph extends StatelessWidget {
  final String text;
  final Font ttf;

  MyParagraph({
    required this.text,
    required this.ttf,
  });

  @override
  Widget build(Context context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child:
          Text(text, textAlign: TextAlign.justify, style: TextStyle(font: ttf)),
    );
  }
}

class MyBulletPoint extends StatelessWidget {
  final String text;
  final Font ttf;

  MyBulletPoint({
    required this.text,
    required this.ttf,
  });

  @override
  Widget build(Context context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('• ', style: TextStyle(font: ttf)),
          Expanded(
            child: Text(text, style: TextStyle(font: ttf)),
          ),
        ],
      ),
    );
  }
}

class MyTableRow extends StatelessWidget {
  final List<String> data;
  final Font ttf;
  final PdfColor? colour;

  MyTableRow({
    required this.data,
    required this.ttf,
    this.colour,
  });

  @override
  Widget build(Context context) {
    return Table(
      defaultColumnWidth: FixedColumnWidth(1.0 / data.length),
      border: TableBorder.all(color: PdfColors.black),
      children: [
        TableRow(
          decoration: BoxDecoration(
              border: Border.all(
            color: PdfColors.black,
          )),
          children: data.map((item) {
            return Container(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                item,
                style: TextStyle(font: ttf, color: colour ?? PdfColors.black),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
