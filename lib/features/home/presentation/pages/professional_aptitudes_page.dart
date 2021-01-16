import 'package:flutter/material.dart';
import 'package:service_now/blocs/user_bloc.dart';
import 'package:service_now/models/user.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

import 'professional_aptitude_register_page.dart';

class ProfessionalAptitudesPage extends StatefulWidget {
  @override
  _ProfessionalAptitudesPageState createState() => _ProfessionalAptitudesPageState();
}

class _ProfessionalAptitudesPageState extends State<ProfessionalAptitudesPage> {
  @override
  void initState() { 
    super.initState();
    
    bloc.fetchAptitudes(UserPreferences.instance.profileId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('professional_aptitude_title'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: SafeArea(
        child: _buildBody(context)
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: secondaryDarkColor,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalAptitudeRegisterPage()))
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allAptitudes,
      builder: (context, AsyncSnapshot<AptitudeResponse> snapshot) {
        if (snapshot.hasData) {
          AptitudeResponse profile = snapshot.data;
          List<Aptitude> aptitudes = profile.data;

          return CustomScrollView(
            slivers: [
              aptitudes.length > 0 ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Aptitude aptitude = aptitudes[index];

                    return Column(
                      children: [
                        Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Row(
                                              children: [
                                                Text(aptitude.title.toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                                              ]
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(aptitude.description, style: TextStyle(fontSize: 16))
                                              ]
                                            )
                                          )
                                        ]
                                      )
                                    )
                                  )
                                ]
                              ),
                              aptitude.gallery.length > 0 
                              ? Container(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: aptitude.gallery.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 150,
                                      width: 150,
                                      child: FadeInImage(
                                        image: NetworkImage(aptitude.gallery[index].url ?? ''),
                                        placeholder: AssetImage('assets/images/loader.gif'),
                                        fadeInDuration: Duration(milliseconds: 200),
                                        fit: BoxFit.cover
                                      )
                                    );
                                  }
                                )
                              ) 
                              : Container(
                                height: 150,
                                width: 150,
                                color: Colors.black12,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Icon(Icons.image, size: 60, color: Colors.black38),
                                      ),
                                    ),
                                    Text('No image'),
                                    SizedBox(height: 10)
                                  ]
                                )
                              ),
                              SizedBox(height: 10)
                            ]
                          )
                        )
                      ]
                    );
                  },
                  childCount: aptitudes.length
                )
              ) : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    padding: EdgeInsets.only(top: 150),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.mood_bad, size: 60, color: Colors.black38),
                          SizedBox(height: 10),
                          Text(allTranslations.traslate('no_hay_informacion'))
                        ],
                      )
                    ),
                  ),
                  childCount: 1
                )
              )
            ],
          );

          
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return Center(
          child: CircularProgressIndicator()
        );
      }
    );
  }
}