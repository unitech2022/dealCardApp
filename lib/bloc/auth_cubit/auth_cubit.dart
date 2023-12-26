import 'dart:async';
import 'dart:convert';

import 'package:deal_card/ui/cards_screen/cards_screen.dart';
import 'package:deal_card/ui/orders_screen/orders_screen.dart';
import 'package:deal_card/ui/otp_screen/otp_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import '../../../../core/enums/loading_status.dart';
import '../../../../core/helpers/helper_functions.dart';
import '../../../../core/utils/api_constatns.dart';
import '../../../../core/utils/utils.dart';
import '../../core/utils/app_model.dart';
import '../../models/response_register.dart';
import '../../models/user_response.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);

// ** startTimer
  int start = 60;
  Timer? timer;

  void startTimer() {
    start = 60;
    emit(state.copyWith(timerCount: 60));
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start == 0) {
          timer.cancel();
          emit(state.copyWith(timerCount: 0));
        } else {
          start--;
          emit(state.copyWith(timerCount: start));
        }
      },
    );
  }

// ** register
  registerUser(
      {context, userName, fullName, email, role, city, titleBar, type}) async {
    showUpdatesLoading(context);
    emit(state.copyWith(registerUserState: RequestState.loading));

    var request =
    http.MultipartRequest('POST', Uri.parse(ApiConstants.signUpPath));
    request.fields.addAll({
      'userName': userName,
      'FullName': fullName,
      'Email': email,
      'Password': 'Abc123',
      'Role': "user",
      'Address': city
    });

    http.StreamedResponse response = await request.send();

    if (kDebugMode) {
      print("${response.statusCode} ======> loginUser");
    }
    if (response.statusCode == 200) {
      String jsonDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonDataString);
      ResponseRegister responseRegister = ResponseRegister.fromJson(jsonData);

      print("success"+responseRegister.message);
      Navigator.of(context).pop();
      postSmsCode(code:responseRegister.message,phone: userName);
      pushPage(context,
          OtpScreen(phoneNumber: userName,
            codeSend: responseRegister.message,
            titleBar: titleBar,
            type: type,));
      emit(state.copyWith(registerUserState: RequestState.loaded));
    } else {
      Navigator.of(context).pop();

      emit(state.copyWith(registerUserState: RequestState.error));
    }
  }

// ** resendCode
  Future resendCode({userName, code, context}) async {
    if (timer!.isActive) {
      timer!.cancel();
    }
    showUpdatesLoading(context);

    emit(state.copyWith(resendCodeState: RequestState.loading));
    var url = Uri.parse('https://www.kwtsms.com/API/send/');
    var response = await http.post(url, body: {
      'username': 'imaginespa',
      'password': '67H\$kkD4*5',
      "sender": "KWT-SMS",
      "mobile": "$userName,$userName", "lang": "3", "message":code+ " كود التحقق لتطبيق  Recovery Zone هو ".tr()
    });
    if (response.statusCode == 200) {
      pop(context);
      showTopMessage(
          context: context,
          customBar: CustomSnackBar.success(
              backgroundColor: Colors.green,
              message: "تم ارسال الكود مرة أخرى",
              textStyle: const TextStyle(fontSize: 16, color: Colors.white)));
      startTimer();
      emit(state.copyWith(resendCodeState: RequestState.loaded));
    } else {
      pop(context);
      showTopMessage(
          context: context,
          customBar: CustomSnackBar.error(
              backgroundColor: Colors.red,
              message: "حدث خطأ يرجي اعادة المحاولة",
              textStyle: const TextStyle(fontSize: 16, color: Colors.white)));

      emit(state.copyWith(resendCodeState: RequestState.error));
    }
  }

  ///** */ login method
  Future userLogin({userName, context, role, code, titleBar, type}) async {
    bool internetResult = await hasInternet();
    showUpdatesLoading(context);
    emit(state.copyWith(
      loginUserState: RequestState.loading,
    ));
    if (internetResult) {
      var request =
      http.MultipartRequest('POST', Uri.parse(ApiConstants.loginPath));
      request.fields.addAll({
        'DeviceToken': 'ffffffff',
        'UserName': userName,
        "code": code.toString(),
      });

      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("${response.statusCode} ======> loginUser");
      }

      if (response.statusCode == 200) {
        String jsonDataString = await response.stream.bytesToString();
        final jsonData = jsonDecode(jsonDataString);
        UserResponse userResponseModel = UserResponse.fromJson(jsonData);

        //  token = "Bearer ${userResponseModel.token}";


        // // currentUser.role = role;
        // // currentUser.deviceToken = userResponseModel.user!.deviceToken;
        // // currentUser.token = token;
        // // currentUser.status = userResponseModel.user!.status;
        // // currentUser.userName = userResponseModel.user!.userName;

        // // print("token" + token + currentUser!.userName);
        await saveToken(userResponseModel.user!.id, userResponseModel.token!);
        AppModel.userId = userResponseModel.user!.id;
        AppModel.token = userResponseModel.token!;

        if (timer!.isActive) {
          timer!.cancel();
        }
        pop(context);
        //todo : go to payment
        if (type == 0) {
          print("ffflfflfl 232");
          pushPage(context, CardsScreen(titleBar: titleBar));
        }
        else if (type == 2) {
          pushPage(context, OrdersScreen());
          print("ffflfflfl rr");
        } else {
          pop(context);
          pop(context);
          print("ffflfflfl gfbg");
        }
        emit(state.copyWith(
            loginUserState: RequestState.loaded,
            userResponseModel: userResponseModel));
      } else {
        pop(context);

        emit(state.copyWith(
          loginUserState: RequestState.error,
        ));
      }
    } else {
      pop(context);
      showTopMessage(
          context: context,
          customBar: CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "لا يوجد اتصال بالانترنت".tr(),
            textStyle: TextStyle(
                fontFamily: "font", fontSize: 16, color: Colors.white),
          ));
      emit(state.copyWith(registerUserState: RequestState.noInternet));
    }
  }


  Future<void> postSmsCode({code , phone}) async {
    var url = Uri.parse('https://www.kwtsms.com/API/send/');
    var response = await http.post(url, body: {
      'username': 'imaginespa',
      'password': '67H\$kkD4*5',
      "sender": "KWT-SMS",
      "mobile": "$phone,$phone", "lang": "3", "message":code+ " كود التحقق لتطبيق  Recovery Zone هو ".tr()
    });
    print(response.body);
  }


}
