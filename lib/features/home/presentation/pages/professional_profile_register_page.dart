import 'package:flutter/material.dart';
import 'package:service_now/blocs/user_bloc.dart';
import 'package:service_now/features/professional/presentation/widgets/animation_fab.dart';
import 'package:service_now/models/user.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_form_field.dart';
import 'package:service_now/widgets/rounded_button.dart';
import 'package:service_now/widgets/success_page.dart';
import 'home_page.dart';

class ProfessionalProfileRegisterPage extends StatefulWidget {
  static final routeName = 'professional_profile_register_page';

  final UserProfile profile;

  const ProfessionalProfileRegisterPage({ @required this.profile });

  @override
  _ProfessionalProfileRegisterPageState createState() => _ProfessionalProfileRegisterPageState();
}

class _ProfessionalProfileRegisterPageState extends State<ProfessionalProfileRegisterPage> {
  final _phoneController = TextEditingController();
  final _resumeController = TextEditingController();
  final _facebookPageController = TextEditingController();
  final _linkedinPageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.profile != null) {
      _phoneController.text        = widget.profile.phone;
      _resumeController.text       = widget.profile.resume;
      _facebookPageController.text = widget.profile.facebookPage;
      _linkedinPageController.text = widget.profile.linkedin;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile == null ? allTranslations.traslate('register_professional_profile_title') : allTranslations.traslate('actualziar_perfil_profesional'), style: labelTitleForm),
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
                _buildPhone(),
                SizedBox(height: 20),
                _buildResume(),
                SizedBox(height: 10),
                _buildFacebook(),
                SizedBox(height: 20),
                _buildLinkedin(),
                SizedBox(height: 30),
                _buildSaveButton()
              ]
            )
          )
        )
      ]
    );
  }

  Widget _buildPhone() {
    return InputFormField(
      hint: allTranslations.traslate('professional_phone_placeholder'),
      label: allTranslations.traslate('professional_phone_label'),
      inputType: TextInputType.number,
      controller: _phoneController,
      maxLength: 20
    );
  }

  Widget _buildResume() {
    return InputFormField(
      hint: allTranslations.traslate('professional_resume_placeholder'),
      label: allTranslations.traslate('professional_resume_label'),
      inputType: TextInputType.text,
      controller: _resumeController,
      maxLength: 500,
      maxLines: 5,
      counterText: '${_resumeController.text.length}/500',
      onChanged: (String text) {
        setState(() {});
      }
    );
  }

  Widget _buildFacebook() {
    return InputFormField(
      hint: allTranslations.traslate('professional_page_placeholder'),
      label: allTranslations.traslate('professional_page_label'),
      inputType: TextInputType.text,
      controller: _facebookPageController,
      maxLength: 100
    );
  }

  Widget _buildLinkedin() {
    return InputFormField(
      hint: allTranslations.traslate('professional_profile_placeholder'),
      label: allTranslations.traslate('professional_profile_label'),
      inputType: TextInputType.text,
      controller: _linkedinPageController,
      maxLength: 100
    );
  }

  Widget _buildSaveButton() {
    return RoundedButton(
      label: allTranslations.traslate(widget.profile == null ? 'register_button_text' : 'update_button_text'),
      backgroundColor: secondaryDarkColor,
      width: double.infinity,
      onPressed: widget.profile == null ? () {
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

        bloc.registerProfessionalProfile(_phoneController.text ?? '', _resumeController.text ?? '', _facebookPageController.text ?? '', _linkedinPageController.text ?? '');
        bloc.profileRegisterResponse.listen((response) {
          if (response.error == 0) {
            UserPreferences.instance.profileId = response.data.id;
            Navigator.of(context).pop();
            Navigator.of(context).push(FadeRouteBuilder(page: SuccessPage(message: 'El perfil profesional ha sido registrado exitosamente.', assetImage: 'assets/images/check.png', page: Container(), levelsNumber: 1, pageName: HomePage.routeName)));
          } else if (response.error == 2) {
            Navigator.of(context).pop();

            String facebook = response.validation[0]['facebook_page'] != null ? response.validation[0]['facebook_page'][0] + '\n' : '';
            String linkedin = response.validation[0]['linkedin'] != null ? response.validation[0]['linkedin'][0] + '\n' : '';
            String resume = response.validation[0]['resume'] != null ? response.validation[0]['resume'][0] : '';
            String message = facebook + linkedin + resume;

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
      } : null
    );
  }
}