import 'package:flutter/material.dart';
import 'package:service_now/blocs/professional_bloc.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

class ProfessionalServiceGalleryPage extends StatelessWidget {
  static final routeName = 'professional_service_gallery_page';

  final int serviceId;

  const ProfessionalServiceGalleryPage({ @required this.serviceId});

  @override
  Widget build(BuildContext context) {
    bloc.fetchProfessionalServiceGallery(serviceId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Galería', style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: buildBody(context)
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allProfessionalServiceGallery,
      builder: (context, AsyncSnapshot<GalleryResponse> snapshot) {
        if (snapshot.hasData) {
          GalleryResponse response = snapshot.data;

          return Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            child: response.data.length > 0
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  itemBuilder: (context, index) {
                    Picture image = response.data[index];

                    return Column(
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: FadeInImage(
                              image: NetworkImage(image.url ?? ''),
                              placeholder: AssetImage('assets/images/loader.gif'),
                              fadeInDuration: Duration(milliseconds: 200),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                        RaisedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete, color: Colors.white, size: 20),
                              SizedBox(width: 5),
                              Text('Eliminar', style: TextStyle(color: Colors.white))
                            ]
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          color: Colors.red,
                          onPressed: () {
                            bloc.deleteServiceImage(image.id);
                            bloc.serviceImageDeleteResponse.listen((response) {
                              if (response.error == 0) {
                                bloc.fetchProfessionalServiceGallery(serviceId);
                              }
                            });
                          }
                        )
                      ],
                    );
                  },
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10
                  ),
                  itemCount: response.data.length
                ),
              ],
            )
            : Container(
              height: 200,
              width: 200,
              color: Colors.black12,
              margin: EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Icon(Icons.image, size: 100, color: Colors.black38),
                    ),
                  ),
                  Text('No image'),
                  SizedBox(height: 20)
                ]
              )
            )
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