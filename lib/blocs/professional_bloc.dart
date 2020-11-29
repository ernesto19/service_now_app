import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/models/promotion.dart';
import 'package:service_now/resources/repository.dart';

class ProfessionalBloc {
  final _repository = Repository();
  final _professionalBusinessFetcher = PublishSubject<ProfessionalBusinessResponse>();
  final _professionalBusinessGalleryFetcher = PublishSubject<GalleryResponse>();
  final _professionalServiceGalleryFetcher = PublishSubject<GalleryResponse>();
  final _businessImageDelete = PublishSubject<ProfessionalCRUDResponse>();
  final _serviceImageDelete = PublishSubject<ProfessionalCRUDResponse>();
  final _businessStatusUpdate = PublishSubject<void>();
  final _promotionRegister = PublishSubject<ProfessionalCRUDResponse>();
  final _promotionsFetcher = PublishSubject<PromotionResponse>();
  final _promotionStatusUpdate = PublishSubject<void>();

  Observable<ProfessionalBusinessResponse> get allProfessionalBusiness => _professionalBusinessFetcher.stream;
  Observable<GalleryResponse> get allProfessionalBusinessGallery => _professionalBusinessGalleryFetcher.stream;
  Observable<GalleryResponse> get allProfessionalServiceGallery => _professionalServiceGalleryFetcher.stream;
  Observable<ProfessionalCRUDResponse> get businessImageDeleteResponse => _businessImageDelete.stream;
  Observable<ProfessionalCRUDResponse> get serviceImageDeleteResponse => _serviceImageDelete.stream;
  Observable<void> get businessStatusUpdateResponse => _businessStatusUpdate.stream;
  Observable<ProfessionalCRUDResponse> get promotionRegisterResponse => _promotionRegister.stream;
  Observable<PromotionResponse> get allPromotions => _promotionsFetcher.stream;
  Observable<void> get promotionStatusUpdateResponse => _promotionStatusUpdate.stream;

  Future fetchProfessionalBusiness() async {
    ProfessionalBusinessResponse response = await _repository.fetchProfessionalBusiness();
    _professionalBusinessFetcher.sink.add(response);
  }

  Future fetchProfessionalBusinessGallery(int id) async {
    GalleryResponse response = await _repository.fetchProfessionalBusinessGallery(id);
    _professionalBusinessGalleryFetcher.sink.add(response);
  }

  Future fetchProfessionalServiceGallery(int id) async {
    GalleryResponse response = await _repository.fetchProfessionalServiceGallery(id);
    _professionalServiceGalleryFetcher.sink.add(response);
  }

  Future deleteBusinessImage(int id) async {
    ProfessionalCRUDResponse response = await _repository.deleteBusinessImage(id);
    _businessImageDelete.sink.add(response);
  }

  Future deleteServiceImage(int id) async {
    ProfessionalCRUDResponse response = await _repository.deleteServiceImage(id);
    _serviceImageDelete.sink.add(response);
  }

  Future updateBusinessStatus(int id) async {
    _businessStatusUpdate.add(await _repository.updateBusinessStatus(id));
  }

  Future registerPromotion(String name, String description, var amount, String type, int businessId) async {
    ProfessionalCRUDResponse response = await _repository.registerPromotion(name, description, amount, type, businessId);
    _promotionRegister.sink.add(response);
  }

  Future fetchPromotions(int id) async {
    PromotionResponse response = await _repository.fetchPromotions(id);
    _promotionsFetcher.sink.add(response);
  }

  Future updatePromotionStatus(int id, int status) async {
    _promotionStatusUpdate.add(await _repository.updatePromotionStatus(id, status));
  }

  dispose() {
    _professionalBusinessFetcher.close();
    _professionalBusinessGalleryFetcher.close();
    _professionalServiceGalleryFetcher.close();
    _businessImageDelete.close();
    _serviceImageDelete.close();
    _businessStatusUpdate.close();
    _promotionRegister.close();
    _promotionsFetcher.close();
    _promotionStatusUpdate.close();
  }
}

final bloc = ProfessionalBloc();