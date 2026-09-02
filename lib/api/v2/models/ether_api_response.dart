import 'dart:convert';

class EtherApiResponse {
  final bool success;
  final String type;
  final dynamic data;
  final String? error;

  const EtherApiResponse({
    required this.success,
    required this.type,
    this.data,
    this.error,
  });

  factory EtherApiResponse.success({required String type, dynamic data}) {
    return EtherApiResponse(success: true, type: type, data: data);
  }

  factory EtherApiResponse.failure({
    required String type,
    required String error,
  }) {
    return EtherApiResponse(success: false, type: type, error: error);
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'type': type,
      if (data != null) 'data': data,
      if (error != null) 'error': error,
    };
  }

  String encode() {
    return jsonEncode(toJson());
  }
}
