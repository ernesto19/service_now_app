import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:service_now/models/user.dart';
import 'package:service_now/resources/repository.dart';

class UserBloc {
  final _repository = Repository();
  final _profileRegister = PublishSubject<UserCRUDResponse>();
  final _profileFetcher = PublishSubject<ProfileResponse>();
  final _aptitudeRegister = PublishSubject<UserCRUDResponse>();
  final _aptitudesFetcher = PublishSubject<AptitudeResponse>();

  Observable<UserCRUDResponse> get profileRegisterResponse => _profileRegister.stream;
  Observable<ProfileResponse> get profile => _profileFetcher.stream;
  Observable<UserCRUDResponse> get aptitudeRegisterResponse => _aptitudeRegister.stream;
  Observable<AptitudeResponse> get allAptitudes => _aptitudesFetcher.stream;

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

  dispose() {
    _profileRegister.close();
    _profileFetcher.close();
    _aptitudeRegister.close();
    _aptitudesFetcher.close();
  }
}

final bloc = UserBloc();