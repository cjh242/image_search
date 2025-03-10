// providers/image_provider.dart
import 'package:flutter/material.dart';
import 'package:image_search/src/features/image_search_feature/models/images_results.dart';
import 'package:image_search/src/features/image_search_feature/services/image_service.dart';
import 'package:flutter/foundation.dart';

class ImagesProvider extends ChangeNotifier {
  final ImageService _imageService; // Use the service
  final List<ImagesResults> _allImages = []; // Cache for all fetched images
  final List<ImagesResults> _displayedImages =
      []; // Images currently shown on the screen
  bool _isLoading = false;
  int _currentPage = 0;
  bool _hasMore = true;
  final int _pageSize = 10; // Number of images to display at a time

  ImagesProvider(this._imageService);

  List<ImagesResults> get displayedImages => _displayedImages;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchImages({required String query}) async {
    if (_isLoading) return;

    _isLoading = true;
    //notify the page that we are loading
    notifyListeners();

    try {
      //increase the page number
      _currentPage++;
      //call the api
      final List<ImagesResults> newImages =
          await _imageService.fetchImagesFromApi(query, _currentPage);

      //respond to the case where we dont get any images back
      if (newImages.isEmpty) {
        _hasMore = false;
      } else {
        _allImages.addAll(newImages);
        _hasMore = true;
        _updateDisplayedImages();
      }
    } catch (error) {
      _hasMore = false;
      //logging the error here would be good
    } finally {
      _isLoading = false;
      //notify the page of changes
      notifyListeners();
    }
  }

  void _updateDisplayedImages() {
    if (_allImages.isNotEmpty) {
      // Add the next page of images to be displayed
      final int startIndex = _displayedImages.length;
      final int endIndex = (startIndex + _pageSize < _allImages.length)
          ? startIndex + _pageSize
          : _allImages.length;
      _displayedImages.addAll(_allImages.sublist(startIndex, endIndex));
      //if there are less than 10 left, we will call the api again.
      if (_displayedImages.length >= (_allImages.length - 10)) {
        _hasMore = false;
      }
    }
  }

  void loadMoreImages() {
    //check to make sure there are more images to load and the page isnt currently loading
    if (_hasMore && !_isLoading) {
      _updateDisplayedImages();
      notifyListeners();
    }
  }

  void resetSearch() {
    //reset all the search fields
    _allImages.clear();
    _displayedImages.clear();
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }
}
