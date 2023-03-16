import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MealNatruationsPage extends StatefulWidget {
  const MealNatruationsPage({super.key});

  @override
  State<MealNatruationsPage> createState() => _MealNatruationsPageState();
}

class _MealNatruationsPageState extends State<MealNatruationsPage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50,),
              FlutterLogo(
                size: 40,
              ),
            Placeholder(),
            Placeholder(),
             FlutterLogo(),
              FlutterLogo(),
            Placeholder(),
          ],
        ),
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive =>true;
}
