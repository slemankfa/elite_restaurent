import 'package:elite/core/styles.dart';
import 'package:flutter/material.dart';

class DishDesciptionPage extends StatefulWidget {
  const DishDesciptionPage({super.key});

  @override
  State<DishDesciptionPage> createState() => _DishDesciptionPageState();
}

class _DishDesciptionPageState extends State<DishDesciptionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
  bool get wantKeepAlive => false;
}
