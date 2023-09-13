import 'package:flutter/services.dart';
import 'package:money_tracker/create_document/create_document_global.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

privacyPolicyPdf() async {
  final Document pdf = Document();

  final fontData = await rootBundle.load("fonts/Tinos-Regular.ttf");
  final ttf = Font.ttf(fontData);

  final fontDataBold = await rootBundle.load("fonts/Tinos-Bold.ttf");
  final ttfbold = Font.ttf(fontDataBold);

  pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return SizedBox();
        }
        return Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(bottom: 20.0),
          child: Text('Polityka prywatności',
              style: TextStyle(fontWeight: FontWeight.bold, font: ttfbold)),
        );
      },
      footer: (Context context) {
        return Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(top: 20.0),
          child: Text('Stona ${context.pageNumber} z ${context.pagesCount}',
              style: TextStyle(fontWeight: FontWeight.bold, font: ttfbold)),
        );
      },
      build: (Context context) => [
            MyTitle(text: 'Polityka prywatności', ttf: ttf),
            MyParagraph(ttf: ttf, text: 'Ostatnio modyfikowane: 11.08.2023'),
            MyHeader(level: 1, text: 'Wprowadzenie', ttf: ttf),
            MyParagraph(
                ttf: ttf,
                text:
                    'Nasza polityka prywatności pomoże Ci zrozumieć, jakie informacje gromadzimy w Money Tracker, w jaki sposób Money Tracker je wykorzystuje i jakie masz możliwości wyboru. Firma Money Tracker stworzyła aplikację Money Tracker jako aplikację bezpłatną. Usługa ta jest świadczona przez firmę Money Tracker bezpłatnie i jest przeznaczona do użytku w stanie, w jakim się znajduje. Jeśli użytkownik zdecyduje się na korzystanie z naszej Usługi, wyraża zgodę na gromadzenie i wykorzystywanie informacji zgodnie z niniejszą polityką. Gromadzone przez nas dane osobowe są wykorzystywane do świadczenia i ulepszania Usługi. Nie będziemy wykorzystywać ani udostępniać danych użytkownika nikomu, z wyjątkiem przypadków opisanych w niniejszej Polityce prywatności.'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Terminy użyte w niniejszej Polityce prywatności mają takie samo znaczenie jak w naszych Warunkach, które są dostępne na naszej stronie internetowej, chyba że w niniejszej Polityce prywatności określono inaczej.'),
            MyHeader(
                ttf: ttf,
                level: 1,
                text: 'Gromadzenie i wykorzystywanie informacji'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Aby zapewnić lepsze wrażenia podczas korzystania z naszej Usługi, możemy wymagać od użytkownika podania pewnych danych osobowych, w tym między innymi imienia i nazwiska użytkownika, adresu e-mail, płci, lokalizacji, zdjęć. Informacje, o które prosimy, będą przez nas przechowywane i wykorzystywane zgodnie z opisem w niniejszej polityce prywatności.'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Aplikacja korzysta z usług stron trzecich, które mogą gromadzić informacje służące do identyfikacji użytkownika.'),
            MyHeader(ttf: ttf, level: 1, text: 'Pliki cookie'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Pliki cookie to pliki zawierające niewielką ilość danych, które są powszechnie używane jako anonimowy unikalny identyfikator. Są one wysyłane do przeglądarki użytkownika z odwiedzanej strony internetowej i przechowywane w pamięci wewnętrznej urządzenia.'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Ta usługa nie wykorzystuje plików cookie w sposób jawny. Aplikacja może jednak korzystać z kodu i bibliotek stron trzecich, które wykorzystują pliki "cookie" do gromadzenia informacji i ulepszania swoich usług. Użytkownik może zaakceptować lub odrzucić te pliki cookie i wiedzieć, kiedy plik cookie jest wysyłany na jego urządzenie. Jeśli użytkownik zdecyduje się odrzucić nasze pliki cookie, może nie być w stanie korzystać z niektórych części tej Usługi.'),
          ]));
  pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return SizedBox();
        }
        return Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(bottom: 20.0),
          child: Text('Polityka prywatności',
              style: TextStyle(fontWeight: FontWeight.bold, font: ttfbold)),
        );
      },
      footer: (Context context) {
        return Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(top: 20.0),
          child: Text('Stona ${context.pageNumber} z ${context.pagesCount}',
              style: TextStyle(fontWeight: FontWeight.bold, font: ttfbold)),
        );
      },
      build: (Context context) => [
            MyHeader(ttf: ttf, level: 1, text: 'Informacje o lokalizacji'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Niektóre usługi mogą wykorzystywać informacje o lokalizacji przesyłane z telefonów komórkowych użytkowników. Używamy tych informacji tylko w zakresie niezbędnym do korzystania z wyznaczonej usługi.'),
            MyHeader(ttf: ttf, level: 1, text: 'Informacje o urządzeniu'),
            MyParagraph(
                ttf: ttf,
                text:
                    'W niektórych przypadkach zbieramy informacje z urządzenia użytkownika. Informacje te będą wykorzystywane w celu świadczenia lepszych usług i zapobiegania oszustwom. Ponadto takie informacje nie będą zawierać danych umożliwiających identyfikację poszczególnych użytkowników.'),
            MyHeader(ttf: ttf, level: 1, text: 'Dostawcy usług'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Możemy zatrudniać firmy i osoby trzecie z następujących powodów:'),
            MyBulletPoint(
                ttf: ttf, text: 'Aby ułatwić korzystanie z naszej Usługi;'),
            MyBulletPoint(
                ttf: ttf, text: 'Aby świadczyć Usługę w naszym imieniu;'),
            MyBulletPoint(
                ttf: ttf, text: 'Aby świadczyć usługi związane z Usługą;'),
            MyBulletPoint(
                ttf: ttf,
                text:
                    'Aby pomóc nam w analizie sposobu korzystania z naszej Usługi.'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Chcemy poinformować użytkowników tej Usługi, że te osoby trzecie mają dostęp do Twoich Danych Osobowych. Powodem jest wykonywanie zadań przypisanych im w naszym imieniu. Są one jednak zobowiązane do nieujawniania ani niewykorzystywania tych informacji w żadnym innym celu.'),
            MyHeader(ttf: ttf, level: 1, text: 'Bezpieczeństwo'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Cenimy zaufanie, jakim darzysz nas, przekazując nam swoje Dane Osobowe, dlatego staramy się stosować komercyjnie akceptowalne środki ich ochrony. Należy jednak pamiętać, że żadna metoda transmisji przez Internet lub metoda elektronicznego przechowywania danych nie jest w 100% bezpieczna i niezawodna, a my nie możemy zagwarantować jej całkowitego bezpieczeństwa.'),
          ]));
  pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return SizedBox();
        }
        return Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(bottom: 20.0),
          child: Text('Polityka prywatności',
              style: TextStyle(fontWeight: FontWeight.bold, font: ttfbold)),
        );
      },
      footer: (Context context) {
        return Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(top: 20.0),
          child: Text('Stona ${context.pageNumber} z ${context.pagesCount}',
              style: TextStyle(fontWeight: FontWeight.bold, font: ttfbold)),
        );
      },
      build: (Context context) => [
            MyHeader(ttf: ttf, level: 1, text: 'Prywatność dzieci'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Usługi nie są skierowane do osób poniżej 13 roku życia. Nie zbieramy świadomie danych osobowych od dzieci poniżej 13 roku życia. W przypadku odkrycia, że dziecko poniżej 13 roku życia przekazało nam dane osobowe, natychmiast usuwamy je z naszych serwerów. Jeśli jesteś rodzicem lub opiekunem i wiesz, że Twoje dziecko przekazało nam dane osobowe, skontaktuj się z nami, abyśmy mogli podjąć niezbędne działania.'),
            MyHeader(
                ttf: ttf,
                level: 1,
                text: 'Zmiany w niniejszej Polityce prywatności'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Od czasu do czasu możemy aktualizować naszą Politykę prywatności. W związku z tym zaleca się okresowe sprawdzanie tej strony pod kątem wszelkich zmian. Powiadomimy użytkownika o wszelkich zmianach, publikując nową Politykę prywatności na tej stronie. Zmiany te wchodzą w życie natychmiast po ich opublikowaniu na tej stronie.'),
            MyHeader(ttf: ttf, level: 1, text: 'Kontakt'),
            MyParagraph(
                ttf: ttf,
                text:
                    'Jeśli masz jakiekolwiek pytania lub sugestie dotyczące naszej Polityki prywatności, nie wahaj się z nami skontaktować.'),
            MyParagraph(ttf: ttf, text: 'Dane kontaktowe:'),
            MyBulletPoint(ttf: ttf, text: 'E-mail: k.hajduk.wroclaw@gmail.com'),
          ]));

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
