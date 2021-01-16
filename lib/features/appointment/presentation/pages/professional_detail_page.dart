import 'package:flutter/material.dart';
import 'package:service_now/blocs/appointment_bloc.dart';
import 'package:service_now/models/appointment.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

class ProfessionalDetailPage extends StatefulWidget {
  final int id;
  final String name;

  ProfessionalDetailPage({ @required this.id, @required this.name });

  @override
  _ProfessionalDetailPageState createState() => _ProfessionalDetailPageState();
}

class _ProfessionalDetailPageState extends State<ProfessionalDetailPage> {
  @override
  void initState() {
    super.initState();
    
    bloc.obtenerPerfilProfesional(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name.toUpperCase(), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: SafeArea(
        child: _buildBody(context)
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder(
      stream: bloc.profesional,
      builder: (context, AsyncSnapshot<ProfessionalDetailResponse> snapshot) {
        if (snapshot.hasData) {
          ProfessionalDetailResponse profile = snapshot.data;
          ProfessionalNegocio profesional = profile.data;
          List<AptitudProfesional> aptitudes = profesional.aptitudes;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(allTranslations.traslate('celular'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(profesional.phone.isEmpty ? '-' : profesional.phone),
                      SizedBox(height: 8),
                      Text(allTranslations.traslate('email'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(profesional.email),
                      SizedBox(height: 8),
                      Text(allTranslations.traslate('facebook'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(profesional.facebook),
                      SizedBox(height: 8),
                      Text(allTranslations.traslate('linkedin'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(profesional.linkedin),
                      SizedBox(height: 8),
                      Text(allTranslations.traslate('resumen_profesional'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(profesional.resume)
                    ],
                  ),
                )
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    AptitudProfesional aptitude = aptitudes[index];

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
                                                Text(aptitude.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
                                              ]
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(aptitude.description, style: TextStyle(fontSize: 14))
                                              ]
                                            )
                                          )
                                        ]
                                      )
                                    )
                                  )
                                ]
                              ),
                              aptitude.galeria.length > 0 
                              ? Container(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: aptitude.galeria.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 150,
                                      width: 150,
                                      child: FadeInImage(
                                        image: NetworkImage(aptitude.galeria[index].url ?? ''),
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