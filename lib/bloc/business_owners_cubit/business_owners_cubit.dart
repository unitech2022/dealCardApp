import 'package:bloc/bloc.dart';
import 'package:deal_card/core/utils/utils.dart';
import 'package:deal_card/models/business_owners_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../core/enums/loading_status.dart';
import '../../core/helpers/helper_functions.dart';
import '../../core/utils/api_constatns.dart';

part 'business_owners_state.dart';

class BusinessOwnersCubit extends Cubit<BusinessOwnersState> {
  BusinessOwnersCubit() : super(BusinessOwnersState());


  static BusinessOwnersCubit get(context) =>
      BlocProvider.of<BusinessOwnersCubit>(context);

  // ** subscribe Card
  Future addBusinessOwners(BusinessOwnersModel model, {context}) async {
    showUpdatesLoading(context);
    emit(const BusinessOwnersState(addBusinessOwnersState: RequestState.loading));

    bool hasInternetResult = await hasInternet();

    if (hasInternetResult) {
      var request = http.MultipartRequest('POST',
          Uri.parse('${ApiConstants.baseUrl}/business/add-BusinessOwner'));

      request.fields.addAll({
        'userId': "not",
        'FirstName': model.firstName,
        'LastName': model.lastName,
        'Phone': model.phone,
        'NameMarket': model.nameMarket,
        'NumberInvoice': model.numberInvoice
      });
      http.StreamedResponse response = await request.send();

      if (kDebugMode) {
        print("${response.statusCode}=======> add-BusinessOwner");
      }
      if (response.statusCode == 200) {
        // String jsonDataString = await response.stream.bytesToString();
        // final jsonData = jsonDecode(jsonDataString);
        pop(context);
showDialogSuccess(context: context,message: "تم التسجيل بنجاح".tr());
        emit(const BusinessOwnersState(addBusinessOwnersState: RequestState.loaded));
      } else {
        emit(const BusinessOwnersState(addBusinessOwnersState: RequestState.error));
      }
    } else {
      emit(const BusinessOwnersState(addBusinessOwnersState: RequestState.noInternet));
    }
  }


}
