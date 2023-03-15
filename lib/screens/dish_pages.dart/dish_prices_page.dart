import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DishPricesPage extends StatefulWidget {
  const DishPricesPage({super.key});

  @override
  State<DishPricesPage> createState() => _DishPricesPageState();
}

class _DishPricesPageState extends State<DishPricesPage>  with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Placeholder(),
            Placeholder(),
            Placeholder(),
             FlutterLogo(),
              FlutterLogo(),
          ],
        ),
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
