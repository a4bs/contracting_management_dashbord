import 'package:get/get.dart';

class PageDataPagnationController<T> extends GetxService {
  var items = <T>[].obs; // Observable list of items
  var showLoader = false.obs; // Observable loader state
  var page = 1.obs;
  var limit = 10.obs;
  // Fetch data function
  Future<void> fetchData(
    Future<List<T>?> Function(int page, int limit) handelData,
  ) async {
    showLoader.value = true;
    try {
      var fetchedItems = await handelData(page.value, limit.value);
      if (fetchedItems != null) {
        items.assignAll(fetchedItems); // Update the list
      }
    } catch (e) {
    } finally {
      showLoader.value = false;
    }
  }

  Future<void> fetchDatamore(
    Future<List<T>?> Function(int page, int limit) handelData,
  ) async {
    showLoader.value = true;
    try {
      var fetchedItems = await handelData(page.value, limit.value);
      if (fetchedItems != null) {
        items.addAll(fetchedItems); // Update the list
      }
    } catch (e) {
    } finally {
      showLoader.value = false;
    }
  }

  // Add item
  Future<void> addItem(T newItem) async {
    items.insert(0, newItem);
    items.refresh();
  }

  // Update item
  Future<void> updateItem(int index, T updatedItem) async {
    items[index] = updatedItem;
  }

  // Remove item
  Future<void> removeItem(int index) async {
    items.removeAt(index);
  }

  // Refresh items
  Future<void> refreshItems(
    Future<List<T>?> Function(int page, int limit) customRefresh,
  ) async {
    showLoader.value = true;
    page.value = 1;
    limit.value = 10;
    items.clear();
    var fetchedItems = await customRefresh(page.value, limit.value);
    if (fetchedItems != null) {
      items.assignAll(fetchedItems); // Update the list
    }
    showLoader.value = false;
  }
}
