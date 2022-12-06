import 'package:dio/dio.dart';

Options dioOptions = Options(
  followRedirects: false,
  validateStatus: (status) {
    return status! < 500;
  },
);
