class AppExceptions implements Exception {
  final _message;
  final _prefix;

  AppExceptions([this._message, this._prefix]);

  String tostring() {
    return "$_prefix $_message";
  }
}

class InternetException extends AppExceptions {
  InternetException([String? message]) : super(message, 'No internet!');
}

class RequestTimeOutException extends AppExceptions {
  RequestTimeOutException([String? message])
      : super(message, 'Request Timeout!');
}

class ServerException extends AppExceptions {
  ServerException([String? message])
      : super(message, 'Server throwed an error!');
}

class NotFoundException extends AppExceptions {
  NotFoundException([String? message]) : super(message, 'No data found');
}

class DefaultException extends AppExceptions {
  DefaultException([String? message]) : super(message, 'Something went wrong');
}
