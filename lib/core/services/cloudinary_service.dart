import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rivals/core/constants.dart';

class CloudinaryService {
  static Future<String> uploadMedia(File file, {bool isVideo = false}) async {
    final resourceType = isVideo ? 'video' : 'image';
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/${AppConstants.cloudinaryCloudName}/$resourceType/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = AppConstants.cloudinaryUploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final json = jsonDecode(body);

    if (response.statusCode == 200) {
      return json['secure_url'] as String;
    } else {
      throw Exception(json['error']['message'] ?? 'Upload failed');
    }
  }
}
