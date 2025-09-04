import 'package:grocery_app/core/utils/error/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CarosualService {
  final SupabaseClient supabaseClient;

  CarosualService({required this.supabaseClient});

  Future<void> getCarosual() async {
    try {
      await supabaseClient.storage.from('carosual').list();
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}
