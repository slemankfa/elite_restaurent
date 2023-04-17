
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
        // handleStartUpLogic();
    super.initState();
    // initDynamicLinks();
  }
 
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   _context = context ;
    // });

    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}