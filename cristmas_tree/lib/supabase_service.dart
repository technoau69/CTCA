import 'package:supabase_flutter/supabase_flutter.dart';
import 'booking.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

  /// Save a booking to Supabase
  static Future<void> saveBookingToCloud(Booking booking, String treeType) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      await _client.from('trees').insert({
        'user_id': user.id,
        'tree_name': treeType,
        'decoration_count': 0, // optional
        'supabase_url': '', // optional if uploading images later
        'created_at': DateTime.now().toIso8601String(),
      });

      print("✅ Booking uploaded to Supabase!");
    } catch (e) {
      print("❌ Supabase upload failed: $e");
    }
  }
}
