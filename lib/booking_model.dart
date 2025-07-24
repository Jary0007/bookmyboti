class Booking {
  final String eventType;
  final DateTime eventDate;
  final String location;
  final int guests;

  Booking({
    required this.eventType,
    required this.eventDate,
    required this.location,
    required this.guests,
  });
}

// Shared in-memory booking list for MVP
List<Booking> sharedBookings = [];
