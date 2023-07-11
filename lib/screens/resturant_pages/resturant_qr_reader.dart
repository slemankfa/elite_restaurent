import 'dart:developer';
import 'dart:io';

import 'package:elite/core/helper_methods.dart';
import 'package:elite/core/styles.dart';
import 'package:elite/screens/resturant_pages/resturant_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../core/widgets/custom_outline_button.dart';
import '../../models/resturant_model.dart';
import '../../providers/cart_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// as permissionhandler;

class ResturantQrReader extends StatefulWidget {
  const ResturantQrReader(
      {super.key, this.resturantDetails, this.isFormAddOrderPage});

  @override
  State<ResturantQrReader> createState() => _ResturantQrReaderState();
  final ResturantModel? resturantDetails;
  final bool? isFormAddOrderPage;
}

class _ResturantQrReaderState extends State<ResturantQrReader>
    with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _isreadQrCode = false;
  bool _isAppPremmintaleyDelated = false;
  HelperMethods _helperMethods = HelperMethods();
  PermissionStatus? _status;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // setState(() {
      result = scanData;
      // log(result!.code.toString());
      if (result!.code == null) return;
      moveToResturantMenu(result!.code.toString());
      // if (result != null) return;

      // log(result!.rawBytes.toString());
      // log(result!.format.toString());
      // });
    });
  }

  moveToResturantMenu(String QrCode) async {
    if (!_isreadQrCode) {
      // first index resturant , second index for table id ;
      List<String> idsList = QrCode.split(",");
      if (idsList.length < 2) return;
      Provider.of<CartProvider>(context, listen: false).tableIdFromQr =
          idsList[1];
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResturanMenuPage(
                  resturantDetails: widget.resturantDetails,
                  isFormAddOrderPage: false,
                )),
      ).then((value) {
        _isreadQrCode = false;
      });
    }
    setState(() {
      _isreadQrCode = true;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    enableCmaeraPermissions();
    super.initState();
  }

  // check permissions when app is resumed
  // this is when permissions are changed in app settings outside of app
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log("AppLifecycleState.resumed");
      Permission.camera.status.then((status) => _updateStatus);
      // Permission
      //     .checkPermissionStatus(PermissionGroup.locationWhenInUse)
      //     .then(_updateStatus);
    }
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      // check status has changed
      setState(() {
        _status = status; // update
      });
    } else {
      if (status != PermissionStatus.granted) {
        Permission.camera.request().then((status) {
          log(status.toString());
        });
        // PermissionHandler().requestPermissions(
        //     [PermissionGroup.locationWhenInUse]).then(_onStatusRequested);
      }
    }
  }

  enableCmaeraPermissions() async {
    try {
      var status = await Permission.camera.status;
      if (status.isDenied) {
        log("camera is denied");

        // We didn't ask for permission yet or the permission has been denied before but not permanently.
      } else if (status == PermissionStatus.permanentlyDenied) {
        log("[log] PermissionStatus.permanentlyDenied");
        setState(() {
          _isAppPremmintaleyDelated = true;
        });
      }
      log(status.toString());
      await Permission.camera.request();
      // Permission.camera.status.asStream().map((event) {
      //   log("From stream : " + event.toString());
      // });
    } catch (e) {}
  }

  enableCameraFromSettings() async {
    log("enableCameraFromSettings");
    await _helperMethods.openAppSettingToEnable();
    bool status = await Permission.camera.isGranted;
    log(status.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        children: [
          _buildQrView(context),
          if (_isAppPremmintaleyDelated)
            Center(
              child: Container(
                margin: EdgeInsets.all(16),
                child: CustomOutlinedButton(
                    label: "Enable Camera From Settings",
                    isIconVisible: false,
                    onPressedButton: () async {
                      await enableCameraFromSettings();
                      // await showAllowLocationDilog(context: context);
                    },
                    rectangleBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    icon: Container(),
                    backGroundColor: Styles.mainColor,
                    borderSide: const BorderSide(color: Styles.mainColor),
                    textStyle: Styles.mainTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          Positioned(
              left: 20,
              top: 20,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Styles.mainColor,
          borderRadius: 10,
          borderLength: 30,
          overlayColor: const Color.fromARGB(96, 0, 0, 0),
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('no Permission')),
      // );
    }
  }
}
