import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grocery_app/app.dart';
import 'package:grocery_app/core/service/supabase/supabase_sevice.dart';
import 'package:grocery_app/core/utils/dependancy_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SupabaseService.supaInit();
  setupLocator();
  runApp(const GroceryApp());
}
