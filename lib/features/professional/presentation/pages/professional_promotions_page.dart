import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_now/blocs/professional_bloc.dart';
import 'package:service_now/features/professional/presentation/widgets/header.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/models/promotion.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'professional_promotion_register_page.dart';

class ProfessionalPromotionsPage extends StatefulWidget {
  static final routeName = 'professional_promotions_page';
  final ProfessionalBusiness business;

  const ProfessionalPromotionsPage({ @required this.business });

  @override
  _ProfessionalPromotionsPageState createState() => _ProfessionalPromotionsPageState();
}

class _ProfessionalPromotionsPageState extends State<ProfessionalPromotionsPage> {
  bool toggleValue = false;

  @override
  void initState() {
    super.initState();

    bloc.fetchPromotions(widget.business.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: secondaryDarkColor,
        // onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalPromotionRegisterPage(businessId: widget.business.id)))
        onPressed: _goToNextPage
      )
    );
  }

  void _goToNextPage() async {
    await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => ProfessionalPromotionRegisterPage(businessId: widget.business.id))
    ).then((value) {
      setState(() {
        if (value != null) {
          if (value) {
            bloc.fetchPromotions(widget.business.id);
          }
        }
      });
    });
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: bloc.allPromotions,
              builder: (context, AsyncSnapshot<PromotionResponse> snapshot) {
                if (snapshot.hasData) {
                  PromotionResponse response = snapshot.data;

                  return response.data.length > 0
                  ? CustomScrollView(
                    slivers: [
                      Header(
                        title: allTranslations.traslate('my_promotions_title'),
                        titleSize: 22,
                        onTap: () => Navigator.pop(context)
                      ),
                      _buildPromotions(response.data, context)
                    ],
                  ) 
                  : CustomScrollView(
                    slivers: [
                      Header(
                        title: allTranslations.traslate('my_promotions_title'),
                        titleSize: 22,
                        onTap: () => Navigator.pop(context)
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.only(top: 100),
                          child: Column(
                            children: [
                              Icon(Icons.mood_bad, size: 60, color: Colors.black38),
                              SizedBox(height: 10),
                              Text(allTranslations.traslate('no_hay_informacion'))
                            ],
                          )
                        ),
                      )
                    ]
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                return CustomScrollView(
                  slivers: [
                    Header(
                      title: allTranslations.traslate('my_promotions_title'),
                      titleSize: 22,
                      onTap: () => Navigator.pop(context)
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(
                          child: CircularProgressIndicator()
                        ),
                      )
                    )
                  ]
                );
              }
            )
          )
        ]
      )
    );
  }

  Widget _buildPromotions(List<Promotion> promotionsList, BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Promotion promotion = promotionsList[index];

          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only(bottom: 15, right: 15, left: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(promotion.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                          ),
                          ShaderMask(
                            child: CupertinoSwitch(
                              activeColor: Colors.greenAccent[100],
                              value: promotion.active == 1,
                              onChanged: (value) {
                                bloc.updatePromotionStatus(promotion.id, promotion.active == 1 ? 0 : 1);
                                bloc.promotionStatusUpdateResponse.listen((response) {
                                  Promotion promotionTemp = Promotion(id: promotion.id, name: promotion.name, description: promotion.description, amount: promotion.amount, businessId: promotion.businessId, type: promotion.type, active: promotion.active == 1 ? 0 : 1);
                                  setState(() {
                                    promotionsList[index] = promotionTemp;  
                                  });
                                });
                              }
                            ),
                            shaderCallback: (r) {
                              return LinearGradient(
                                colors: promotion.active == 1
                                  ? [ Colors.greenAccent[100], Colors.greenAccent[100]]
                                  : [ Colors.redAccent[100], Colors.redAccent[100]],
                              ).createShader(r);
                            }
                          )
                        ]
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.description, size: 20),
                          SizedBox(width: 10),
                          Text(promotion.description, style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(promotion.type == '1' ? Icons.trending_down : Icons.monetization_on, size: 20),
                          SizedBox(width: 10),
                          Expanded(child: Text(promotion.type == '1' ? '${promotion.amount} % ${allTranslations.traslate('de_descuento')}' : '\$ ${promotion.amount} USD ${allTranslations.traslate('de_descuento')}', style: TextStyle(fontSize: 11))),
                        ],
                      ),
                      SizedBox(height: 5)
                    ]
                  )
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(2, 2)
                  )
                ]
              )
            )
          );
        },
        childCount: promotionsList.length
      )
    );
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }
}