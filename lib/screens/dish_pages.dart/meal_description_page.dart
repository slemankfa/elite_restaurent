import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
          children: [
            FlutterLogo(),
            Placeholder(),
            Placeholder(),
            Placeholder(),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
