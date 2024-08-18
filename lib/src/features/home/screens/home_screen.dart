import 'package:flutter/material.dart';
import 'package:image_search/src/features/image_search_feature/screens/image_search_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ImageSearchView(),
              ),
            );
          },
          child: const Text('Go to Image Search'),
        ),
      ),
    );
  }
}
