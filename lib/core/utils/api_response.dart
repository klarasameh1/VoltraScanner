enum Status { success, error, loading }

class ApiResponse<T> {
  Status status;
  T? data;
  String? message;

  ApiResponse.success(this.data) : status = Status.success, message = null;
  ApiResponse.error(this.message) : status = Status.error, data = null;
  ApiResponse.loading() : status = Status.loading, data = null, message = null;
}