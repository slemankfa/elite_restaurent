import 'dart:developer';
import 'dart:io';

import 'package:elite/core/styles.dart';
import 'package:elite/screens/resturant_pages/resturant_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../models/resturant_model.dart';
import '../../providers/cart_provider.dart';

class ResturantQrReader extends StatefulWidget {
  const ResturantQrReader(
      {super.key, this.resturantDetails, this.isFormAddOrderPage});

  @override
  State<ResturantQrReader> createState() => _ResturantQrReaderState();
  final ResturantModel? resturantDetails;
  final bool? isFormAddOrderPage;
}

class _ResturantQrReaderState extends State<ResturantQrReader> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _isreadQrCode = false;

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
      moveToResturantMenu();
      // if (result != null) return;
      // log(result!.code.toString());

      // log(result!.rawBytes.toString());
      // log(result!.format.toString());
      // });
    });
  }

  moveToResturantMenu() async {
    if (!_isreadQrCode) {
      Provider.of<CartProvider>(context, listen: false).tableIdFromQr = "1";
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        children: [
          _buildQrView(context),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
