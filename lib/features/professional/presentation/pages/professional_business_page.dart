import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_now/blocs/professional_bloc.dart';
import 'package:service_now/features/professional/presentation/widgets/header.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'professional_business_detail_page.dart';
import 'professional_business_register_page.dart';

class ProfessionalBusinessPage extends StatefulWidget {
  static final routeName = 'professional_business_page';

  @override
  _ProfessionalBusinessPageState createState() => _ProfessionalBusinessPageState();
}

class _ProfessionalBusinessPageState extends State<ProfessionalBusinessPage> {
  bool toggleValue = false;

  @override
  void initState() {
    super.initState();

    bloc.fetchProfessionalBusiness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: secondaryDarkColor,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalBusinessRegisterPage(business: null)))
      )
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: bloc.allProfessionalBusiness,
              builder: (context, AsyncSnapshot<ProfessionalBusinessResponse> snapshot) {
                if (snapshot.hasData) {
                  ProfessionalBusinessResponse response = snapshot.data;

                  return response.data.length > 0 
                  ? CustomScrollView(
                    slivers: [
                      Header(
                        title: allTranslations.traslate('my_business_title'),
                        titleSize: 22,
                        onTap: () => Navigator.pop(context)
                      ),
                      _buildBusiness(response.data)
                    ],
                  ) 
                  : CustomScrollView(
                    slivers: [
                      Header(
                        title: allTranslations.traslate('my_business_title'),
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
                      title: allTranslations.traslate('my_business_title'),
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

  Widget _buildBusiness(List<ProfessionalBusiness> businessList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          ProfessionalBusiness business = businessList[index];

          List<PopupMenuEntry<String>> menuOptions = List();

          if (business.owner == 1) {
            menuOptions.add(
              PopupMenuItem<String>(
                value: '1',
                child: Row(
                  children: [
                    ShaderMask(
                      child: CupertinoSwitch(
                        activeColor: Colors.greenAccent[100],
                        value: business.active == 1,
                        onChanged: (value) {
                          Navigator.pop(context);

                          bloc.updateBusinessStatus(business.id);
                          bloc.businessStatusUpdateResponse.listen((response) {
                            ProfessionalBusiness businessTemp = ProfessionalBusiness(
                              id: business.id, 
                              name: business.name, 
                              description: business.description, 
                              categoryId: business.categoryId, 
                              categoryName: business.categoryName, 
                              industryId: business.industryId,
                              address: business.address,
                              licenseNumber: business.licenseNumber,
                              fanpage: business.fanpage,
                              latitude: business.latitude,
                              longitude: business.longitude,
                              owner: business.owner,
                              active: business.active == 1 ? 0 : 1,
                              professionalActive: business.professionalActive
                            );

                            setState(() {
                              businessList[index] = businessTemp;  
                            });
                          });
                        }
                      ),
                      shaderCallback: (r) {
                        return LinearGradient(
                          colors: business.active == 1
                              ? [ Colors.greenAccent[100], Colors.greenAccent[100]]
                              : [ Colors.redAccent[100], Colors.redAccent[100]],
                        ).createShader(r);
                      }
                    ),
                    SizedBox(width: 10),
                    Text(allTranslations.traslate('negocio'))
                  ],
                )
              )
            );
          }

          menuOptions.add(
            PopupMenuItem<String>(
              value: '2',
              child: Row(
                children: [
                  ShaderMask(
                    child: CupertinoSwitch(
                      activeColor: Colors.greenAccent[100],
                      value: business.professionalActive == 1,
                      onChanged: (value) {
                        Navigator.pop(context);

                        bloc.updateBusinessProfessionalStatus(business.id, business.professionalActive == 1 ? 0 : 1);
                        bloc.businessProfessionalStatusUpdateResponse.listen((response) {
                          ProfessionalBusiness businessTemp = ProfessionalBusiness(
                            id: business.id, 
                            name: business.name, 
                            description: business.description, 
                            categoryId: business.categoryId, 
                            categoryName: business.categoryName, 
                            industryId: business.industryId,
                            address: business.address,
                            licenseNumber: business.licenseNumber,
                            fanpage: business.fanpage,
                            latitude: business.latitude,
                            longitude: business.longitude,
                            owner: business.owner,
                            active: business.active,
                            professionalActive: business.professionalActive == 1 ? 0 : 1
                          );

                          setState(() {
                            businessList[index] = businessTemp;  
                          });
                        });
                      }
                    ),
                    shaderCallback: (r) {
                      return LinearGradient(
                        colors: business.professionalActive == 1
                            ? [ Colors.greenAccent[100], Colors.greenAccent[100]]
                            : [ Colors.redAccent[100], Colors.redAccent[100]],
                      ).createShader(r);
                    }
                  ),
                  SizedBox(width: 10),
                  Text(allTranslations.traslate('jornada_laboral'))
                ],
              )
            )
          );

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
                            child: Text(business.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                          ),
                          PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == '1') {
                                bloc.updateBusinessStatus(business.id);
                                bloc.businessStatusUpdateResponse.listen((response) {
                                  ProfessionalBusiness businessTemp = ProfessionalBusiness(
                                    id: business.id, 
                                    name: business.name, 
                                    description: business.description, 
                                    categoryId: business.categoryId, 
                                    categoryName: business.categoryName, 
                                    industryId: business.industryId,
                                    address: business.address,
                                    licenseNumber: business.licenseNumber,
                                    fanpage: business.fanpage,
                                    latitude: business.latitude,
                                    longitude: business.longitude,
                                    owner: business.owner,
                                    active: business.active == 1 ? 0 : 1,
                                    professionalActive: business.professionalActive
                                  );

                                  setState(() {
                                    businessList[index] = businessTemp;  
                                  });
                                });
                              } else {

                              }
                            },
                            itemBuilder: (BuildContext context) => menuOptions
                          )
                        ]
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.web, size: 20),
                          SizedBox(width: 10),
                          Text(business.categoryName.toUpperCase(), style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.pin_drop, size: 20),
                          SizedBox(width: 10),
                          Expanded(child: Text(business.address, style: TextStyle(fontSize: 11))),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.stars, size: 20),
                          SizedBox(width: 10),
                          Text(business.licenseNumber, style: TextStyle(fontSize: 11)),
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
            ),
            onTap: business.owner == 1 ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalBusinessDetailPage(business: business))) : null
          );
        },
        childCount: businessList.length
      )
    );
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }
}