import 'package:flutter/foundation.dart';

enum Status { loading, success, error }

class ApiResponse<T> {
  final Status status;
  final T? data;
  final String? message;

  ApiResponse.loading() : status = Status.loading, data = null, message = null;
  ApiResponse.success(this.data) : status = Status.success, message = null;
  ApiResponse.error(this.message) : status = Status.error, data = null;
} 