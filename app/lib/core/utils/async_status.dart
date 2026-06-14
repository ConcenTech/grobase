enum AsyncStatus { initial, loading, success, error }

mixin AsyncStatusMixin<T> {
  AsyncStatus get status;
  String? get error;
  T get data;

  K when<K>({
    required K Function() initial,
    required K Function() loading,
    required K Function(String error) error,
    required K Function(T data) success,
  }) {
    switch (status) {
      case .loading:
        return loading();
      case .error:
        return error(this.error ?? 'An error occurred');
      case .success:
        return success(data);
      case .initial:
        return initial();
    }
  }

  K maybeWhen<K>({
    K Function()? initial,
    K Function()? loading,
    K Function(String error)? error,
    K Function(T data)? success,
    required K Function() orElse,
  }) {
    switch (status) {
      case .loading:
        return (loading ?? orElse).call();
      case .error:
        return error != null
            ? error(this.error ?? 'An error occurred')
            : orElse();
      case .success:
        return success != null ? success(data) : orElse();
      case .initial:
        return (initial ?? orElse).call();
    }
  }
}
