import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:service_now/blocs/user_bloc.dart';
import 'package:service_now/models/user.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_form_field.dart';
import 'professional_aptitudes_page.dart';

class ProfessionalProfilePage extends StatefulWidget {
  @override
  _ProfessionalProfilePageState createState() => _ProfessionalProfilePageState();
}

class _ProfessionalProfilePageState extends State<ProfessionalProfilePage> {
  final _phoneController = TextEditingController();
  final _resumeController = TextEditingController();
  final _facebookPageController = TextEditingController();
  final _linkedinPageController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    
    bloc.fetchProfile(UserPreferences.instance.userId);
  }

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: 'Editar',
        currentButton: FloatingActionButton(
          heroTag: "editar",
          backgroundColor: secondaryDarkColor,
          mini: true,
          child: Icon(Icons.edit),
          onPressed: () {},
        )
      )
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: 'Aptitudes',
        currentButton: FloatingActionButton(
          heroTag: "aptitudes",
          backgroundColor: secondaryDarkColor,
          mini: true,
          child: Icon(Icons.assignment),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalAptitudesPage(/*profileId: UserPreferences.instance.profileId*/)))
        )
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('professional_profile_title'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: SafeArea(
        child: _buildBody(context)
      ),
      floatingActionButton: UnicornDialer(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
        parentButtonBackground: secondaryDarkColor,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.menu),
        childButtons: childButtons
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: StreamBuilder(
            stream: bloc.profile,
            builder: (context, AsyncSnapshot<ProfileResponse> snapshot) {
              if (snapshot.hasData) {
                ProfileResponse profile = snapshot.data;
                _phoneController.text = profile.data.phone;
                _resumeController.text = profile.data.resume;
                _facebookPageController.text = profile.data.facebookPage;
                _linkedinPageController.text = profile.data.linkedin;
          
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      _buildPhone(),
                      SizedBox(height: 20),
                      _buildResume(),
                      SizedBox(height: 10),
                      _buildFacebook(),
                      SizedBox(height: 20),
                      _buildLinkedin()
                    ]
                  )
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return Center(
                child: CircularProgressIndicator()
              );
            }
          )
        )
      ]
    );
  }

  Widget _buildPhone() {
    return InputFormField(
      label: allTranslations.traslate('professional_phone_label'),
      inputType: TextInputType.number,
      controller: _phoneController,
      maxLength: 20,
      enabled: false
    );
  }

  Widget _buildResume() {
    return InputFormField(
      label: allTranslations.traslate('professional_resume_label'),
      inputType: TextInputType.text,
      controller: _resumeController,
      maxLength: 500,
      maxLines: 5,
      enabled: false
    );
  }

  Widget _buildFacebook() {
    return InputFormField(
      label: allTranslations.traslate('professional_page_label'),
      inputType: TextInputType.text,
      controller: _facebookPageController,
      maxLength: 100,
      enabled: false
    );
  }

  Widget _buildLinkedin() {
    return InputFormField(
      label: allTranslations.traslate('professional_profile_label'),
      inputType: TextInputType.text,
      controller: _linkedinPageController,
      maxLength: 100,
      enabled: false
    );
  }
}