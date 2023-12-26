import 'package:deal_card/core/layout/app_fonts.dart';
import 'package:deal_card/core/utils/app_model.dart';
import 'package:deal_card/core/widgets/texts.dart';
import 'package:deal_card/models/setting_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  final SettingModel seting;
  const PrivacyScreen({super.key, required this.seting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
              centerTitle: true,
              backgroundColor: const Color(0xffFEFEFE),
              elevation: 0,
              automaticallyImplyLeading: true,

              title: Texts(
                  title:  "الشروط والأحكام".tr(),
                  family: AppFonts.taB,
                  size: 18,
                  widget: FontWeight.bold),
              // actions: [
              //  IconAlertWidget()
              // ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppModel.lang==AppModel.arLang?seting.valueAr:seting.valueEng,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily:  AppFonts.taB,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                     ),
                  ),
                ],
              ),
            ),
              // actions: [
              //  IconAlertWidget()
              // ],
            
    );
  }
}