import 'package:flutter/material.dart';
import 'package:service_now/blocs/professional_bloc.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

import 'professional_business_gallery_add_page.dart';

class ProfessionalBusinessGalleryPage extends StatelessWidget {
  static final routeName = 'professional_business_gallery_page';

  final int businessId;

  const ProfessionalBusinessGalleryPage({ @required this.businessId});

  @override
  Widget build(BuildContext context) {
    bloc.fetchProfessionalBusinessGallery(businessId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('galeria'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => ProfessionalBusinessGalleryAddPage(id: businessId))
          ).then((value) {
            if (value != null) {
              bloc.fetchProfessionalBusinessGallery(businessId);
            }
          });
        }
      )
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allProfessionalBusinessGallery,
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
                              Text(allTranslations.traslate('eliminar'), style: TextStyle(color: Colors.white))
                            ]
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          color: Colors.red,
                          onPressed: () {
                            bloc.deleteBusinessImage(image.id);
                            bloc.businessImageDeleteResponse.listen((response) {
                              if (response.error == 0) {
                                bloc.fetchProfessionalBusinessGallery(businessId);
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