import 'package:contracting_management_dashbord/model/file_upload_model.dart';
import 'package:contracting_management_dashbord/repo/file_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class FileUploadItem {
  final String id;
  final String path;
  final String name;
  final int size;
  RxDouble progress = 0.0.obs;
  RxString status = 'pending'.obs; // pending, uploading, success, error
  String? link;
  String? errorMessage;

  FileUploadItem({
    required this.id,
    required this.path,
    required this.name,
    required this.size,
  });
}

class FileUploadController extends GetxController {
  final FileRepo _repo = FileRepo();

  // Observable list of file items
  var fileItems = <FileUploadItem>[].obs;
  var defaultLinks = <String>[].obs; // pre-existing links from server
  var errorMessage = ''.obs;

  // Helpers for single-file compat (returns first success link)
  String get fileLink =>
      fileItems.firstWhereOrNull((e) => e.status.value == 'success')?.link ??
      '';
  String get fileName => fileItems.isNotEmpty ? fileItems.first.name : '';
  bool get isLoading => fileItems.any(
    (e) => e.status.value == 'uploading' || e.status.value == 'pending',
  );

  // Callback when upload is successful (passes latest uploaded model)
  Function(FileUploadModel model)? onUploadSuccess;
  // Callback for list changes (passes valid links list)
  Function(List<String> links)? onFilesChanged;

  Future<void> pickAndUploadFile(String uploadUrl) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        for (var file in result.files) {
          if (file.path == null) continue;

          // Check file size (max 5MB)
          final fileSize = file.size;
          const maxSize = 5 * 1024 * 1024; // 5MB in bytes

          if (fileSize > maxSize) {
            CustomToast.showInfo(
              title: "خطاء",
              description:
                  "الملف ${file.name} حجمه كبير جداً. الحد الأقصى هو 5 ميجابايت",
            );
            continue;
          }

          final newItem = FileUploadItem(
            id: DateTime.now().millisecondsSinceEpoch.toString() + file.name,
            path: file.path!,
            name: file.name,
            size: fileSize,
          );

          fileItems.add(newItem);
        }

        // Start processing queue
        _processUploadQueue(uploadUrl);
      }
    } catch (e) {
      errorMessage.value = "Error picking file: $e";
      CustomToast.showInfo(title: "Error", description: errorMessage.value);
    }
  }

  void _processUploadQueue(String uploadUrl) async {
    for (var item in fileItems) {
      if (item.status.value == 'pending') {
        await _uploadFileItem(uploadUrl, item);
      }
    }
  }

  Future<void> _uploadFileItem(String url, FileUploadItem item) async {
    item.status.value = 'uploading';
    item.progress.value = 0.1; // Fake start progress

    // Simulate progress or use Dio onSendProgress if repo supported it
    // For now, we just await the repo call

    // Note: To support real progress, we'd need to update FileRepo to accept onSendProgress callback
    // Assuming simple upload for now

    final res = await _repo.uploadFile(url, item.path);

    if (res.status == true && res.data != null) {
      item.progress.value = 1.0;
      item.status.value = 'success';
      final uploadModel = res.data; // ResponseModel data is FileUploadModel
      item.link = uploadModel.link;

      if (onUploadSuccess != null) {
        onUploadSuccess!(uploadModel);
      }
      _notifyFilesChanged();

      // CustomToast.showInfo(
      //   title: "تم رفع الملف بنجاح",
      //   description: "تم رفع ${item.name}",
      // );
    } else {
      item.status.value = 'error';
      item.errorMessage = res.message ?? "Upload failed";
      // CustomToast.showInfo(title: "Error", description: item.errorMessage ?? "Error");
    }
  }

  void removeFile(FileUploadItem item) {
    fileItems.remove(item);
    _notifyFilesChanged();
  }

  /// Set default (server-side) links. Clears previous defaults.
  void setDefaultLinks(List<String> links) {
    defaultLinks.assignAll(links);
    _notifyFilesChanged();
  }

  /// Remove a single pre-existing link
  void removeDefaultLink(String link) {
    defaultLinks.remove(link);
    _notifyFilesChanged();
  }

  void clearFile() {
    fileItems.clear();
    defaultLinks.clear();
    errorMessage.value = '';
    _notifyFilesChanged();
    // CustomToast.showInfo(title: "تم حذف الملفات", description: "تم حذف جميع الملفات");
  }

  void _notifyFilesChanged() {
    if (onFilesChanged != null) {
      final uploadedLinks = fileItems
          .where((e) => e.status.value == 'success' && e.link != null)
          .map((e) => e.link!)
          .toList();
      // Merge default links + newly uploaded links
      final allLinks = [...defaultLinks, ...uploadedLinks];
      onFilesChanged!(allLinks);
    }
  }
}
