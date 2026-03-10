import 'package:contracting_management_dashbord/model/file_upload_model.dart';
import 'package:contracting_management_dashbord/model/respnce_model.dart';
import 'package:contracting_management_dashbord/services/dio_service.dart';
import 'package:dio/dio.dart';

class FileRepo {
  Future<ResponseModel> uploadFile(String url, String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await DioNetwork.post(path: url, data: formData);

      if (response.data is Map && response.data['status'] == 200) {
        return ResponseModel(
          status: true,
          message: response.data['message'],
          data: FileUploadModel.fromJson(response.data['data']),
        );
      } else {
        return ResponseModel(
          status: false,
          message: response.data['message'] ?? 'Upload failed',
        );
      }
    } on DioException catch (e) {
      return ResponseModel(
        status: false,
        message: e.response?.data['message'] ?? e.message,
      );
    } catch (e) {
      return ResponseModel(status: false, message: e.toString());
    }
  }
}
