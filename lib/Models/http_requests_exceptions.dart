/// Customized Http exception class.
class HttpException implements Exception {
  /// Constructor to set [_message]
  HttpException(this._message);

  final String _message;

  @override
  String toString() {
    return _message;
  }
}
