import 'package:bot_toast/bot_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class LuncherHelper {
  static final LuncherHelper _validationHelper = LuncherHelper._internal();

  LuncherHelper._internal();

  factory LuncherHelper() {
    return _validationHelper;
  }

  Future<void> launchPhoneCall(String phoneNumber) async {
    if (!await launchUrl(Uri.parse("tel://$phoneNumber"))) {
      BotToast.showText(text: "لا يمكن الوصول الي رقم لهاتف");
    }
  }

  Future<void> launchWebsiteUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      BotToast.showText(text: "لا يمكن فتح الصفحة");
    }
  }
  // void launchSocial(String url, String fallbackUrl) async {
  //   // Don't use canLaunch because of fbProtocolUrl (fb://)
  //   try {
  //     bool launched = await urlLuncer.launch(url,
  //         forceSafariVC: false, forceWebView: false);
  //     // if (!launched) {
  //     //   await urlLuncer.launch(fallbackUrl,
  //     //       forceSafariVC: false, forceWebView: false);
  //     // }
  //   } catch (e) {
  //     print(e.toString());
  //     // await urlLuncer.launch(fallbackUrl,
  //     //     forceSafariVC: false, forceWebView: false);
  //   }
  // }

  // void launchURL(String sa) async {
  //   // const url = 'https://flutter.io';
  //   if (await urlLuncer.canLaunch(sa)) {
  //     await urlLuncer.launch(sa);
  //   } else {
  //     throw 'Could not launch $sa';
  //   }
  // }

  // Future<void> launchContactUrl(String url) async {
  //   // print("url" + url);
  //   if (await urlLuncer.canLaunch(url)) {
  //     await urlLuncer.launch(
  //       url,
  //       forceSafariVC: false,
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // void launchEmailURL(String email) async {
  //   print(email);
  //   final Uri params = Uri(
  //     scheme: 'mailto',
  //     path: email ?? "",
  //   );
  //   String url = params.toString();
  //   if (await urlLuncer.canLaunch(url)) {
  //     await urlLuncer.launch(
  //       url,
  //       forceSafariVC: false,
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // void launchWhatsApp({
  //   @required String phone,
  //   @required String message,
  // }) async {
  //   print("lunchwhatsapp");
  //   String url() {
  //     if (Platform.isIOS) {
  //       return "https://wa.me/$phone/?text=${Uri.parse(message)}";
  //     } else {
  //       return "whatsapp://send?phone=" + phone + "&text= ";
  //       // "whatsapp://send?phone=$phone&text=${Uri.encodeFull(message)}";
  //       // return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
  //     }
  //   }

  //   if (await urlLuncer.canLaunch(url())) {
  //     await urlLuncer.launch(url(), forceSafariVC: false);
  //   } else {
  //     throw 'Could not launch ${url()}';
  //   }
  // }

  // void openMyAppInStore(BuildContext context) async {
  //   try {
  //     String storeLink = "";
  //     if (Platform.isIOS) {
  //       storeLink = "https://asalni.page.link/asalni-ios";
  //     } else {
  //       storeLink = "https://asalni.page.link/asalnii";
  //     }
  //     final size = MediaQuery.of(context).size;
  //     Share.share(storeLink,
  //         sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
  //         subject: "قم بمشاركة التطبيق");
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
