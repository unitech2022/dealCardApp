import 'package:cached_network_image/cached_network_image.dart';
import 'package:deal_card/core/local_database/local_database.dart';
import 'package:deal_card/core/widgets/empty_list_widget.dart';
import 'package:deal_card/models/market_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/market_cubit/market_cubit.dart';
import '../../core/animations/slide_transtion.dart';
import '../../core/layout/app_fonts.dart';
import '../../core/layout/palette.dart';
import '../../core/shimmer/shimmer_widget.dart';
import '../../core/utils/api_constatns.dart';
import '../../core/utils/app_model.dart';
import '../../core/widgets/texts.dart';
import '../daetails_market_screen/daetails_market_screen.dart';
import '../markets_screen/components/shimmer_market_widget.dart';

class FevoraiteScreen extends StatefulWidget {
  const FevoraiteScreen({super.key});

  @override
  State<FevoraiteScreen> createState() => _FevoraiteScreenState();
}

class _FevoraiteScreenState extends State<FevoraiteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
       automaticallyImplyLeading: false,
        title: Texts(
          title: "المفضلة".tr(),
          family: AppFonts.caB,
          size: 18,
          textColor: Palette.mainColor,
          height: 2.0,
        ),
      ),
      body: FutureBuilder(
          future: LocalDatabaseHelper().queryAllRows(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return snapshot.data!.isEmpty
                  ? EmptyListWidget(message: "لا توجد عناصر في المفضلة".tr())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              childAspectRatio: 1.5 / 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            MarketModel marketModel = MarketModel(
                                id: snapshot.data![index]["id"],
                                nameAr: snapshot.data![index]["nameAr"],
                                nameEng: snapshot.data![index]["nameEng"],
                                aboutAr: snapshot.data![index]["abouteAr"],
                                aboutEng: snapshot.data![index]["abouteEng"],
                                logoImage: snapshot.data![index]["logoImage"],
                                link: snapshot.data![index]["link"],
                                order: 1,
                                categoryId: 1,
                                fieldId: 1,
                                phone: snapshot.data![index]["phone"],
                                email: snapshot.data![index]["email"],
                                images: snapshot.data![index]["images"],
                                status: 1,
                                cardIds: snapshot.data![index]["cardIds"],
                                discount: 1,
                                rate: 2,
                                createdAt: "");
                            pushTranslationPage(
                                context: context,
                                transtion: FadTransition(
                                    page: DetailsMarketScreen(
                                  marketModel: marketModel,
                                )));
                          },
                          child: Container(
                            // margin: const EdgeInsets.only(bottom: 25),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: ApiConstants.imageUrl(
                                      snapshot.data![index]["logoImage"]),
                                  width: double.infinity,
                                  height: double.infinity,
                                  placeholder: (context, url) =>
                                      getShimmerWidget(
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
                              // image Card
                              snapshot.data![index]["cardIds"] ==  "0"
                                  ? SizedBox()
                                  : Align(
                                alignment: Alignment.topRight,
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
                                      ApiConstants.imageUrl( snapshot.data![index]["imageCard"] ),
                                      width: double.infinity,
                                      height: double.infinity,
                                      placeholder: (context, url) =>
                                          getShimmerWidget(
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

                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 55,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      gradient: LinearGradient(
                                          begin: Alignment(0.0, -1.279),
                                          end: Alignment(0.0, 0.618),
                                          colors: [
                                            Color(0x000d0d0d),
                                            Color(0xff000000)
                                          ],
                                          stops: [
                                            0.0,
                                            1.0
                                          ])),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Texts(
                                      line: 2,
                                      title: AppModel.lang == AppModel.arLang
                                          ? snapshot.data![index]["nameAr"]
                                          : snapshot.data![index]["nameEng"],
                                      textColor: Colors.white,
                                      size: 16,
                                      family: AppFonts.caM,
                                    ),
                                  ),
                                ),
                              ),

                              Align(
                                alignment: Alignment.topLeft,
                                child: BlocBuilder<MarketCubit, MarketState>(
                                  builder: (context, state) {
                                    return Container(
                                      height: 35,
                                      width: 35,
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Palette.mainColor),
                                      child: Center(
                                        child: IconButton(
                                            onPressed: () {
                                              MarketCubit.get(context)
                                                  .removeToFave(snapshot
                                                      .data![index]["marketId"])
                                                  .then((value) {
                                                LocalDatabaseHelper()
                                                    .queryAllRows();
                                                setState(() {});
                                              });
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18,
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ]),
                          ),
                        );
                      },
                    );
            } else {
              print("object");
            }
            return const ShimmerMarketWidget();
          }),
    );
  }
}
