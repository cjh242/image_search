import 'package:flutter/material.dart';
import 'package:image_search/src/features/image_search_feature/providers/images_provider.dart';
import 'package:image_search/src/features/image_search_feature/services/image_service.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';
import 'src/features/settings_feature/settings_controller.dart';
import 'src/features/settings_feature/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  //in an a real app, this api key would never be in the code, even for one commit.
  //i just figured for the sake of you being apple to run it and it being a free key,
  // i would just leave it here.
  final imageService = ImageService(
      "34cd24379f876d332c82c30ad54fadacbfa1452e35b68115bf7c63c4168850a5");

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ImagesProvider(imageService)),
  ], child: MyApp(settingsController: settingsController)));
}
