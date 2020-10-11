import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/domain/entities/industry.dart';
import 'package:service_now/features/professional/presentation/bloc/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_form_field.dart';
import 'package:service_now/widgets/rounded_button.dart';

class ProfessionalBusinessRegisterPage extends StatefulWidget {
  static final routeName = 'professional_business_register_page';

  @override
  _ProfessionalBusinessRegisterPageState createState() => _ProfessionalBusinessRegisterPageState();
}

class _ProfessionalBusinessRegisterPageState extends State<ProfessionalBusinessRegisterPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _fanpageController = TextEditingController();
  String _industrySelected;
  String _categorySelected;

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
      child: Container(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    BlocBuilder<ProfessionalBloc, ProfessionalState>(
                      builder: (context, state) {
                        // ignore: close_sinks
                        final bloc = ProfessionalBloc.of(context);
                        bloc.add(GetIndustriesForProfessional());

                        String text = '';

                        if (state.status == ProfessionalStatus.readyIndustries) {
                          return Column(
                            children: [
                              _buildIndustiesSelect(state.industries.industries),
                              SizedBox(height: 12),
                              _buildCategoriesSelect(state.industries.categories),
                            ],
                          );
                        } else if (state.status == ProfessionalStatus.error) {
                          text = 'Error';
                        } else {
                          text = allTranslations.traslate('loading_message');
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: LinearProgressIndicator(),
                            ),
                            Text(text)
                          ]
                        );
                      }
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
                    SizedBox(height: 40),
                    _buildSaveButton()
                  ]
                )
              ),
            )
          ]
        )
      )
    );
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
    return InputFormField(
      hint: allTranslations.traslate('business_address_placeholder'),
      label: allTranslations.traslate('business_address_label'),
      inputType: TextInputType.text,
      controller: _addressController,
      maxLength: 100
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

  Widget _buildSaveButton() {
    return RoundedButton(
      label: allTranslations.traslate('register_button_text'),
      backgroundColor: secondaryDarkColor,
      width: double.infinity,
      onPressed: () => {}
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
            items: categories.map((Category item) {
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
}