abstract class ProfessionalEvent { }

class GetBusinessForProfessional extends ProfessionalEvent {
  final int professionalId;

  GetBusinessForProfessional(this.professionalId);
}