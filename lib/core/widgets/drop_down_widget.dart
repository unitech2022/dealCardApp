import 'package:deal_card/core/utils/app_model.dart';
import 'package:deal_card/models/city_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {

 final  Function onChanged;
  const DropDownWidget({super.key,required this.onChanged});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
CityModel? currentValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  DropdownButtonHideUnderline(
        child: DropdownButton2<CityModel>(
          isExpanded: true,
          hint: Text(
            "اختار المدينة".tr(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),

          items: AppModel.cities
              .map((CityModel item) => DropdownMenuItem<CityModel>(
            value: item,
            child: Text(
              AppModel.lang==AppModel.arLang?item.nameAr:item.nameEng,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ))
              .toList(),

          onChanged:(value){
            setState(() {
              currentValue=value;
            });
            widget.onChanged(value);
          },
          value:currentValue,


          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 160,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.white,
            ),
            elevation: 0,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            iconSize: 14,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.black,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 400,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(8),

            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}
