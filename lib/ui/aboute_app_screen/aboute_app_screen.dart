import 'package:deal_card/core/utils/app_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../core/layout/app_fonts.dart';
import '../../core/utils/strings.dart';
import '../../core/widgets/texts.dart';

class AbouteAppScreen extends StatelessWidget {
  const AbouteAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffFEFEFE),
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Texts(
            title: "عن التطبيق".tr(),
            family: AppFonts.taB,
            size: 18,
            widget: FontWeight.bold),
        // actions: [
        //  IconAlertWidget()
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Html(
            data: AppModel.lang==AppModel.arLang?abouteAppAr:abouteAppEng,
          ),
        ),


      ),
    );
  }
}
