// import 'dart:developer';
//
// import 'package:dio/dio.dart';
// import 'package:easy_localization/easy_localization.dart';
//
// import '../../core/routes/app_routes_fun.dart';
// import '../../core/routes/routes.dart';
// import '../../core/utils/constant.dart';
// import '../auth/sign_in/data/models/model.dart';
//
// class DioHelper {
//   final Dio _dio = Dio();
//   final _logger = LoggerDebug(
//       headColor: LogColors.red, constTitle: "DioHelper Gate Logger");
//
//   DioHelper._internal() {
//     // _dio.interceptors.add(LoggingInterceptor());
//     init();
//   }
//
//   static final DioHelper instance = DioHelper._internal();
//   factory DioHelper() {
//     return instance;
//   }
//
//   init() {
//     _dio.options = BaseOptions(
//       baseUrl: AppConstants.baseUrl,
//       connectTimeout: const Duration(seconds: 30),
//       receiveTimeout: const Duration(seconds: 30),
//       responseType: ResponseType.json,
//       headers: {
//         if (UserModel().isAuth) "Authorization": "Bearer ${UserModel().token}",
//         "x-api-key": "i9u99tt4-f0w6-71w7-8394-y968t02516r11",
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         "Accept-Language": navigatorKey.currentContext?.locale.languageCode,
//         "x-localization": navigatorKey.currentContext?.locale.languageCode,
//       }..removeWhere((key, value) => value == null || '$value'.isEmpty),
//     );
//
//     // Ensure the baseUrl starts with 'http'
//     _logger.green("Base URL test: ${_dio.options.baseUrl}");
//     if (!_dio.options.baseUrl.startsWith('http')) {
//       throw Exception("Invalid baseUrl: must start with 'http'");
//     }
//
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           // Clean up query parameters and headers
//           options.queryParameters
//               .removeWhere((key, value) => value == null || '$value'.isEmpty);
//           options.headers
//               .removeWhere((key, value) => value == null || '$value'.isEmpty);
//
//           // Add Authorization Header if authenticated
//           if (UserModel().isAuth) {
//             options.headers["Authorization"] = "Bearer ${UserModel().token}";
//           }
//
//           // Log request details
//           _logger.green("Request: ${options.method} ${options.path}");
//           _logger.green("Headers: ${options.headers}");
//           _logger.green("Query Parameters: ${options.queryParameters}");
//           _logger.green("Body: ${options.data}");
//           _logger.green("Request URL: ${options.uri}");
//           _logger.green("Request Headers: ${options.headers}");
//           _logger.green("Request Body: ${options.data}");
//           _logger.green("Request Method: ${options.method}");
//           _logger.green("Request Path: ${options.path}");
//           _logger.green("Request Query Parameters: ${options.queryParameters}");
//           _logger.green("Request Response Type: ${options.responseType}");
//           _logger.green("Request Content Type: ${options.contentType}");
//           _logger.green("Request Extra: ${options.extra}");
//           _logger.green("Request Connect Timeout: ${options.connectTimeout}");
//           _logger.green("Request Receive Timeout: ${options.receiveTimeout}");
//           _logger.green("Request Follow Redirects: ${options.followRedirects}");
//           _logger.green("Request Max Redirects: ${options.maxRedirects}");
//           _logger.green("Request Validate Status: ${options.validateStatus}");
//           _logger.green("Request Response Type: ${options.responseType}");
//           _logger.green("Request Content Type: ${options.contentType}");
//           _logger.green("Request Extra: ${options.extra}");
//           _logger.green("Request Follow Redirects: ${options.followRedirects}");
//           _logger.green("Request Max Redirects: ${options.maxRedirects}");
//           _logger.green("Request Validate Status: ${options.validateStatus}");
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           // Clean up response data if needed
//           _logger.green("Response received: ${response.data}");
//           _logger.green("Response status code: ${response.statusCode}");
//           _logger.green("Response headers: ${response.headers}");
//           _logger
//               .green("Response request path: ${response.requestOptions.path}");
//           _logger.green(
//               "Response request method: ${response.requestOptions.method}");
//           return handler.next(response);
//         },
//         onError: (DioException error, handler) {
//           _logger.red("Error occurred: ${error.message}");
//           _logger.red("Error request path: ${error.requestOptions.path}");
//           _logger.red("Error request method: ${error.requestOptions.method}");
//           _logger.red("Error request headers: ${error.requestOptions.headers}");
//           _logger.red("Error request data: ${error.requestOptions.data}");
//           _logger.red(
//               "Error request query parameters: ${error.requestOptions.queryParameters}");
//           _logger.red(
//               "Error request response type: ${error.requestOptions.responseType}");
//           _logger.red(
//               "Error request content type: ${error.requestOptions.contentType}");
//           _logger.red("Error request extra: ${error.requestOptions.extra}");
//           _logger.red(
//               "Error request connect timeout: ${error.requestOptions.connectTimeout}");
//           _logger.red(
//               "Error request receive timeout: ${error.requestOptions.receiveTimeout}");
//           _logger.red(
//               "Error request follow redirects: ${error.requestOptions.followRedirects}");
//           _logger.red(
//               "Error request max redirects: ${error.requestOptions.maxRedirects}");
//           _logger.red(
//               "Error request validate status: ${error.requestOptions.validateStatus}");
//           _logger.red(
//               "Error request response type: ${error.requestOptions.responseType}");
//           return handler.next(error);
//         },
//       ),
//     );
//
//     _dio.interceptors.add(LoggingInterceptor());
//   }
//
//   Future<HelperResponse<T>> get<T>(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     Map<String, String>? headers,
//     bool requireAuth = true,
//   }) async {
//     try {
//       // Merge additional headers if provided
//       final mergedHeaders = {
//         ..._dio.options.headers,
//         if (headers != null) ...headers,
//       };
//       // Clean up query parameters
//       queryParameters
//           ?.removeWhere((key, value) => value == null || '$value'.isEmpty);
//       // Clean up headers
//       mergedHeaders
//           .removeWhere((key, value) => value == null || '$value'.isEmpty);
//       // Log request details
//       _logger.green("Request: ${_dio.options.method} $path");
//       _logger.green("Headers: $mergedHeaders");
//       _logger.green("Query Parameters: $queryParameters");
//
//       // Add Authorization Header if required and authenticated
//       if (requireAuth && UserModel().isAuth) {
//         mergedHeaders["Authorization"] = "Bearer ${UserModel().token}";
//       }
//
//       final response = await _dio.get(
//         path,
//         queryParameters: queryParameters,
//         options: Options(headers: mergedHeaders),
//       );
//
//       if (response.statusCode == 200) {
//         return HelperResponse<T>(
//           state: StatesType.success,
//           statusCode: response.statusCode!,
//           success: true,
//           message: response.data['message'] ?? 'Success',
//           data: response.data as T,
//         );
//       } else if (response.statusCode == 404) {
//         pushAndRemoveUntil(NamedRoutes.i.error);
//
//         return HelperResponse<T>(
//           state: StatesType.error,
//           statusCode: 404,
//           success: false,
//           message: 'Not Found',
//           errorType: ErrorType.notFound,
//         );
//       } else {
//         return HelperResponse<T>(
//           state: StatesType.error,
//           statusCode: response.statusCode ?? 500,
//           success: false,
//           message: response.statusMessage ?? 'Error',
//           errorType: ErrorType.unknown,
//         );
//       }
//     } on DioException catch (e) {
//       return handleDioHelperError<T>(e);
//     } catch (e) {
//       _logger.red("Unexpected error: $e");
//       return HelperResponse<T>(
//         state: StatesType.error,
//         statusCode: 500,
//         success: false,
//         message: 'Unexpected error',
//         errorType: ErrorType.unknown,
//       );
//     }
//   }
//
//   Future<HelperResponse<T>> post<T>(
//     String path, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? formData,
//     Map<String, dynamic>? queryParameters,
//     Map<String, String>? headers,
//     bool requireAuth = true,
//   }) async {
//     try {
//       // Clean up query parameters
//       queryParameters
//           ?.removeWhere((key, value) => value == null || '$value'.isEmpty);
//       // Clean up headers
//       headers?.removeWhere((key, value) => value.isEmpty);
//
//       formData?.removeWhere((key, value) => value == null || '$value'.isEmpty);
//
//       data?.removeWhere((key, value) => value == null || '$value'.isEmpty);
//       // Log request details
//       _logger.green("Request: ${_dio.options.method} $path");
//       _logger.green("Headers: ${_dio.options.headers}");
//       _logger.green("Query Parameters: $queryParameters");
//       // Merge additional headers if provided
//       final mergedHeaders = {
//         ..._dio.options.headers,
//         if (headers != null) ...headers,
//       };
//
//       // Add Authorization Header if required and authenticated
//       if (requireAuth && UserModel().isAuth) {
//         mergedHeaders["Authorization"] = "Bearer ${UserModel().token}";
//       }
//
//       final response = await _dio.post(
//         path,
//         data: formData != null ? FormData.fromMap(formData) : (data ?? {}),
//         queryParameters: queryParameters,
//         options: Options(headers: mergedHeaders),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return HelperResponse<T>(
//           state: StatesType.success,
//           statusCode: response.statusCode!,
//           success: true,
//           message: response.data['message'] ?? 'Success',
//           data: response.data as T,
//         );
//       } else if (response.statusCode == 404) {
//         pushAndRemoveUntil(NamedRoutes.i.error);
//
//         return HelperResponse<T>(
//           state: StatesType.error,
//           statusCode: 404,
//           success: false,
//           message: 'Not Found',
//           errorType: ErrorType.notFound,
//         );
//       } else {
//         return HelperResponse<T>(
//           state: StatesType.error,
//           statusCode: response.statusCode ?? 500,
//           success: false,
//           message: response.statusMessage ?? 'Error',
//           errorType: ErrorType.unknown,
//         );
//       }
//     } on DioException catch (e) {
//       return handleDioHelperError<T>(e);
//     } catch (e) {
//       _logger.red("Unexpected error: $e");
//       return HelperResponse<T>(
//         state: StatesType.error,
//         statusCode: 500,
//         success: false,
//         message: 'Unexpected error',
//         errorType: ErrorType.unknown,
//       );
//     }
//   }
//
//   Future<HelperResponse<T>> put<T>(
//     String path, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, String>? headers,
//     bool requireAuth = true,
//   }) async {
//     try {
//       // Clean up query parameters
//       queryParameters
//           ?.removeWhere((key, value) => value == null || '$value'.isEmpty);
//       // Clean up headers
//       headers?.removeWhere((key, value) => value.isEmpty);
//       // Log request details
//       _logger.green("Request: ${_dio.options.method} $path");
//       _logger.green("Headers: ${_dio.options.headers}");
//       _logger.green("Query Parameters: $queryParameters");
//       // Log request body
//       _logger.green("Request Body: $data");
//       // Log request URL
//       _logger.green("Request URL: ${_dio.options.baseUrl}$path");
//       // Merge additional headers if provided
//       final mergedHeaders = {
//         ..._dio.options.headers,
//         if (headers != null) ...headers,
//       };
//
//       // Add Authorization Header if required and authenticated
//       if (requireAuth && UserModel().isAuth) {
//         mergedHeaders["Authorization"] = "Bearer ${UserModel().token}";
//       }
//
//       final response = await _dio.put(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: Options(headers: mergedHeaders),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return HelperResponse<T>(
//           state: StatesType.success,
//           statusCode: response.statusCode!,
//           success: true,
//           message: response.data['message'] ?? 'Success',
//           data: response.data as T,
//         );
//       } else if (response.statusCode == 404) {
//         pushAndRemoveUntil(NamedRoutes.i.error);
//         return HelperResponse<T>(
//           state: StatesType.error,
//           statusCode: 404,
//           success: false,
//           message: 'Not Found',
//           errorType: ErrorType.notFound,
//         );
//       } else {
//         return HelperResponse<T>(
//           state: StatesType.error,
//           statusCode: response.statusCode ?? 500,
//           success: false,
//           message: response.statusMessage ?? 'Error',
//           errorType: ErrorType.unknown,
//         );
//       }
//     } on DioException catch (e) {
//       return handleDioHelperError<T>(e);
//     } catch (e) {
//       _logger.red("Unexpected error: $e");
//       return HelperResponse<T>(
//         state: StatesType.error,
//         statusCode: 500,
//         success: false,
//         message: 'Unexpected error',
//         errorType: ErrorType.unknown,
//       );
//     }
//   }
//
//   Future<HelperResponse<T>> delete<T>(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     Map<String, String>? headers,
//     bool requireAuth = true,
//   }) async {
//     try {
//       // Clean up query parameters
//       queryParameters
//           ?.removeWhere((key, value) => value == null || '$value'.isEmpty);
//       // Clean up headers
//       headers?.removeWhere((key, value) => value.isEmpty);
//       // Log request details
//       _logger.green("Request: ${_dio.options.method} $path");
//       _logger.green("Headers: ${_dio.options.headers}");
//       _logger.green("Query Parameters: $queryParameters");
//       // Log request URL
//       _logger.green("Request URL: ${_dio.options.baseUrl}$path");
//       // Merge additional headers if provided
//       final mergedHeaders = {
//         ..._dio.options.headers,
//         if (headers != null) ...headers,
//       };
//
//       // Add Authorization Header if required and authenticated
//       if (requireAuth && UserModel().isAuth) {
//         mergedHeaders["Authorization"] = "Bearer ${UserModel().token}";
//       }
//
//       final response = await _dio.delete(
//         path,
//         queryParameters: queryParameters,
//         options: Options(headers: mergedHeaders),
//       );
//
//       if (response.statusCode == 200) {
//         return HelperResponse<T>(
//           state: StatesType.success,
//           statusCode: response.statusCode!,
//           success: true,
//           message: response.data['message'] ?? 'Success',
//           data: response.data as T,
//         );
//       } else if (response.statusCode == 404) {
//         pushAndRemoveUntil(NamedRoutes.i.error); // Redirect to 404 error screen
//
//         return HelperResponse<T>(
//           state: StatesType.error,
//           statusCode: 404,
//           success: false,
//           message: 'Not Found',
//           errorType: ErrorType.notFound,
//         );
//       } else {
//         return HelperResponse<T>(
//           state: StatesType.error,
//           statusCode: response.statusCode ?? 500,
//           success: false,
//           message: response.statusMessage ?? 'Error',
//           errorType: ErrorType.unknown,
//         );
//       }
//     } on DioException catch (e) {
//       return handleDioHelperError<T>(e);
//     } catch (e) {
//       _logger.red("Unexpected error: $e");
//       return HelperResponse<T>(
//         state: StatesType.error,
//         statusCode: 500,
//         success: false,
//         message: 'Unexpected error',
//         errorType: ErrorType.unknown,
//       );
//     }
//   }
//
//   Future<HelperResponse<T>> download<T>(
//     String urlPath,
//     String savePath, {
//     Map<String, dynamic>? queryParameters,
//     Map<String, String>? headers,
//     bool requireAuth = true,
//     ProgressCallback? onReceiveProgress,
//   }) async {
//     try {
//       // Clean up query parameters
//       queryParameters
//           ?.removeWhere((key, value) => value == null || '$value'.isEmpty);
//       // Clean up headers
//       headers?.removeWhere((key, value) => value.isEmpty);
//
//       _logger.green("Download Request: $urlPath");
//       _logger.green("Headers: ${_dio.options.headers}");
//       _logger.green("Query Parameters: $queryParameters");
//       _logger.green("Save Path: $savePath");
//       // Merge additional headers if provided
//       final mergedHeaders = {
//         ..._dio.options.headers,
//         if (headers != null) ...headers,
//       };
//
//       // Add Authorization Header if required and authenticated
//       if (requireAuth && UserModel().isAuth) {
//         mergedHeaders["Authorization"] = "Bearer ${UserModel().token}";
//       }
//
//       await _dio.download(
//         urlPath,
//         savePath,
//         queryParameters: queryParameters,
//         options: Options(headers: mergedHeaders),
//         onReceiveProgress: onReceiveProgress,
//       );
//
//       return HelperResponse<T>(
//         state: StatesType.success,
//         statusCode: 200,
//         success: true,
//         message: 'Download completed successfully',
//       );
//     } on DioException catch (e) {
//       return handleDioHelperError<T>(e);
//     } catch (e) {
//       _logger.red("Unexpected error during download: $e");
//       return HelperResponse<T>(
//         state: StatesType.error,
//         statusCode: 500,
//         success: false,
//         message: 'Unexpected error during download',
//         errorType: ErrorType.unknown,
//       );
//     }
//   }
//
//   Future<HelperResponse<T>> downloadImage<T>(
//     String imageUrl,
//     String savePath, {
//     ProgressCallback? onReceiveProgress,
//   }) async {
//     try {
//       _logger.green("Downloading image from: $imageUrl");
//       _logger.green("Saving to: $savePath");
//
//       await _dio.download(
//         imageUrl,
//         savePath,
//         onReceiveProgress: onReceiveProgress,
//       );
//
//       _logger.green("Image downloaded successfully to $savePath");
//
//       return HelperResponse<T>(
//         state: StatesType.success,
//         statusCode: 200,
//         success: true,
//         message: 'Image downloaded successfully',
//       );
//     } on DioException catch (e) {
//       _logger.red("Error downloading image: ${e.message}");
//       return handleDioHelperError<T>(e);
//     } catch (e) {
//       _logger.red("Unexpected error during image download: $e");
//       return HelperResponse<T>(
//         state: StatesType.error,
//         statusCode: 500,
//         success: false,
//         message: 'Unexpected error during image download',
//         errorType: ErrorType.unknown,
//       );
//     }
//   }
//
//   HelperResponse<T> handleDioHelperError<T>(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.badResponse:
//         final response = error.response;
//         if (response != null) {
//           if (response.statusCode == 401) {
//             _logger
//                 .red("Session expired or unauthorized. Redirecting to login.");
//             push(NamedRoutes.i.login);
//             return HelperResponse<T>(
//               state: StatesType.error,
//               statusCode: response.statusCode ?? 401,
//               success: false,
//               message: 'Session expired. Please log in again.',
//               errorType: ErrorType.unauthorized,
//             );
//           } else if (response.data is String) {
//             final errorMessage = response.data.toString().trim();
//             _logger.red("Text-based error received: $errorMessage");
//             return HelperResponse<T>(
//               state: StatesType.error,
//               statusCode: response.statusCode ?? 500,
//               success: false,
//               message: errorMessage,
//               errorType: ErrorType.unknown,
//             );
//           } else if ((response.data.toString().contains("DOCTYPE") ||
//               response.data.toString().contains("<script>") ||
//               response.data["exception"] != null)) {
//             _logger.red("Malformed or unexpected response received.");
//             return HelperResponse<T>(
//               state: StatesType.error,
//               statusCode: response.statusCode ?? 500,
//               success: false,
//               message: 'Malformed or unexpected response',
//               errorType: ErrorType.malformedResponse,
//             );
//           } else if (response.statusCode == 405) {
//             _logger.red("Method not allowed.");
//             pushAndRemoveUntil(NamedRoutes.i.error);
//             return HelperResponse<T>(
//               state: StatesType.error,
//               statusCode: response.statusCode!,
//               success: false,
//               message: response.data['message'] ?? 'Method not allowed',
//               errorType: ErrorType.unknown,
//             );
//           } else if (response.data is Map<String, dynamic>) {
//             final errorMessage = response.data['errors']?["validation"] ??
//                 response.data['message'] ??
//                 response.statusMessage ??
//                 'Error';
//             _logger.red("Map-based error received: $errorMessage");
//             return HelperResponse<T>(
//               state: StatesType.error,
//               statusCode: response.statusCode ?? 500,
//               success: false,
//               message: errorMessage,
//               errorType: ErrorType.unknown,
//             );
//           } else {
//             return HelperResponse<T>(
//               state: StatesType.error,
//               statusCode: response.statusCode ?? 500,
//               success: false,
//               message: response.data['errors']?["validation"] ??
//                   response.data['message'] ??
//                   response.statusMessage ??
//                   'Bad Response',
//               errorType: ErrorType.unknown,
//             );
//           }
//         } else {
//           return HelperResponse<T>(
//             state: StatesType.error,
//             statusCode: 500,
//             success: false,
//             message: 'Unknown error',
//             errorType: ErrorType.unknown,
//           );
//         }
//
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.receiveTimeout:
//       case DioExceptionType.sendTimeout:
//         _logger.red("Timeout occurred.");
//         return HelperResponse<T>(
//           state: StatesType.error,
//           statusCode: 408,
//           success: false,
//           message: 'Request timed out. Please try again.',
//           errorType: ErrorType.timeout,
//         );
//
//       case DioExceptionType.cancel:
//         _logger.red("Request cancelled.");
//         return HelperResponse<T>(
//           state: StatesType.error,
//           statusCode: 499,
//           success: false,
//           message: 'Request was cancelled by the user.',
//           errorType: ErrorType.unknown,
//         );
//
//       case DioExceptionType.unknown:
//         if (error.message?.contains('SocketException') == true) {
//           _logger.red("No internet connection.");
//           return HelperResponse<T>(
//             state: StatesType.error,
//             statusCode: 503,
//             success: false,
//             message: 'No internet connection. Please check your network.',
//             errorType: ErrorType.noInternet,
//           );
//         } else {
//           _logger.red("An unknown error occurred.");
//           return HelperResponse<T>(
//             state: StatesType.error,
//             statusCode: 500,
//             success: false,
//             message: 'An unknown error occurred. Please try again later.',
//             errorType: ErrorType.unknown,
//           );
//         }
//
//       default:
//         _logger.red("Unexpected error occurred.");
//         return HelperResponse<T>(
//           state: StatesType.error,
//           statusCode: 500,
//           success: false,
//           message: 'An unexpected error occurred. Please try again.',
//           errorType: ErrorType.unknown,
//         );
//     }
//   }
// }
//
// class HelperResponse<T> {
//   final StatesType state;
//   final int statusCode;
//   final bool success;
//   final String message;
//   final T? data;
//   final ErrorType? errorType;
//
//   HelperResponse({
//     required this.state,
//     required this.statusCode,
//     required this.success,
//     required this.message,
//     this.data,
//     this.errorType,
//   });
//
//   @override
//   String toString() {
//     return 'HelperResponse(state: $state, statusCode: $statusCode, success: $success, message: $message, data: $data, errorType: $errorType)';
//   }
// }
//
// enum StatesType {
//   success,
//   error;
//
//   bool get isSuccess => this == StatesType.success;
//   bool get isError => this == StatesType.error;
// }
//
// enum ErrorType {
//   malformedResponse, // تحتوي على بيانات غير صالحة أو غير متوقعة.
//   unauthorized, // 401
//   notFound, // 404
//   timeout, // Connection/Receive/Send Timeout
//   noInternet, // SocketException
//   unknown; // Other errors
//
//   bool get isMalformedResponse => this == ErrorType.malformedResponse;
//   bool get isUnauthorized => this == ErrorType.unauthorized;
//   bool get isNotFound => this == ErrorType.notFound;
//   bool get isTimeout => this == ErrorType.timeout;
//   bool get isNoInternet => this == ErrorType.noInternet;
//   bool get isUnknown => this == ErrorType.unknown;
// }
//
// class LoggerDebug {
//   LoggerDebug({this.headColor = "", this.constTitle});
//   String headColor;
//   String? constTitle;
//
//   black(String message, [String? title]) {
//     return log(
//       "${LogColors.black}$message${LogColors.reset}",
//       name: "$headColor${title ?? constTitle ?? ""}${LogColors.reset}",
//     );
//   }
//
//   white(String message, [String? title]) {
//     return log(
//       "${LogColors.white}$message${LogColors.reset}",
//       name: "$headColor${title ?? constTitle ?? ""}${LogColors.reset}",
//     );
//   }
//
//   red(String message, [String? title]) {
//     return log(
//       "${LogColors.red}$message${LogColors.reset}",
//       name: "\"$headColor${title ?? constTitle ?? ""}${LogColors.reset}\"",
//     );
//   }
//
//   green(String message, [String? title]) {
//     return log(
//       "${LogColors.green}$message${LogColors.reset}",
//       name: "$headColor${title ?? constTitle ?? ""}${LogColors.reset}",
//     );
//   }
//
//   yellow(String message, [String? title]) {
//     return log(
//       "${LogColors.yellow}$message${LogColors.reset}",
//       name: "$headColor${title ?? constTitle ?? ""}${LogColors.reset}",
//     );
//   }
//
//   blue(String message, [String? title]) {
//     return log(
//       "${LogColors.blue}$message${LogColors.reset}",
//       name: "$headColor${title ?? constTitle ?? ""}${LogColors.reset}",
//     );
//   }
//
//   cyan(String message, [String? title]) {
//     return log(
//       "${LogColors.cyan}$message${LogColors.reset}",
//       name: "$headColor${title ?? constTitle ?? ""}${LogColors.reset}",
//     );
//   }
// }
//
// class LogColors {
//   static String reset = "\x1B[0m";
//   static String black = "\x1B[30m";
//   static String white = "\x1B[37m";
//   static String red = "\x1B[31m";
//   static String green = "\x1B[32m";
//   static String yellow = "\x1B[33m";
//   static String blue = "\x1B[34m";
//   static String cyan = "\x1B[36m";
// }
//
// class LoggingInterceptor extends Interceptor {
//   final _logger = LoggerDebug(
//       headColor: LogColors.red, constTitle: "DioHelper Gate Logger");
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     _logger.green("➡️ Request: ${options.method} ${options.path}");
//     _logger.green("Headers: ${options.headers}");
//     _logger.green("Query Parameters: ${options.queryParameters}");
//     _logger.green("Body: ${options.data}");
//     return handler.next(options);
//   }
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     _logger.green(
//         "⬅️ Response [${response.statusCode}] => Path: ${response.requestOptions.path}");
//
//     _logger.green("Data: ${response.data}");
//     return handler.next(response);
//   }
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     _logger.red("❌ Error: ${err.message}");
//     _logger.red("Path: ${err.requestOptions.path}");
//     if (err.response != null) {
//       _logger.red("Response Data: ${err.response?.data}");
//       _logger.red("Status Code: ${err.response?.statusCode}");
//     }
//     return handler.next(err);
//   }
// }
//
// // Example of localization strings
// // "Dio": {
// //     "lang": "ar",
// //     "something_went_wrong_please_try_again": "حدث خطأ ، يرجى المحاولة مرة اخرى",
// //     "poor_connection_check_the_quality_of_the_internet": "تحقق من جودة الانترنت",
// //     "please_check_your_internet_connection": "يرجى التحقق من الاتصال بالانترنت"
// //   },
