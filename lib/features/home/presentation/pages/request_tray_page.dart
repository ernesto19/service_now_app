import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_now/blocs/professional_bloc.dart';
import 'package:service_now/features/professional/presentation/widgets/header.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/utils/all_translations.dart';

class RequestTrayPage extends StatefulWidget {
  static final routeName = 'professional_request_tray_page';
  final ProfessionalBusiness business;

  const RequestTrayPage({ @required this.business });

  @override
  _RequestTrayPageState createState() => _RequestTrayPageState();
}

class _RequestTrayPageState extends State<RequestTrayPage> {
  @override
  void initState() {
    super.initState();

    bloc.obtenerBandejaSolicitudes(widget.business.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context)
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: bloc.solicitudes,
              builder: (context, AsyncSnapshot<RequestResponse> snapshot) {
                if (snapshot.hasData) {
                  RequestResponse response = snapshot.data;

                  return response.data.length > 0 
                  ? CustomScrollView(
                    slivers: [
                      Header(
                        title: allTranslations.traslate('my_colaborations_tray_title'),
                        titleSize: 22,
                        onTap: () => Navigator.pop(context)
                      ),
                      _buildSolicitudes(response.data)
                    ],
                  ) 
                  : CustomScrollView(
                    slivers: [
                      Header(
                        title: allTranslations.traslate('my_colaborations_tray_title'),
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
                              Text('No hay registros para mostrar')
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
                      title: allTranslations.traslate('my_colaborations_tray_title'),
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

  Widget _buildSolicitudes(List<Request> solicitudes) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Request solicitud = solicitudes[index];

          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only(bottom: 15, right: 15, left: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(solicitud.firstName + ' ' + solicitud.lastName, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                          )
                        ]
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(solicitud.email, style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check, color: Colors.white, size: 20),
                                  SizedBox(width: 5),
                                  Text('Aprobar', style: TextStyle(fontSize: 14, color: Colors.white))
                                ]
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                              ),
                              color: Colors.blueAccent,
                              onPressed: () {
                                bloc.aprobarSolicitud(solicitud.id);
                              }
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: RaisedButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.close, color: Colors.white, size: 20),
                                  SizedBox(width: 5),
                                  Text('Denegar', style: TextStyle(fontSize: 14, color: Colors.white))
                                ]
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                              ),
                              color: Colors.redAccent,
                              onPressed: () {
                                bloc.denegarSolicitud(solicitud.id);
                              }
                            ),
                          )
                        ]
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
            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalBusinessDetailPage(business: business)))
          );
        },
        childCount: solicitudes.length
      )
    );
  }
}