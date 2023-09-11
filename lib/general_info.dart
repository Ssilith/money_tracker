import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/change_company/change_company_screen.dart';

class GeneralInfo extends StatelessWidget {
  const GeneralInfo({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          //color: Colors.black38,
          borderRadius: BorderRadius.circular(10)),
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "RenX Polska",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                height: 0.8,
                color: Colors.white70),
          ),
          const Text(
            "spółka z ograniczoną odpowiedzialnością",
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white70),
          ),
          const Text(
            "Ostatnie zaksięgowane dokumenty z dnia 30.05.2023",
            style: TextStyle(
                fontSize: 11, fontStyle: FontStyle.italic, color: Colors.white),
          ),
          const AdressRow(adress: "ul. Przyjaźni 6/U5, 53-030 Wrocław"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BasicInfoRow(name: "KRS", content: "0000902067"),
                  BasicInfoRow(name: "NIP", content: "8992899550"),
                  BasicInfoRow(name: "REGON", content: "38902321200000"),
                ],
              ),
              InkWell(
                onTap: () {},
                child: const Column(
                  children: [
                    Icon(
                      Icons.downloading,
                      color: Colors.white70,
                    ),
                    SizedBox(
                        width: 150,
                        child: Text(
                          "Pobierz wydruk informacji aktualnych z KRS",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.white70),
                        ))
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const BankAccountTile(
              name: "Konto PLN - PKO",
              number: "41 1020 5242 0000 2002 0518 1369"),
          const SizedBox(height: 8),
          const BankAccountTile(
              name: "Konto EUR - PKO",
              number: "87 1020 5242 0000 2602 0523 0687"),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ChangeCompanyScreen(),
                    ),
                  );
                },
                child: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Zmień firmę",
                        style: TextStyle(color: Colors.yellow),
                      ),
                      Icon(
                        MdiIcons.arrowRightThin,
                        color: Colors.yellow,
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class BasicInfoRow extends StatelessWidget {
  final String name;
  final String content;
  const BasicInfoRow({super.key, required this.name, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            name,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white60),
          ),
        ),
        Text(
          content,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ],
    );
  }
}

class AdressRow extends StatelessWidget {
  final String adress;
  const AdressRow({super.key, required this.adress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            MdiIcons.mapMarker,
            color: Colors.white60,
          ),
          const SizedBox(width: 5),
          Text(
            adress,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class BankAccountTile extends StatelessWidget {
  final String name;
  final String number;
  const BankAccountTile({super.key, required this.name, required this.number});

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      color: Colors.white60,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      blur: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                number,
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              )
            ],
          ),
          InkWell(
            onTap: () {},
            child: SizedBox(
              width: 100,
              child: Text(
                "Przejdź do aplikacji banku",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
