import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'hive_service.dart';
import 'booking.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    final data = await HiveService.getAllBookings();
    setState(() => bookings = data);
  }

  Future<void> deleteBooking(int index) async {
    await HiveService.deleteBooking(index);
    loadBookings();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking cancelled")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: bookings.isEmpty
          ? const Center(child: Text("No bookings yet."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final b = bookings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 5,
            child: ListTile(
              leading: const Icon(Icons.event_available, color: Colors.green),
              title: Text(b.name),
              subtitle: Text(
                "📞 ${b.phone}\n🗓 ${DateFormat('dd MMM yyyy, hh:mm a').format(b.dateTime)}",
              ),
              trailing: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.redAccent),
                onPressed: () => deleteBooking(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
