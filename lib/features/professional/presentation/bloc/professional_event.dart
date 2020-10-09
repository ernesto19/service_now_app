abstract class ProfessionalEvent { }

class GetBusinessForProfessional extends ProfessionalEvent {
  final int professionalId;

  GetBusinessForProfessional(this.professionalId);
}

class GetServicesForProfessional extends ProfessionalEvent {
  final int professionalBusinessId;

  GetServicesForProfessional(this.professionalBusinessId);
}