abstract class SelectBusinessEvent { }

class RequestBusinessForUser extends SelectBusinessEvent {
  final int businessId;

  RequestBusinessForUser(this.businessId);
}