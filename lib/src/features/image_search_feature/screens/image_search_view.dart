// screens/image_search_view.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/images_provider.dart'; // Assuming you have an ImageProvider

class ImageSearchView extends StatefulWidget {
  const ImageSearchView({super.key});
  static const routeName = "/imageSearch";

  @override
  ImageSearchViewState createState() => ImageSearchViewState();
}

class ImageSearchViewState extends State<ImageSearchView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    //check if timer is active
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    //start timer and fetch images
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      final provider = Provider.of<ImagesProvider>(context, listen: false);
      provider.resetSearch();
      provider.fetchImages(query: _searchController.text);
    });
  }

  void _fetchMoreImages(ImagesProvider imagesProvider) {
    if (imagesProvider.hasMore && !imagesProvider.isLoading) {
      imagesProvider.loadMoreImages();
    } else if (!imagesProvider.hasMore) {
      imagesProvider.fetchImages(query: _searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for images...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _onSearchChanged(),
            ),
          ),
        ),
      ),
      body: Consumer<ImagesProvider>(
        builder: (context, imagesProvider, child) {
          if (imagesProvider.isLoading &&
              imagesProvider.displayedImages.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (imagesProvider.displayedImages.isEmpty) {
            return const Center(child: Text('No images found'));
          } else {
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  _fetchMoreImages(imagesProvider);
                }
                return true;
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 8.0, // Horizontal space between items
                    mainAxisSpacing: 8.0, // Vertical space between items
                    childAspectRatio: 1.0, // Aspect ratio for each item
                  ),
                  itemCount: imagesProvider.displayedImages.length +
                      (imagesProvider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == imagesProvider.displayedImages.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final image = imagesProvider.displayedImages[index];
                    return ClipRRect(
                      borderRadius:
                          BorderRadius.circular(16.0), // Rounded corners
                      child: Image.network(
                        image.url,
                        fit: BoxFit.cover, // Scale image to cover the container
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
