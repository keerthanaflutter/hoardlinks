class ChittyAuctionBid {
  final int id;
  final int chittyId;
  final int cycleId;
  final String eventType;
  final DateTime eventDateTime;
  final String status;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChittyAuctionBid({
    required this.id,
    required this.chittyId,
    required this.cycleId,
    required this.eventType,
    required this.eventDateTime,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChittyAuctionBid.fromJson(Map<String, dynamic> json) {
    return ChittyAuctionBid(
      id: json['id'] ?? 0,
      chittyId: json['chitty_id'] ?? 0,
      cycleId: json['cycle_id'] ?? 0,
      eventType: json['event_type'] ?? '',
      // Note: Using 'event_datetime' as per your Postman response
      eventDateTime: DateTime.parse(json['event_datetime'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}