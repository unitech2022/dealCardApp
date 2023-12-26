import 'package:deal_card/bloc/business_owners_cubit/business_owners_cubit.dart';
import 'package:deal_card/models/business_owners_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'dart:ui' as ui;
import '../../bloc/auth_cubit/auth_cubit.dart';
import '../../core/helpers/helper_functions.dart';
import '../../core/layout/app_fonts.dart';
import '../../core/layout/palette.dart';
import '../../core/utils/strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/text_field_widget.dart';
import '../../core/widgets/texts.dart';

class BusinessOwnersScreen extends StatefulWidget {
  const BusinessOwnersScreen({super.key});

  @override
  State<BusinessOwnersScreen> createState() => _BusinessOwnersScreenState();
}

class _BusinessOwnersScreenState extends State<BusinessOwnersScreen> {
  final _controllerFirstName = TextEditingController();
  final _controllerLastName = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerNameMarket = TextEditingController();
  final _controllerNumberInvoice = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerFirstName.dispose();
    _controllerLastName.dispose();
    _controllerPhone.dispose();
    _controllerNameMarket.dispose();
    _controllerNumberInvoice.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: const BackButton(
          color: Palette.mainColor,
        ),
        title: Texts(
          title: "تسجيل صاحب العمل".tr(),
          family: AppFonts.caB,
          size: 20,
          textColor: Palette.mainColor,
          height: 2.0,
        ),
        // actions: const [IconAlertWidget()],
      ),
      body: BlocBuilder<BusinessOwnersCubit, BusinessOwnersState>(
        builder: (context, state) {
          return Padding(
            padding:
            const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 30),
            child: SingleChildScrollView(
              child: Column(children: [
                Texts(
                    title: "الرجاء ادخال البيانات الخاصة بالفاتورة".tr(),
                    family: AppFonts.taM,
                    size: 14,
                    textColor: const Color(0xff44494E),
                    widget: FontWeight.normal),
                const SizedBox(
                  height: 20,
                ),

                TextFieldWidget(
                  controller: _controllerFirstName,
                  hint: "الاسم الأول".tr(),
                  icon: const SizedBox(),
                  type: TextInputType.text,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFieldWidget(
                  controller: _controllerLastName,
                  hint: 'الاسم الأخير'.tr(),
                  icon: const SizedBox(),
                  type: TextInputType.text,
                ),
                const SizedBox(
                  height: 15,
                ),
                Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: Row(
                    children: [
                      sizedWidth(8),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset("assets/images/kuwait.png",fit: BoxFit.cover,width: 25,height: 25,)),
                      sizedWidth(4),
                      Texts(
                        title: Strings.codeNumber,
                        textColor: Color(0xff464646),
                        size: 14,
                        widget: FontWeight.bold,
                        algin: TextAlign.center, family: AppFonts.taB,),
                      sizedWidth(8),
                      Expanded(
                        child: TextFieldWidget(
                          controller: _controllerPhone,
                          hint: 'رقم الهاتف'.tr(),
                          isPhone: true,
                          icon: const SizedBox(),
                          type: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFieldWidget(
                  controller: _controllerNameMarket,
                  hint: "اسم المتجر".tr(),
                  isPhone: true,
                  icon: const SizedBox(),
                  type: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 15,
                ),
                // **
                TextFieldWidget(
                  controller: _controllerNumberInvoice,
                  hint: "رقم الفاتورة".tr(),
                  isPhone: true,
                  icon: const SizedBox(),
                  type: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 45,
                ),
                CustomButton(
                  radius: 25,
                  elevation: 10,
                  backgroundColor: Palette.mainColor,
                  titleColor: Colors.white,
                  title: "ارسال".tr(),
                  onPressed: () {
                    BusinessOwnersModel businessModel = BusinessOwnersModel(
                        id: 0,
                        firstName: _controllerFirstName.text,
                        lastName: _controllerLastName.text,
                        numberInvoice: _controllerNumberInvoice.text,
                        phone: _controllerPhone.text,
                        nameMarket: _controllerNameMarket.text,
                        status: 0,
                        createAt: "createdAt", userId: 'not');
                    if (isValidate(context)) {
                      BusinessOwnersCubit.get(context).addBusinessOwners(businessModel,context: context,
                      );
                    }
                  },
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  bool isValidate(BuildContext context) {
    if (_controllerFirstName.text.isEmpty || _controllerFirstName.text == "") {
      showTopMessage(
          context: context,
          customBar: CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "اكتب اسم الاول".tr(),
            textStyle: const TextStyle(
                fontFamily: "font", fontSize: 16, color: Colors.white),
          ));
      return false;
    } else if (_controllerLastName.text.isEmpty ||
        _controllerLastName.text == "") {
      showTopMessage(
          context: context,
          customBar: CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "اكتب الاسم الأخير".tr(),
            textStyle: const TextStyle(
                fontFamily: "font", fontSize: 16, color: Colors.white),
          ));
      return false;
    }


    else if (_controllerPhone.text.isEmpty || _controllerPhone.text == "") {
      showTopMessage(
          context: context,
          customBar: CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "اكتب رقم الهاتف".tr(),
            textStyle: const TextStyle(
                fontFamily: "font", fontSize: 16, color: Colors.white),
          ));
      return false;
    } else if (_controllerNameMarket.text.isEmpty ||
        _controllerNameMarket.text == "") {
      showTopMessage(
          context: context,
          customBar: CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "اكتب اسم المتجر".tr(),
            textStyle: const TextStyle(
                fontFamily: "font", fontSize: 16, color: Colors.white),
          ));
      return false;
    } else if (_controllerNumberInvoice.text.isEmpty ||
        _controllerNumberInvoice.text == "") {
      showTopMessage(
          context: context,
          customBar: CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "اكتب رقم الفاتورة".tr(),
            textStyle: const TextStyle(
                fontFamily: "font", fontSize: 16, color: Colors.white),
          ));
      return false;
    } else {
      return true;
    }
  }
}
