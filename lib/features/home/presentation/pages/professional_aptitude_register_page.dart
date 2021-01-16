import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:service_now/blocs/user_bloc.dart';
import 'package:service_now/features/professional/presentation/widgets/animation_fab.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_form_field.dart';
import 'package:service_now/widgets/rounded_button.dart';
import 'package:service_now/widgets/success_page.dart';
import 'home_page.dart';

class ProfessionalAptitudeRegisterPage extends StatefulWidget {
  static final routeName = 'professional_aptitude_register_page';

  @override
  _ProfessionalAptitudeRegisterPageState createState() => _ProfessionalAptitudeRegisterPageState();
}

class _ProfessionalAptitudeRegisterPageState extends State<ProfessionalAptitudeRegisterPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Asset> images = List<Asset>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('professional_aptitude_register_title'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: SafeArea(
        child: _buildBody(context)
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                _buildTitle(),
                SizedBox(height: 20),
                _buildDescription(),
                SizedBox(height: 20),
                images != null && images.length > 0 
                ? Container(
                  padding: EdgeInsets.only(right: 20, bottom: 20), 
                  child: buildGridView()
                ) 
                : Align(
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
                SizedBox(height: 30),
                _buildSaveButton()
              ]
            )
          )
        )
      ]
    );
  }

  Widget _buildTitle() {
    return InputFormField(
      hint: allTranslations.traslate('aptitude_title_placeholder'),
      label: allTranslations.traslate('aptitude_title_label'),
      inputType: TextInputType.number,
      controller: _titleController,
      maxLength: 20
    );
  }

  Widget _buildDescription() {
    return InputFormField(
      hint: allTranslations.traslate('aptitude_description_placeholder'),
      label: allTranslations.traslate('aptitude_description_label'),
      inputType: TextInputType.text,
      controller: _descriptionController,
      maxLength: 100
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

        bloc.registerProfessionalAptitude(_titleController.text ?? '', _descriptionController.text ?? '', UserPreferences.instance.profileId, images);
        bloc.aptitudeRegisterResponse.listen((response) {
          if (response.error == 0) {
            Navigator.of(context).pop();
            Navigator.of(context).push(FadeRouteBuilder(page: SuccessPage(message: 'La aptitud ha sido registrada exitosamente.', assetImage: 'assets/images/check.png', page: Container(), levelsNumber: 1, pageName: HomePage.routeName)));
          } else if (response.error == 2) {
            Navigator.of(context).pop();

            String title = response.validation[0]['title'] != null ? response.validation[0]['title'][0] + '\n' : '';
            String description = response.validation[0]['description'] != null ? response.validation[0]['description'][0] : '';
            String message = title + description;

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(allTranslations.traslate('registro_fallido'), style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  content: Text(message, style: TextStyle(fontSize: 16)),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(allTranslations.traslate('aceptar'), style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        Navigator.pop(context);
                      }
                    )
                  ],
                );
              }
            );
          } else {
            Navigator.of(context).pop();

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(allTranslations.traslate('registro_fallido'), style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  content: Text(response.message, style: TextStyle(fontSize: 16)),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(allTranslations.traslate('aceptar'), style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        Navigator.pop(context);
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
          selectionLimitReachedText: allTranslations.traslate('no_puede_seleccionar'),
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