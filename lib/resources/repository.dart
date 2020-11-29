import 'package:service_now/models/professional_business.dart';
import 'package:service_now/models/promotion.dart';

import 'professional_api_provider.dart';

class Repository {
  final professionalApiProvider = ProfessionalApiProvider();

  // PROFESIONAL
  Future<ProfessionalBusinessResponse> fetchProfessionalBusiness() => professionalApiProvider.fetchProfessionalBusiness();
  Future<GalleryResponse> fetchProfessionalBusinessGallery(int id) => professionalApiProvider.fetchProfessionalBusinessGallery(id);
  Future<GalleryResponse> fetchProfessionalServiceGallery(int id) => professionalApiProvider.fetchProfessionalServiceGallery(id);
  Future<ProfessionalCRUDResponse> deleteBusinessImage(int id) => professionalApiProvider.deleteBusinessImage(id);
  Future<ProfessionalCRUDResponse> deleteServiceImage(int id) => professionalApiProvider.deleteServiceImage(id);
  Future<void> updateBusinessStatus(int id) => professionalApiProvider.updateBusinessStatus(id);
  Future<ProfessionalCRUDResponse> registerPromotion(String name, String description, var amount, String type, int businessId) => professionalApiProvider.registerPromotion(name, description, amount, type, businessId);
  Future<PromotionResponse> fetchPromotions(int id) => professionalApiProvider.fetchPromotions(id);
  Future<void> updatePromotionStatus(int id, int status) => professionalApiProvider.updatePromotionStatus(id, status);
}