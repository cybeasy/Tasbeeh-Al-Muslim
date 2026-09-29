abstract class ApiException implements Exception {

  static String toErrorMessage(Object error) {
    if (error is ApiException) {
      if (error is ConnectionException) {
        return  "connectionError";
      } else if (error is ClientErrorException) {
        return  "clientError";
      } else if (error is ServerErrorException) {
        return  "serverError";
      } else if (error is EmptyResultException) {
        return  "emptyResultError";
      } else {
        return  "unknownError";
      }
    } else {
      return  "unknownError";
    }
  }
}

class EmptyResultException extends ApiException {}

class ConnectionException extends ApiException {}

class ServerErrorException extends ApiException {}

class ClientErrorException extends ApiException {}

class UnknownException extends ApiException {}
