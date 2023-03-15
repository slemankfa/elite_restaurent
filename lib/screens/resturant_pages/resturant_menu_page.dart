import 'package:elite/screens/resturant_pages/resturant_menu_item_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/styles.dart';

class ResturanMenuPage extends StatefulWidget {
  const ResturanMenuPage({super.key});

  @override
  State<ResturanMenuPage> createState() => _ResturanMenuPageState();
}

class _ResturanMenuPageState extends State<ResturanMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Styles.grayColor),
        title: Text(
          "Menu",
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResturantMenuItemListPage(
                        itemName: "Pizza",
                      )),
                );
              },
              leading: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(8),
                  color: Styles.listTileBorderColr,
                ),
                child: SvgPicture.asset(
                  "assets/icons/pizza.svg",
                  width: 20,
                  height: 20,
                ),
              ),
              title: Text(
                "Pizza",
                style: Styles.mainTextStyle
                    .copyWith(color: Styles.grayColor, fontSize: 18),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Styles.grayColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
