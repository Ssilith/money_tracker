import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/main.dart';

class ChangeCompanyScreen extends StatefulWidget {
  const ChangeCompanyScreen({super.key});

  @override
  State<ChangeCompanyScreen> createState() => _ChangeCompanyScreenState();
}

class _ChangeCompanyScreenState extends State<ChangeCompanyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.secondary,
      //backgroundColor: Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        title: const Text("Zmień firmę"),
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          const Column(
            children: [
              Image(image: AssetImage('assets/doc_1.png')),
              Image(image: AssetImage('assets/doc_2.png')),
            ],
          ),
          ListView.builder(
            itemCount: CompanyDataTemplate.length,
            itemBuilder: (context, index) {
              return CompanyContainer(company: CompanyDataTemplate[index]);
            },
          ),
        ],
      ),
    );
  }
}

class CompanyContainer extends StatelessWidget {
  final CompanyClass company;
  const CompanyContainer({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          width: size.width * 0.9,
          decoration: withShadow(Colors.white70, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Opacity(
                  opacity: 0.85,
                  child: Flag.fromString(
                    company.country,
                    height: 30,
                    width: 40,
                    borderRadius: 5,
                    flagSize: FlagSize.size_4x3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                company.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1,
                    fontSize: 18),
              ),
              Text(
                company.type,
                style: const TextStyle(color: Colors.black, fontSize: 11),
              ),
              Row(children: [
                Icon(MdiIcons.mapMarker, size: 12, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  company.address,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w500),
                )
              ]),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CompanyNumberInfoBox(name: "KRS", content: company.krs),
                  CompanyNumberInfoBox(name: "NIP", content: company.nip),
                  CompanyNumberInfoBox(name: "REGON", content: company.regon),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CompanyNumberInfoBox extends StatelessWidget {
  final String name;
  final String content;
  const CompanyNumberInfoBox(
      {super.key, required this.name, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(content,
            style: const TextStyle(
                height: 0.5,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 10)),
        Text(name,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10))
      ],
    );
  }
}

class CompanyClass {
  CompanyClass(this.name, this.type, this.krs, this.regon, this.nip,
      this.country, this.address, this.category);
  final String name;
  final String type;
  final String krs;
  final String regon;
  final String nip;
  final String country;
  final String address;
  final String category;
}

List CompanyDataTemplate = [
  CompanyClass(
      "RenX Polska",
      "Spółka z ograniczoną odpowiedzialnością",
      "0000902067",
      "389023212",
      "8992899550",
      "PL",
      "ul. Przyjaźni 6/U5, 53-030 Wrocław",
      "operacyjna"),
  CompanyClass(
      "Syma Polska",
      "Spółka z ograniczoną odpowiedzialnością spółka komandytowa",
      "0000719556",
      "369526986",
      "8992841579",
      "PL",
      "ul. Przyjaźni 6/U5, 53-030 Wrocław",
      "operacyjna"),
  CompanyClass(
      "X2 Energy",
      "Spółka z ograniczoną odpowiedzialnością",
      "0000965315",
      "521712705",
      "8992922438",
      "PL",
      "ul. Przyjaźni 6/U5, 53-030 Wrocław",
      "celowa"),
  CompanyClass(
      "RenX Polska",
      "Spółka z ograniczoną odpowiedzialnością",
      "0000902067",
      "389023212",
      "8992899550",
      "PL",
      "ul. Przyjaźni 6/U5, 53-030 Wrocław",
      "operacyjna"),
  CompanyClass(
      "Syma Polska",
      "Spółka z ograniczoną odpowiedzialnością spółka komandytowa",
      "0000719556",
      "369526986",
      "8992841579",
      "PL",
      "ul. Przyjaźni 6/U5, 53-030 Wrocław",
      "operacyjna"),
  CompanyClass(
      "X2 Energy",
      "Spółka z ograniczoną odpowiedzialnością",
      "0000965315",
      "521712705",
      "8992922438",
      "PL",
      "ul. Przyjaźni 6/U5, 53-030 Wrocław",
      "celowa"),
];
