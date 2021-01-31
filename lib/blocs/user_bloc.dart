import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/models/user.dart';
import 'package:service_now/resources/repository.dart';

class UserBloc {
  final _repository = Repository();
  final _profileRegister = PublishSubject<UserCRUDResponse>();
  final _profileFetcher = PublishSubject<ProfileResponse>();
  final _aptitudeRegister = PublishSubject<UserCRUDResponse>();
  final _aptitudesFetcher = PublishSubject<AptitudeResponse>();
  final _conditionsFetcher = PublishSubject<ConditionsResponse>();
  final _membershipResponse = PublishSubject<MembershipResponse>();
  final _solicitudRecuperarResponse = PublishSubject<UserCRUDResponse>();
  final _recuperarResponse = PublishSubject<UserCRUDResponse>();
  final _cambiarResponse = PublishSubject<PasswordCRUDResponse>();

  Observable<UserCRUDResponse> get profileRegisterResponse => _profileRegister.stream;
  Observable<ProfileResponse> get profile => _profileFetcher.stream;
  Observable<UserCRUDResponse> get aptitudeRegisterResponse => _aptitudeRegister.stream;
  Observable<AptitudeResponse> get allAptitudes => _aptitudesFetcher.stream;
  Observable<ConditionsResponse> get allConditions => _conditionsFetcher.stream;
  Observable<MembershipResponse> get membershipResponse => _membershipResponse.stream;
  Observable<UserCRUDResponse> get solicitudRecuperarResponse => _solicitudRecuperarResponse.stream;
  Observable<UserCRUDResponse> get recuperarResponse => _recuperarResponse.stream;
  Observable<PasswordCRUDResponse> get cambiarResponse => _cambiarResponse.stream;

  Future registerProfessionalProfile(String phone, String resume, String facebook, String linkedin) async {
    UserCRUDResponse response = await _repository.registerProfessionalProfile(phone, resume, facebook, linkedin);
    _profileRegister.sink.add(response);
  }

  Future fetchProfile(int id) async {
    ProfileResponse response = await _repository.fetchProfile(id);
    _profileFetcher.sink.add(response);
  }

  Future registerProfessionalAptitude(String title, String description, int professionalId, List<Asset> images) async {
    UserCRUDResponse response = await _repository.registerProfessionalAptitude(title, description, professionalId, images);
    _aptitudeRegister.sink.add(response);
  }

  Future fetchAptitudes(int id) async {
    AptitudeResponse response = await _repository.fetchAptitudes(id);
    _aptitudesFetcher.sink.add(response);
  }

  Future fetchConditions() async {
    ConditionsResponse response = await _repository.fetchConditions();
    _conditionsFetcher.sink.add(response);
  }

  Future acquireMembership() async {
    MembershipResponse response = await _repository.acquireMembership();
    _membershipResponse.sink.add(response);
  }

  Future solicitudRecuperarContrasena(String email) async {
    UserCRUDResponse response = await _repository.solicitudRecuperarContrasena(email);
    _solicitudRecuperarResponse.sink.add(response);
  }

  Future recuperarContrasena(String code, String password, String passwordConfirm) async {
    UserCRUDResponse response = await _repository.recuperarContrasena(code, password, passwordConfirm);
    _recuperarResponse.sink.add(response);
  }

  Future cambiarContrasena(String currentPassword, String password, String passwordConfirm) async {
    PasswordCRUDResponse response = await _repository.cambiarContrasena(currentPassword, password, passwordConfirm);
    _cambiarResponse.sink.add(response);
  }

  dispose() {
    _profileRegister.close();
    _profileFetcher.close();
    _aptitudeRegister.close();
    _aptitudesFetcher.close();
    _conditionsFetcher.close();
    _membershipResponse.close();
    _solicitudRecuperarResponse.close();
    _recuperarResponse.close();
    _cambiarResponse.close();
  }
}

final bloc = UserBloc();