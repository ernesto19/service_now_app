import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

class ProfessionalBusinessGalleryPage extends StatelessWidget {
  static final routeName = 'professional_business_gallery_page';

  final List<ProfessionalBusinessGallery> gallery;
  final int businessId;

  const ProfessionalBusinessGalleryPage({ @required this.gallery, @required this.businessId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galería', style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: buildBody(context)
    );
  }

  BlocProvider<ProfessionalBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfessionalBloc>(),
      child: BlocBuilder<ProfessionalBloc, ProfessionalState>(
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = ProfessionalBloc.of(context);

          return Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            child: gallery.length > 0
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: FadeInImage(
                              image: NetworkImage(gallery[index].url ?? ''),
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
                          onPressed: () => bloc.add(DeleteImageForProfessional(gallery[index].id, businessId, context))
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
                  itemCount: gallery.length
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
        }
      )
    );
  }
}