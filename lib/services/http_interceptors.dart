import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends InterceptorContract {
  Logger logger = Logger();

  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    logger.t("Request to ${request.url}\nHeaders: ${request.headers}\nBody: $request");
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    response = response as Response;
    if (response.statusCode ~/ 100 == 2) {
      logger.i('Response of ${response.request?.url}\nCode: ${response.statusCode}\nBody: ${(response).body}');
    } else {
      logger.e('Response of ${response.request?.url}\nCode: ${response.statusCode}\nBody: ${(response).body}');
    }

    return response;
  }
}