import 'package:service_now/features/appointment/domain/entities/service.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/models/appointment.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/models/promotion.dart';
import 'package:service_now/models/user.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'appointment_api_provider.dart';
import 'client_api_provider.dart';
import 'professional_api_provider.dart';
import 'user_api_provider.dart';

class Repository {
  final professionalApiProvider = ProfessionalApiProvider();
  final userApiProvider = UserApiProvider();
  final appointmentApiProvider = AppointmentApiProvider();
  final clientApiProvider = ClientApiProvider();

  // PROFESIONAL
  Future<ProfessionalBusinessResponse> fetchProfessionalBusiness() => professionalApiProvider.fetchProfessionalBusiness();
  Future<GalleryResponse> fetchProfessionalBusinessGallery(int id) => professionalApiProvider.fetchProfessionalBusinessGallery(id);
  Future<GalleryResponse> fetchProfessionalServiceGallery(int id) => professionalApiProvider.fetchProfessionalServiceGallery(id);
  Future<ProfessionalCRUDResponse> deleteBusinessImage(int id) => professionalApiProvider.deleteBusinessImage(id);
  Future<ProfessionalCRUDResponse> deleteServiceImage(int id) => professionalApiProvider.deleteServiceImage(id);
  Future<void> updateBusinessStatus(int id) => professionalApiProvider.updateBusinessStatus(id);
  Future<void> updateBusinessProfessionalStatus(int id, int estado) => professionalApiProvider.updateBusinessProfessionalStatus(id, estado);
  Future<ProfessionalCRUDResponse> registerPromotion(String name, String description, var amount, String type, int businessId) => professionalApiProvider.registerPromotion(name, description, amount, type, businessId);
  Future<PromotionResponse> fetchPromotions(int id) => professionalApiProvider.fetchPromotions(id);
  Future<void> updatePromotionStatus(int id, int status) => professionalApiProvider.updatePromotionStatus(id, status);
  Future<RequestResponse> obtenerBandejaSolicitudes(int businessId) => professionalApiProvider.obtenerBandejaSolicitudes(businessId);
  Future<void> aprobarSolicitud(int id) => professionalApiProvider.aprobarSolicitud(id);
  Future<void> denegarSolicitud(int id) => professionalApiProvider.denegarSolicitud(id);
  Future<ProfessionalCRUDResponse> responderSolicitudServicio(List<ProfessionalService> services, int userId) => professionalApiProvider.responderSolicitudServicio(services, userId);
  Future<ServiciosPendientesResponse> obtenerBandejaServiciosPendientes() => professionalApiProvider.obtenerBandejaServiciosPendientes();
  Future<ServicioCRUDResponse> iniciarServicio(int id) => professionalApiProvider.iniciarServicio(id);
  Future<void> terminarServicio(int id) => professionalApiProvider.terminarServicio(id);
  Future<ProfessionalCRUDResponse> agregarImagenesNegocio(int id, List<Asset> images) => professionalApiProvider.agregarImagenesNegocio(id, images);
  Future<ProfessionalCRUDResponse> agregarImagenesServicio(int id, List<Asset> images) => professionalApiProvider.agregarImagenesServicio(id, images);
  Future<ProfessionalCRUDResponse> registerPaypal(String key, String secret, int businessId) => professionalApiProvider.registerPaypal(key, secret, businessId);

  // USER
  Future<UserCRUDResponse> registerProfessionalProfile(String phone, String resume, String facebook, String linkedin) => userApiProvider.registerProfessionalProfile(phone, resume, facebook, linkedin);
  Future<ProfileResponse> fetchProfile(int id) => userApiProvider.fetchProfile(id);
  Future<UserCRUDResponse> registerProfessionalAptitude(String title, String description, int professionalId, List<Asset> images) => userApiProvider.registerProfessionalAptitude(title, description, professionalId, images);
  Future<AptitudeResponse> fetchAptitudes(int id) => userApiProvider.fetchAptitudes(id);
  Future<ConditionsResponse> fetchConditions() => userApiProvider.fetchConditions();
  Future<MembershipResponse> acquireMembership() => userApiProvider.acquireMembership();
  Future<UserCRUDResponse> solicitudRecuperarContrasena(String email) => userApiProvider.solicitudRecuperarContrasena(email);
  Future<UserCRUDResponse> recuperarContrasena(String code, String password, String passwordConfirm) => userApiProvider.recuperarContrasena(code, password, passwordConfirm);
  Future<PasswordCRUDResponse> cambiarContrasena(String currentPassword, String password, String passwordConfirm) => userApiProvider.cambiarContrasena(currentPassword, password, passwordConfirm);

  // APPOINTMENT
  Future<AppointmentCRUDResponse> solicitarColaboracion(int businessId) => appointmentApiProvider.solicitarColaboracion(businessId);
  Future<ProfessionalResponse> obtenerProfesionalesPorNegocio(int businessId) => appointmentApiProvider.obtenerProfesionalesPorNegocio(businessId);
  Future<ProfessionalDetailResponse> obtenerPerfilProfesional(int id) => appointmentApiProvider.obtenerPerfilProfesional(id);
  Future<AppointmentCRUDResponse> solicitarServicio(int businessId, int professionalId) => appointmentApiProvider.solicitarServicio(businessId, professionalId);
  Future<PaymentCRUDResponse> finalizarSolicitud(List<Service> services, int professionalId) => appointmentApiProvider.finalizarSolicitud(services, professionalId);
  Future<AppointmentCRUDResponse> enviarCalificacion(int id, String comentario, double calificacion) => appointmentApiProvider.enviarCalificacion(id, comentario, calificacion);

  // CLIENT
  Future<ServiciosPendientesResponse> obtenerBandejaServicios() => clientApiProvider.obtenerBandejaServicios();
}