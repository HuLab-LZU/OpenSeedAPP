class IPlantException implements Exception {
  final String message;
  IPlantException(this.message);
  @override
  String toString() {
    return 'IPlantException(message=$message)';
  }
}

class UnexpectedResponse implements Exception {
  final int? statusCode;
  final String message;
  UnexpectedResponse(this.statusCode, this.message);

  @override
  String toString() {
    return 'UnexpectedResponseException(statusCode=$statusCode, message=$message)';
  }
}
