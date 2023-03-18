import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../core/styles.dart';

class PointsPage extends StatefulWidget {
  const PointsPage({super.key});

  @override
  State<PointsPage> createState() => _PointsPageState();
  static const routeName = "/points-page";
}

class _PointsPageState extends State<PointsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Styles.grayColor),
        title: Text(
          "Points",
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Styles.mainColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Styles.mainColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "956 Points",
                      style: Styles.mainTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Make an order more than  ',
                              style: Styles.mainTextStyle.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              )),
                          TextSpan(
                            text: '100',
                            style: Styles.mainTextStyle.copyWith(
                                fontSize: 16,
                                color: Styles.progressColor,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: ' JOD and take the chance to get ',
                              style: Styles.mainTextStyle.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              )),
                          TextSpan(
                            text: '1000',
                            style: Styles.mainTextStyle.copyWith(
                                fontSize: 16,
                                color: Styles.starGradientColor,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: ' points',
                              style: Styles.mainTextStyle.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              ListTile(
                title: Text('Redeem',
                    style: Styles.mainTextStyle.copyWith(
                        fontSize: 18,
                        color: Styles.grayColor,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'Converting points into money, you can use the converted points to pay through the app.',
                    style: Styles.mainTextStyle.copyWith(
                        fontSize: 14,
                        color: Styles.midGrayColor,
                        fontWeight: FontWeight.normal)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Styles.midGrayColor,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ListTile(
                title: Text('Donate',
                    style: Styles.mainTextStyle.copyWith(
                        fontSize: 18,
                        color: Styles.grayColor,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'Donate money to a charitable entity or organization.',
                    style: Styles.mainTextStyle.copyWith(
                        fontSize: 14,
                        color: Styles.midGrayColor,
                        fontWeight: FontWeight.normal)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Styles.midGrayColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
