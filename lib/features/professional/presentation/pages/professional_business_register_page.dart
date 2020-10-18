import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/domain/entities/industry.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/features/professional/presentation/pages/address_page.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/models/place.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_form_field.dart';
import 'package:service_now/widgets/rounded_button.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProfessionalBusinessRegisterPage extends StatefulWidget {
  static final routeName = 'professional_business_register_page';

  @override
  _ProfessionalBusinessRegisterPageState createState() => _ProfessionalBusinessRegisterPageState();
}

class _ProfessionalBusinessRegisterPageState extends State<ProfessionalBusinessRegisterPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _fanpageController = TextEditingController();
  String _industrySelected;
  String _categorySelected;
  Place _place;
  String _addressController = allTranslations.traslate('business_address_placeholder');
  var _addressColor = Colors.black38;
  List<Asset> images = List<Asset>();
  String _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('register_business_title'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: SafeArea(
        child: _buildBody(context)
      ),
    );
  }

  BlocProvider<ProfessionalBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfessionalBloc>(),
      child: BlocBuilder<ProfessionalBloc, ProfessionalState>(
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = ProfessionalBloc.of(context);
          bloc.add(GetIndustriesForProfessional());
          String text = allTranslations.traslate('loading_message');

          return Container(
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        state.formStatus == RegisterBusinessFormDataStatus.ready 
                        ? Column(
                          children: [
                            _buildIndustiesSelect(state.formData.industries),
                            SizedBox(height: 12),
                            _buildCategoriesSelect(state.formData.categories),
                          ],
                        ) 
                        : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: LinearProgressIndicator(),
                            ),
                            Text(text)
                          ]
                        ),
                        SizedBox(height: 10),
                        _buildName(),
                        SizedBox(height: 20),
                        _buildDescription(),
                        SizedBox(height: 20),
                        _buildLicenseNumber(),
                        SizedBox(height: 20),
                        _buildAddress(),
                        SizedBox(height: 20),
                        _buildFanpage(),
                        SizedBox(height: 20),
                        Center(
                          child: Text('Error: $_error')
                        ),
                        RaisedButton(
                          child: Text("Pick images"),
                          onPressed: loadAssets,
                        ),
                        // Expanded(
                        //   child: buildGridView(),
                        // ),
                        buildGridView(),
                        SizedBox(height: 40),
                        _buildSaveButton(bloc)
                      ]
                    )
                  ),
                )
              ]
            )
          );
        }
      )
    );
  }

  void goToAddressScreen() async {
    await Navigator.push(context, 
      MaterialPageRoute(
        builder: (BuildContext context) => AddressPage()
      )
    ).then((value) {
      setState(() {
        _place = value;
        if (_place != null) {
          _addressController = _place.title + ' - ' + _place.vicinity.replaceAll('<br/>', ' - ');
          _addressColor = Colors.black;
        }
      });
    });
  }

  Widget _buildName() {
    return InputFormField(
      hint: allTranslations.traslate('business_name_placeholder'),
      label: allTranslations.traslate('business_name_label'),
      inputType: TextInputType.text,
      controller: _nameController,
      maxLength: 100
    );
  }

  Widget _buildDescription() {
    return InputFormField(
      hint: allTranslations.traslate('business_description_placeholder'),
      label: allTranslations.traslate('business_description_label'),
      inputType: TextInputType.text,
      controller: _descriptionController,
      maxLength: 100
    );
  }

  Widget _buildLicenseNumber() {
    return InputFormField(
      hint: allTranslations.traslate('business_license_placeholder'),
      label: allTranslations.traslate('business_license_label'),
      inputType: TextInputType.text,
      controller: _licenseNumberController,
      maxLength: 100
    );
  }

  Widget _buildAddress() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft, 
            child: Text(
              allTranslations.traslate('business_address_label'), 
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black, 
                fontWeight: 
                FontWeight.bold
              )
            )
          ),
          SizedBox(height: 15.0),
          Container(
            alignment: Alignment.bottomLeft,
            child: InkWell(
              child: Text(
                _addressController, 
                style: TextStyle(fontSize: 15.0, color: _addressColor)
              ),
              onTap: goToAddressScreen
            )
          ),
          SizedBox(height: 9.0),
          Container(
            child: Divider(
              height: 1,
              color: Colors.black
            )
          )
        ]
      )
    );
  }

  Widget _buildFanpage() {
    return InputFormField(
      hint: allTranslations.traslate('business_fanpage_placeholder'),
      label: allTranslations.traslate('business_fanpage_label'),
      inputType: TextInputType.text,
      controller: _fanpageController,
      maxLength: 100
    );
  }

  Widget _buildSaveButton(ProfessionalBloc bloc) {
    return RoundedButton(
      label: allTranslations.traslate('register_button_text'),
      backgroundColor: secondaryDarkColor,
      width: double.infinity,
      onPressed: () => bloc.add(RegisterBusinessForProfessional(_nameController.text, _descriptionController.text, int.parse(_industrySelected), int.parse(_categorySelected), _licenseNumberController.text, '1', '${_place.position.latitude}', '${_place.position.longitude}', _addressController, _fanpageController.text, context))
    );
  }

  Widget _buildIndustiesSelect(List<Industry> industries) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(alignment: Alignment.bottomLeft, child: Text(allTranslations.traslate('business_industry_label'), style: labelFormStyle)),
          DropdownButton<String>(
            hint: Text(allTranslations.traslate('business_industry_placeholder'), style: TextStyle(fontSize: 15.0)),
            isExpanded: true,
            style: TextStyle(fontFamily: 'sans', color: Colors.black87, fontSize: 15.0),
            underline: Divider(
              height: 0.0,
              color: Colors.black87
            ),
            items: industries.map((Industry item) {
              return DropdownMenuItem<String>(
                value: '${item.id}',
                child: Text(item.name),
              );
            }).toList(),
            value: _industrySelected,
            onChanged: (value) {
              setState(() {
                _industrySelected = value;
              });
            }
          )
        ]
      )
    );
  }

  Widget _buildCategoriesSelect(List<Category> categories) {
    List<Category> localCategories = List();

    if (_industrySelected != null) {
      localCategories = categories.where((element) => element.industryId == int.parse(_industrySelected)).toList();
    }

    localCategories = categories;

    return Container(
      child: Column(
        children: <Widget>[
          Container(alignment: Alignment.bottomLeft, child: Text(allTranslations.traslate('business_category_label'), style: labelFormStyle)),
          DropdownButton<String>(
            hint: Text(allTranslations.traslate('business_category_placeholder'), style: TextStyle(fontSize: 15.0)),
            isExpanded: true,
            style: TextStyle(fontFamily: 'sans', color: Colors.black87, fontSize: 15.0),
            underline: Divider(
              height: 0.0,
              color: Colors.black87
            ),
            items: localCategories.map((Category item) {
              return DropdownMenuItem<String>(
                value: '${item.id}',
                child: Text(item.name),
              );
            }).toList(),
            value: _categorySelected,
            onChanged: (value) {
              setState(() {
                _categorySelected = value;
              });
            }
          )
        ]
      )
    );
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
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
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }
}