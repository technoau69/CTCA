import 'package:hive/hive.dart';
import 'tree_design.dart';
import 'booking.dart';

class HiveService {
  // Box names
  static const String treesBoxName = 'saved_trees';
  static const String bookingsBoxName = 'bookings';

  // Initialize Hive boxes
  static Future<void> init() async {
    await Hive.openBox<TreeDesign>(treesBoxName);
    await Hive.openBox<Booking>(bookingsBoxName);
  }

  // ===== Tree CRUD =====
  static Future<void> saveTree(TreeDesign design) async {
    final box = Hive.box<TreeDesign>(treesBoxName);
    await box.add(design);
  }

  static Future<List<TreeDesign>> getAllTrees() async {
    final box = Hive.box<TreeDesign>(treesBoxName);
    return box.values.toList();
  }

  static Future<void> deleteTree(int index) async {
    final box = Hive.box<TreeDesign>(treesBoxName);
    await box.deleteAt(index);
  }

  static Future<void> clearAllTrees() async {
    final box = Hive.box<TreeDesign>(treesBoxName);
    await box.clear();
  }

  static Future<void> updateTree(int index, TreeDesign updated) async {
    final box = Hive.box<TreeDesign>(treesBoxName);
    await box.putAt(index, updated);
  }

  // ===== Booking CRUD =====
  static Future<void> saveBooking(Booking booking) async {
    final box = Hive.box<Booking>(bookingsBoxName);
    await box.add(booking);
  }

  static Future<List<Booking>> getAllBookings() async {
    final box = Hive.box<Booking>(bookingsBoxName);
    return box.values.toList();
  }

  static Future<void> deleteBooking(int index) async {
    final box = Hive.box<Booking>(bookingsBoxName);
    await box.deleteAt(index);
  }

  static Future<void> clearAllBookings() async {
    final box = Hive.box<Booking>(bookingsBoxName);
    await box.clear();
  }
}
