class AppExceptions implements Exception {
  final message;
  final _prefix;

  AppExceptions([this.message, this._prefix]);

  String toString() {
    return "$_prefix $message";
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

class ForbiddenException extends AppExceptions {
  ForbiddenException([String? message]) : super(message, 'You don\t have an access to this.');
}

class BadRequestException extends AppExceptions {
  BadRequestException([String? message]) : super(message, 'Not Found');
}

class UnauthorizedException extends AppExceptions {
  UnauthorizedException([String? message]) : super(message, 'You are not authorized!, Please login and try again');
}
