import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:service_now/blocs/professional_bloc.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/rounded_button.dart';

class ProfessionalServiceGalleryAddPage extends StatefulWidget {
  final int id;

  const ProfessionalServiceGalleryAddPage({ @required this.id });

  @override
  _ProfessionalServiceGalleryAddPageState createState() => _ProfessionalServiceGalleryAddPageState();
}

class _ProfessionalServiceGalleryAddPageState extends State<ProfessionalServiceGalleryAddPage> {
  List<Asset> images = List<Asset>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('agregar_imagenes'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 20)
          ),
          SliverToBoxAdapter(
            child: images != null && images.length > 0 
            ? Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20), 
              child: buildGridView()
            ) 
            : Container(
              padding: EdgeInsets.only(left: 20, bottom: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  child: Container(
                    height: 120,
                    width: 120,
                    color: Colors.black12,
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Icon(Icons.add_a_photo, size: 60, color: Colors.black38),
                          ),
                        ),
                        SizedBox(height: 5)
                      ]
                    )
                  ),
                  onTap: loadAssets
                ),
              ),
            )
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 10),
              child: _buildSaveButton()
            )
          )
        ]
      )
    );
  }

  Widget _buildSaveButton() {
    return RoundedButton(
      label: allTranslations.traslate('register_button_text'),
      backgroundColor: secondaryDarkColor,
      width: double.infinity,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Container(
              child: AlertDialog(
                content: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(allTranslations.traslate('register_message'), style: TextStyle(fontSize: 15.0)),
                    )
                  ],
                ),
              ),
            );
          }
        );
        
        bloc.agregarImagenesServicio(widget.id, images);
        bloc.agregarImagenServicioResponse.listen((response) {
          if (response.error == 0) {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(allTranslations.traslate('actualizacion_exitosa'), style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
                  content: Text(allTranslations.traslate('imagenes_agregadas_servicio'), style: TextStyle(fontSize: 16.0),),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(allTranslations.traslate('aceptar'), style: TextStyle(fontSize: 14.0)),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      }
                    )
                  ],
                );
              }
            );
          }
        });
      }
    );
  }

  Widget buildGridView() {
    if (images != null) {
      return GridView.count(
        primary: false,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    } else {
      return Container(color: Colors.white);
    }
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        materialOptions: MaterialOptions(
          actionBarTitle: allTranslations.traslate('seleccionadas'),
          allViewTitle: allTranslations.traslate('seleccionadas'),
          actionBarColor: "#E2C662",
          actionBarTitleColor: "#FFFFFF",
          lightStatusBar: false,
          statusBarColor: '#B3993B',
          startInAllView: true,
          selectCircleStrokeColor: "#000000",
          selectionLimitReachedText: allTranslations.traslate('no_puede_seleccionar')
        )
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }
}