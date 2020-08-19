class ApiResponse<T> {
  Status status;
  dynamic data;
  String message;

  ApiResponse.loading(this.message) : status = Status.LOADING;
  ApiResponse.successful(this.message, {this.data})
      : status = Status.SUCCESSFUL;
  ApiResponse.unSuccessful(this.message) : status = Status.UNSUCCESSFUL;
  ApiResponse.validationFailed(this.message)
      : status = Status.VALIDATION_FAILED;
  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status  Message : $message  Data : $data";
  }
}

enum Status { LOADING, SUCCESSFUL, UNSUCCESSFUL, ERROR, VALIDATION_FAILED }
