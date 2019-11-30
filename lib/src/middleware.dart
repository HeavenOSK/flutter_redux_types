import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

/// A function which is executed when type matched of [MiddlewareOf].
typedef MiddlewareCallback<S, T> = void Function(
  Store<S> store,
  T action,
  NextDispatcher next,
);

/// A Middleware class which provides type matching.
///
/// This is fully inspired from [TypedMiddleware] and modified that statement
/// for IDE support & readability.
class MiddlewareOf<S, T> implements MiddlewareClass<S> {
  const MiddlewareOf({
    @required this.callback,
  }) : assert(callback != null);

  /// A function which is executed when type matched.
  final MiddlewareCallback<S, T> callback;

  /// Lets [MiddlewareOf] act as a function.
  @override
  void call(Store<S> store, dynamic action, NextDispatcher next) {
    if (action is T) {
      callback(store, action, next);
    } else {
      next(action);
    }
  }
}
