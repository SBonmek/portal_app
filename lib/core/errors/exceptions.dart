class ServerException implements Exception {
  final int? errorStatus;
  final dynamic message;

  ServerException({this.errorStatus, this.message});

  @override
  String toString() {
    if (errorStatus != null) {
      switch (errorStatus) {
        case 400:
          return "คำขอไม่ถูกต้อง";
        case 401:
          return "ไม่ได้รับอนุญาต";
        case 403:
          return "ไม่มีสิทธิ์";
        case 404:
          return "ไม่พบข้อมูล";
        case 422:
          return message;
        case 500:
          return "พบข้อผิดพลาดภายในเซิร์ฟเวอร์";
        default:
          return message ?? "Server Failure";
      }
    } else {
      if (message == null) return "Server Failure";
      return "Server Failure | $message";
    }
  }
}
