import 'package:cached_network_image/cached_network_image.dart';
import 'package:deal_card/bloc/market_cubit/market_cubit.dart';
import 'package:deal_card/bloc/search_cubit/search_cubit.dart';
import 'package:deal_card/models/base_response.dart';
import 'package:deal_card/ui/daetails_market_screen/daetails_market_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/animations/slide_transtion.dart';
import '../../core/enums/loading_status.dart';
import '../../core/helpers/helper_functions.dart';
import '../../core/layout/app_fonts.dart';
import '../../core/layout/palette.dart';
import '../../core/local_database/local_database.dart';
import '../../core/shimmer/shimmer_widget.dart';
import '../../core/utils/api_constatns.dart';
import '../../core/utils/app_model.dart';
import '../../core/widgets/circular_progress.dart';
import '../../core/widgets/empty_list_widget.dart';
import '../../core/widgets/texts.dart';
import '../markets_screen/components/shimmer_market_widget.dart';
import 'container_search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFEFEFE),
        elevation: 0,
        title: Texts(
            title: "صفحة البحث".tr(),
            family: AppFonts.taB,
            size: 18,
            widget: FontWeight.bold),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 30),
            child: Column(children: [
              ContainerSearchWidget(
                onTap: (value) {
                  if (kDebugMode) {
                    print(value);
                  }
                  if(value.isEmpty){
                    showToast(msg: "أدخل كلمة البحث".tr());
                  }else{
                    FocusManager.instance.primaryFocus?.unfocus();
                    SearchCubit.get(context)
                        .getMarketsSearched(context: context, text: value);
                  }


                },
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: state.getSearchMarketsState == RequestState.loaded
                      ? state.response!.isEmpty
                          ? EmptyListWidget(message: "لا توجد نتائج لبحثك".tr())
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 220,
                                      childAspectRatio: 1.5 / 2,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8),

                              itemCount: state.response!.length,

                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              itemBuilder: (BuildContext context, int index) {
                                MarketResponse market = state.response![index];
                                return GestureDetector(
                                  onTap: () {
                                    pushTranslationPage(
                                        context: context,
                                        transtion: FadTransition(
                                            page: DetailsMarketScreen(
                                          marketModel: market.market,
                                        )));
                                  },
                                  child: Container(
                                    // margin: const EdgeInsets.only(bottom: 25),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Stack(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: ApiConstants.imageUrl(
                                              market.market.logoImage),
                                          width: double.infinity,
                                          height: double.infinity,
                                          placeholder: (context, url) =>
                                              getShimmerWidget(
                                                  child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey),
                                          )),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      // image Card
                                      market.card == null
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
                                                    border: Border.all(
                                                        color: Colors.green,
                                                        width: 2)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        ApiConstants.imageUrl(
                                                            market.card!.image),
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    placeholder: (context,
                                                            url) =>
                                                        getShimmerWidget(
                                                            child: Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.grey),
                                                    )),
                                                    fit: BoxFit.cover,
                                                    errorWidget: (context, url,
                                                            error) =>
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
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
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
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 20),
                                            child: Texts(
                                              line: 2,
                                              title: AppModel.lang ==
                                                      AppModel.arLang
                                                  ? market.market.nameAr
                                                  : market.market.nameEng,
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
                                                  shape: BoxShape.circle, color: Palette.mainColor),
                                              child: Center(
                                                child: IconButton(
                                                    onPressed: () {
                                                      if (MarketCubit.get(context)
                                                          .fav
                                                          .containsValue(market.market.id)) {
                                                        MarketCubit.get(context)
                                                            .removeToFave(market.market.id);
                                                      } else {
                                                        MarketCubit.get(context)
                                                            .addToFave(MarketTable(
                                                          id: market.market.id,
                                                          marketId: market.market.id,
                                                          nameAr: market.market.nameAr,
                                                          nameEng: market.market.nameEng,
                                                          logoImage: market.market.logoImage,
                                                          cardIds:  market.market.cardIds,
                                                          abouteAr: market.market.aboutAr,
                                                          abouteEng: market.market.aboutEng,
                                                          images: market.market.images,
                                                          phone: market.market.phone,
                                                          link: market.market.link,
                                                          imageCard: market.card != null
                                                              ? market.card!.image
                                                              : "not",
                                                          email: market.market.email,
                                                        ));
                                                      }
                                                    },
                                                    icon: Icon(
                                                      MarketCubit.get(context)
                                                          .fav
                                                          .containsValue(market.market.id)
                                                          ? Icons.favorite
                                                          : Icons.favorite_border,
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
                            )
                      :state.getSearchMarketsState == RequestState.loading? const ShimmerMarketWidget():
                  EmptyListWidget(message: "ابحث عن المتجر الذي تريده".tr())
              ),
            ]),
          );
        },
      ),
    );
  }
}
