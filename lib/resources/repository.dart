import 'package:service_now/models/appointment.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/models/promotion.dart';
import 'package:service_now/models/user.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'appointment_api_provider.dart';
import 'professional_api_provider.dart';
import 'user_api_provider.dart';

class Repository {
  final professionalApiProvider = ProfessionalApiProvider();
  final userApiProvider = UserApiProvider();
  final appointmentApiProvider = AppointmentApiProvider();

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
  Future<RequestResponse> obtenerBandejaSolicitudes(int businessId) => professionalApiProvider.obtenerBandejaSolicitudes(businessId);
  Future<void> aprobarSolicitud(int id) => professionalApiProvider.aprobarSolicitud(id);
  Future<void> denegarSolicitud(int id) => professionalApiProvider.denegarSolicitud(id);

  // USER
  Future<UserCRUDResponse> registerProfessionalProfile(String phone, String resume, String facebook, String linkedin) => userApiProvider.registerProfessionalProfile(phone, resume, facebook, linkedin);
  Future<ProfileResponse> fetchProfile(int id) => userApiProvider.fetchProfile(id);
  Future<UserCRUDResponse> registerProfessionalAptitude(String title, String description, int professionalId, List<Asset> images) => userApiProvider.registerProfessionalAptitude(title, description, professionalId, images);
  Future<AptitudeResponse> fetchAptitudes(int id) => userApiProvider.fetchAptitudes(id);

  // APPOINTMENT
  Future<AppointmentCRUDResponse> solicitarColaboracion(int businessId) => appointmentApiProvider.solicitarColaboracion(businessId);
}