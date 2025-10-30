import 'package:hive/hive.dart';

part 'booking.g.dart'; // <-- will be generated later

@HiveType(typeId: 1)
class Booking {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  @HiveField(2)
  final DateTime dateTime;

  Booking({
    required this.name,
    required this.phone,
    required this.dateTime,
  });
}
