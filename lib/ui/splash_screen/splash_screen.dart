import 'package:deal_card/bloc/app_cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/layout/app_fonts.dart';
import '../../core/layout/palette.dart';
import '../../core/widgets/texts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 AppCubit.get(context).getPage(context);

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child:       Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(

                  child: SizedBox(
              height: 200,width:200,
                    child: Image.asset(

                      "assets/images/logo.png",height: 200,width:200,

                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Texts(title: "Deal Card", family: AppFonts.accL, size: 40,textColor: Colors.black,)
              ],
            ),

          ),
        );
      },
    );
  }
}