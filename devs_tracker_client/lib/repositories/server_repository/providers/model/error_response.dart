class ErrorResponse {
  final String id;
  final String message;

  ErrorResponse(this.id, this.message);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(json["id"], json["message"]);
  }
}
