abstract class ProfessionalEvent { }

class GetBusinessForProfessional extends ProfessionalEvent {
  final int professionalId;

  GetBusinessForProfessional(this.professionalId);
}

class GetServicesForProfessional extends ProfessionalEvent {
  final int professionalBusinessId;

  GetServicesForProfessional(this.professionalBusinessId);
}

class GetIndustriesForProfessional extends ProfessionalEvent {

  GetIndustriesForProfessional();
}

class OnActiveEvent extends ProfessionalEvent {
  final int id;

  OnActiveEvent(this.id);
}