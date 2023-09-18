import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/main.dart';

class SetBudgetForm extends StatelessWidget {
  const SetBudgetForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  surfaceTintColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  leading: Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(),
                            ),
                          );
                        },
                        child: Icon(MdiIcons.arrowLeftCircle,
                            size: 40, color: Colors.white),
                      );
                    },
                  ),
                  automaticallyImplyLeading: true,
                  title: const Text("Formularz ustawiania budżetu",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  centerTitle: true,
                  floating: true,
                  snap: true,
                ),
              ];
            },
            body: Placeholder()));
  }
}
