import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:deal_card/bloc/cards_cubit/cards_cubit.dart';
import 'package:deal_card/core/layout/app_fonts.dart';
import 'package:deal_card/core/utils/app_model.dart';
import 'package:deal_card/core/widgets/texts.dart';
import 'package:deal_card/models/card_model.dart';
import 'package:deal_card/models/market_model.dart';
import 'package:deal_card/models/user_response.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import '../../core/enums/loading_status.dart';
import '../../core/helpers/helper_functions.dart';
import '../../core/shimmer/shimmer_widget.dart';
import '../../core/utils/api_constatns.dart';
import '../daetails_market_screen/show_image_screen/show_image_screen.dart';

class ScanQRCodeScreen extends StatefulWidget {
  final CardModel card;
  final String code;
  final MarketModel market;
  final UserModel userModel;

  const ScanQRCodeScreen(
      {Key? key, required this.card, required this.code, required this.market, required this.userModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  int status = 0;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CardsCubit.get(context).isScan = false;
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardsCubit, CardsState>(
      builder: (context, state) {
        return CardsCubit.get(context).isScan
            ? state.scanCodeState == RequestState.loaded
                ? Scaffold(
                    appBar: AppBar(
                      elevation: 0,
                      automaticallyImplyLeading: true,
                    ),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.asset(
                                "assets/images/success.png",
                                width: 150,
                                height: 150,
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Texts(
                            title: "عملية ناجحة".tr(),
                            family: AppFonts.taB,
                            size: 28,
                            widget: FontWeight.bold,
                            textColor: Colors.green,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey,width: .8),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    RowDataScan(title: "اسم الكارت  : ".tr(),value: AppModel.lang == AppModel.arLang
                                        ? widget.card.nameAr
                                        : widget.card.nameAr,),
                                    GestureDetector(
                                      onTap: (){
                                        pushPage(context, ShowImageScreen(images:widget.card.image));
                                      },
                                      child: Container(
                                        height: 45,
                                        width: 45,
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // borderRadius: BorderRadius.circular(10),
                                            border:
                                            Border.all(color: Colors.green, width: 2)),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            ApiConstants.imageUrl(widget.card.image),
                                            width: double.infinity,
                                            height: double.infinity,
                                            placeholder: (context, url) => getShimmerWidget(
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.grey),
                                                )),
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                RowDataScan(title: "نوع الكارت  :".tr(),value:typsCard[widget.card.typeDate].tr() ,),
                                SizedBox(height: 10,),
                                RowDataScan(title: "اسم المتجر  : ".tr(),value: AppModel.lang == AppModel.arLang
                                    ? widget.market.nameAr
                                    : widget.market.nameAr,),
                                SizedBox(height: 10,),
                                RowDataScan(title: "اسم المستفيد  : ".tr(),value:widget.userModel.fullName
                                   ),
                                SizedBox(height: 10,),
                                RowDataScan(title: "رقم الهاتف  : ".tr(),value:widget.userModel.userName
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Scaffold(
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 150,
                            height: 150,
                            child: Image.asset(
                              "assets/images/close.png",
                              width: 150,
                              height: 150,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Texts(
                          title: "حدث خطآ الرجاء المحاولة مرة أخري".tr(),
                          family: AppFonts.taB,
                          size: 18,
                          widget: FontWeight.bold,
                          textColor: Colors.red,
                        )
                      ],
                    ),
                  )
            : _buildQrView(context);
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.stopCamera();
        print(result!.code);
        if (result!.code == widget.code) {
          CardsCubit.get(context).scanQrcode(
              context: context,
              cardId: widget.card.id,
              marketId: widget.market.id);
        } else {
          showTopMessage(
              context: context,
              customBar: CustomSnackBar.error(
                backgroundColor: Colors.red,
                message: "الكود غير صحيح".tr(),
                textStyle: TextStyle(
                    fontFamily: "font", fontSize: 16, color: Colors.white),
              ));
        }
      });
    });
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      ),
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class RowDataScan extends StatelessWidget {
  final String title,value;
  const RowDataScan({
    super.key, required this.title, required this.value,

  });



  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Texts(
          title:title,
          family: AppFonts.taB,
          size: 18,
          widget: FontWeight.bold,
          textColor: Colors.grey,
        ),
        SizedBox(
          width: 30,
        ),
        Texts(
          title: value,
          family: AppFonts.taB,
          size: 18,
          widget: FontWeight.bold,
          textColor: Colors.black,
        ),
      ],
    );
  }
}
const typsCard =["سنوي",
 "شهري",
 "آسبوعي",
"يومي"];