import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'booking.dart';
import 'hive_service.dart';
import 'supabase_service.dart';

class BookingFormScreen extends StatefulWidget {
  final String treeType;
  const BookingFormScreen({super.key, required this.treeType});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  DateTime? selectedDateTime;

  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null) return;
    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> saveBooking() async {
    if (!_formKey.currentState!.validate() || selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    final booking = Booking(
      name: nameCtrl.text,
      phone: phoneCtrl.text,
      dateTime: selectedDateTime!,
    );

    await HiveService.saveBooking(booking);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking saved locally!")),
    );

    await SupabaseService.saveBookingToCloud(booking, widget.treeType);
    // await FirestoreService.saveBookingToCloud(booking);
    // await SupabaseService.saveBooking(booking);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book ${widget.treeType.toUpperCase()}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Your Name"),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: "Phone Number"),
                validator: (v) => v!.isEmpty ? "Enter phone" : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(selectedDateTime == null
                        ? "No date selected"
                        : "📅 ${DateFormat('dd MMM yyyy, hh:mm a').format(selectedDateTime!)}"),
                  ),
                  ElevatedButton(
                    onPressed: pickDateTime,
                    child: const Text("Pick Date & Time"),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: saveBooking,
                icon: const Icon(Icons.check),
                label: const Text("Confirm Booking"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
