import 'package:deal_card/bloc/market_cubit/market_cubit.dart';
import 'package:deal_card/core/enums/loading_status.dart';
import 'package:deal_card/core/layout/app_fonts.dart';
import 'package:deal_card/core/layout/palette.dart';
import 'package:deal_card/core/utils/utils.dart';
import 'package:deal_card/core/widgets/drop_down_widget.dart';
import 'package:deal_card/core/widgets/empty_list_widget.dart';
import 'package:deal_card/core/widgets/texts.dart';
import 'package:deal_card/ui/components/no_internet_widget.dart';
import 'package:deal_card/ui/markets_screen/components/list_markets_widget.dart';
import 'package:deal_card/ui/markets_screen/components/shimmer_market_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketsScreen extends StatefulWidget {
  final int id, type; // ** type  0 normaly 1 ==> markets
  final String title;

  const MarketsScreen(
      {super.key, required this.id, required this.type, required this.title});

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  int cityId = 0;

  @override
  void initState() {
    super.initState();

    print(widget.id.toString() + widget.type.toString());
    fetchData();
  }

  Future<void> fetchData() async {
    if (widget.type == 0) {
      MarketCubit.get(context)
          .getMarketsByCategoryId(id: widget.id, context: context, page: 1,cityId: 0);
    } else {
      MarketCubit.get(context)
          .getMarketsByFieldId(cityId: 0, context: context, page: 1,fieldId: widget.id);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        print(MarketCubit.get(context).totalPages);
        if (MarketCubit.get(context).currentPage <
            MarketCubit.get(context).totalPages) {
          MarketCubit.get(context).currentPage++;

          if (widget.type == 0) {
            MarketCubit.get(context).getMarketsByCategoryId(
                id: widget.id,
                context: context,
                cityId: cityId,
                page: MarketCubit.get(context).currentPage);
          } else {
            MarketCubit.get(context).getMarketsByFieldId(
                cityId: cityId,
                context: context,
                page: MarketCubit.get(context).currentPage);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketCubit, MarketState>(
      builder: (context, state) {
        cityId = state.cityId;
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              leading: const BackButton(
                color: Palette.mainColor,
              ),
              title: Texts(
                title: widget.title,
                family: AppFonts.caB,
                size: 25,
                textColor: Palette.mainColor,
                height: 2.0,
              ),
              actions: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: 40,
                  width: 150,
                  child: DropDownWidget(
                    onChanged: (CityModel) {
                      if (widget.type == 0) {
                        MarketCubit.get(context).getMarketsByCategoryId(
                            id: widget.id,
                            context: context,
                            page: 1,
                            cityId: CityModel.id);
                      } else {
                        MarketCubit.get(context).getMarketsByFieldId(
                            cityId: CityModel.id, context: context, page: 1,fieldId: widget.id);
                      }
                    },
                  ),
                )
              ],
              // actions: const [IconAlertWidget()],
            ),
            body: geBody(state));
      },
    );
  }

  Widget geBody(MarketState state) {
    switch (state.getMarketsState) {
      case RequestState.noInternet:
        return NoInternetWidget(
          onPress: () {
            if (widget.type == 0) {
              MarketCubit.get(context).getMarketsByCategoryId(
                  id: widget.id, context: context, page: 1,cityId: 0);
            } else {
              MarketCubit.get(context).getMarketsByFieldId(
                  cityId:0, context: context, page: 1);
            }
          },
        );
      case RequestState.loaded:
      case RequestState.pagination:
        return MarketCubit.get(context).markets.isEmpty
            ? EmptyListWidget(message: "لا توجد متاجر".tr())
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    ListMarketsWidget(
                        markets: MarketCubit.get(context).markets),
                    const SizedBox(
                      height: 20,
                    ),
                    state.getMarketsState == RequestState.pagination
                        ? const SizedBox(
                            height: 35,
                            width: 35,
                            child: CircularProgressIndicator(),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ));

      case RequestState.error:
      case RequestState.loading:
        return const ShimmerMarketWidget();
      default:
        return const ShimmerMarketWidget();
    }
  }
}
