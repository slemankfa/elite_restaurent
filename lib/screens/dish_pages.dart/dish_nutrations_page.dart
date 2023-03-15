import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DishNatruatonsPage extends StatefulWidget {
  const DishNatruatonsPage({super.key});

  @override
  State<DishNatruatonsPage> createState() => _DishNatruatonsPageState();
}

class _DishNatruatonsPageState extends State<DishNatruatonsPage> with AutomaticKeepAliveClientMixin{
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
