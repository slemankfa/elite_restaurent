import 'package:elite/core/styles.dart';
import 'package:flutter/material.dart';

class MealNatruationsPage extends StatefulWidget {
  const MealNatruationsPage({super.key});

  @override
  State<MealNatruationsPage> createState() => _MealNatruationsPageState();
}

class _MealNatruationsPageState extends State<MealNatruationsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Text(
              "قيد التطوير",
              style: Styles.mainTextStyle.copyWith(fontSize: 20),
            ))
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
