import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

/// A callback for [InjectionMiddlewareOf].
typedef InjectionMiddlewareCallback<S, T, D> = void Function(
  Store<S> store,
  T action,
  NextDispatcher next,
  D dependency,
);

/// A type matching middleware which is able to be injected dependency..
class InjectionMiddlewareOf<S, T, D> implements MiddlewareClass<S> {
  const InjectionMiddlewareOf({
    @required this.dependency,
    @required this.callback,
  })  : assert(dependency != null),
        assert(callback != null);

  /// Any dependency.
  final D dependency;

  /// A callback for middleware with dependency.
  final InjectionMiddlewareCallback<S, T, D> callback;

  /// Executes [callback] if tha type of [action] is matched.
  @override
  void call(Store<S> store, dynamic action, NextDispatcher next) {
    if (action is T) {
      callback(store, action, next, dependency);
    } else {
      next(action);
    }
  }
}
