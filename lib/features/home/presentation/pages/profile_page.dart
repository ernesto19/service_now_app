import 'package:flutter/material.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

class ProfilePage extends StatefulWidget {
  static final routeName = 'profile_page';

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextStyle textStyle = TextStyle(fontSize: 16.0);
  String _nombreCompleto = '';
  String versionName = '1.0.0';
  
  // _obtenerVersion() {
  //   PackageInfo.fromPlatform().then((packageInfo) {
  //     setState(() {
  //       versionName = packageInfo.version;
  //     });
  //   });
  // }

  @override
  void initState() {
    _obtenerDatos();
    // _obtenerVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil', style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30, child: Container(color: backgroundColor)),
              _crearCabecera(),
              SizedBox(height: 30, child: Container(color: backgroundColor)),
              // _crearSeparador(),
              // _crearIrAInformacion(),
              _crearSeparador(),
              _crearIrACambioContrasena(),
              _crearSeparador(),
              SizedBox(height: 40.0, child: Container(color: backgroundColor)),
              _crearBotonLogOut(),
              SizedBox(height: 30.0),
              Text('Service Now v$versionName', style: TextStyle(fontSize: 10.0)),
              SizedBox(height: 25.0)
            ],
          ),
        )
      ),
    );
  }

  Widget _crearSeparador() {
    return Container(
      child: SizedBox(
        height: 30.0, 
        child: Container(
          color: Color.fromRGBO(236, 236, 236, 1.0)
        )
      )
    );
  }

  // Widget _crearIrAInformacion() {
  //   return InkWell(
  //     child: Container(
  //       padding: EdgeInsets.all(20.0),
  //       child: Row(
  //         children: <Widget>[
  //           Expanded(
  //             flex: 1,
  //             child: SizedBox(),
  //           ),
  //           Expanded(
  //             flex: 4,
  //             child: Center(
  //               child: Text('Mi información')
  //             ),
  //           ),
  //           Expanded(
  //             flex: 1,
  //             child: Icon(Icons.keyboard_arrow_right),
  //           )
  //         ],
  //       ),
  //     ),
  //     onTap: () {
  //       // Navigator.pushNamed(context, 'informacion_usuario');
  //     },
  //   );
  // }

  Widget _crearIrACambioContrasena() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Text('Cambiar contraseña')
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
      ),
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
      },
    );
  }

  Widget _crearCabecera() {
    return Container(
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  "assets/images/profile_placeholder.png",
                  fit: BoxFit.contain,
                  height: 80,
                ),
                SizedBox(height: 20),
                Text(_nombreCompleto, style: TextStyle(fontSize: 19)),
                SizedBox(height: 7),
                Text(UserPreferences.instance.email, style: TextStyle(fontSize: 13))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _crearBotonLogOut() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 14.0),
        child: Text('Cerrar sesión', style: textStyle),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      elevation: 0.0,
      color: Colors.red,
      textColor: Colors.white,
      onPressed: () {
        // ProgressDialogWidget alert = new ProgressDialogWidget();
        // alert.show(context, 'Cerrando sesión ...');
        // loginProvider.logOut(preferencias.idUsuario, preferencias.fcmToken).then((responseLogOut) {
        //   if (responseLogOut.error == 0) {
        //     _clearData();
        //     DBProvider.db.deletePermissions().then((response) {
        //       DBProvider.db.deleteSubMenu().then((responseSubMenu) {
        //         Navigator.pop(context);
        //         Navigator.pushReplacementNamed(context, 'login');
        //       });
        //     });
        //   } else if (responseLogOut.error == 401) {
        //     showDialog(
        //       context: context,
        //       barrierDismissible: false,
        //       builder: (BuildContext context) {
        //         return WillPopScope(
        //           onWillPop: () async => false,
        //           child: ExpiredTokenDialog()
        //         );
        //       }
        //     );
        //   }
        // });
      }
    );
  }

  void _obtenerDatos() async {
    setState(() {
      _nombreCompleto = UserPreferences.instance.firstName + ' ' + UserPreferences.instance.lastName;
    });
  }

  // void _clearData() {
  //   preferencias.nombreUsuario    = '';
  //   preferencias.codigoTrabajador = '';
  //   preferencias.idRol            = '';
  //   preferencias.descripcionRol   = '';
  //   preferencias.genero           = '';
  //   preferencias.anioIngreso      = '';
  //   preferencias.consultora       = '';
  //   preferencias.nombreConsultora = '';
  //   preferencias.codigoCliente    = '';
  //   preferencias.nombreCliente    = '';
  //   preferencias.codigoCentroCosto = '';
  //   preferencias.nombreCentroCosto = '';
  //   preferencias.fechaIngreso     = '';
  //   preferencias.remuneracion     = '';
  //   preferencias.puesto           = '';
  //   preferencias.idUsuario        = '';
  //   preferencias.salary           = '';
  //   preferencias.accessToken      = '';
  //   preferencias.countMessages    = 0;
  //   preferencias.countVacationRequest = 0;
  //   preferencias.countAccessAuthorizationRequest = 0;
  //   preferencias.countTransferAuthorizationRequest = 0;
  //   preferencias.countMedicalBreakRequest = 0;
  //   preferencias.inicioSesion     = '0';
  //   preferencias.saldoVacaciones = '0.0';
  //   preferencias.vacacionesTruncas = '0.0';
  //   preferencias.codigoResponsable = '';
  // }
}