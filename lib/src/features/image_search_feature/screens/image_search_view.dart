// screens/image_search_view.dart
import 'dart:async';
import 'package:image_search/src/features/image_search_feature/screens/image_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/images_provider.dart';

class ImageSearchView extends StatefulWidget {
  const ImageSearchView({super.key});

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

  Future<void> _launchPexelsUrl() async {
    final Uri url = Uri.parse('https://www.pexels.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for images...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) => _onSearchChanged(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                _launchPexelsUrl();
              },
              //giving pexels credit as per thier api documentation
              child: Image.network(
                'https://images.pexels.com/lib/api/pexels-white.png',
                height: 40,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
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
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageDetailScreen(
                                      image: image,
                                    )),
                          );
                        },
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(16.0), // Rounded corners
                          child: Image.network(
                            image.url,
                            fit: BoxFit.cover,
                          ),
                        ));
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
