import 'package:get/get.dart';

class PaginationController<T> extends GetxService {
  var items = <T>[].obs; // Observable list of items
  var showLoader = false.obs; // Observable loader state
  int page = 1;
  int perPage = 10;
  Rxn<T> selectedItem = Rxn<T>();

  // Fetch data function
  Future<void> fetchData(Future<List<T>?> Function() handelData) async {
    showLoader.value = true;
    try {
      var fetchedItems = await handelData();
      if (fetchedItems != null) {
        items.assignAll(fetchedItems); // Update the list
      }
    } catch (e) {
    } finally {
      showLoader.value = false;
    }
  }

  Future<void> fetchDataWithParams(
    Future<List<T>?> Function(int page, int perPage) handelData,
  ) async {
    showLoader.value = true;
    try {
      var fetchedItems = await handelData(page, perPage);
      if (fetchedItems != null) {
        items.assignAll(fetchedItems); // Update the list
      }
    } catch (e) {
    } finally {
      showLoader.value = false;
    }
  }

  // Add item
  Future<void> addItem(T newItem) async {
    items.add(newItem);
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
  refreshItems(Future<List<T>?> Function() customRefresh) async {
    showLoader.value = true;

    items.clear();
    var fetchedItems = await customRefresh();
    if (fetchedItems != null) {
      items.assignAll(fetchedItems); // Update the list
    }
    showLoader.value = false;
  }
}
