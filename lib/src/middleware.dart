import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

/// A function which is executed when type matched of [MiddlewareOf].
///
/// * [S] is type of your [Store]'s state.
/// * [A] is type of action which is matched.
///
typedef MiddlewareCallback<S, A> = void Function(
  Store<S> store,
  A action,
  NextDispatcher next,
);

/// A Middleware class which provides type matching.
///
/// This is fully inspired from [TypedMiddleware] and modified that statement
/// for IDE support & readability.
///
/// * [S] is type of your [Store]'s state.
/// * [A] is type of action which is matched.
///
/// # Usage
///
/// List<Middleware<AppState>> counterMiddleware() {
///   return [
///     MiddlewareOf<AppState, IncrementAction>(
///       callback: (store, action, next) {
///         print('IncrementAction was called!');
///         next(action);
///       },
///     ),
///     MiddlewareOf<AppState, DecrementAction>(
///       callback: (store, action, next) {
///         print('DecrementAction was called!');
///         next(action);
///       },
///     ),
///   ];
/// }
///
class MiddlewareOf<S, A> implements MiddlewareClass<S> {
  const MiddlewareOf({
    @required this.callback,
  }) : assert(callback != null);

  /// A function which is executed when type matched.
  final MiddlewareCallback<S, A> callback;

  /// Lets [MiddlewareOf] act as a function.
  @override
  void call(Store<S> store, dynamic action, NextDispatcher next) {
    if (action is A) {
      callback(store, action, next);
    } else {
      next(action);
    }
  }
}
