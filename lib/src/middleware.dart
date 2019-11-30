import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

/// A function which is executed when type matched of [MiddlewareOf].
typedef MiddlewareCallback<State, Action> = void Function(
  Store<State> store,
  Action action,
  NextDispatcher next,
);

/// A Middleware class which provides type matching.
///
/// This is fully inspired from [TypedMiddleware] and modified that statement
/// for IDE support & readability.
class MiddlewareOf<State, Action> implements MiddlewareClass<State> {
  const MiddlewareOf({
    @required this.callback,
  }) : assert(callback != null);

  /// A function which is executed when type matched.
  final MiddlewareCallback<State, Action> callback;

  /// Lets [MiddlewareOf] act as a function.
  @override
  void call(Store<State> store, dynamic action, NextDispatcher next) {
    if (action is Action) {
      callback(store, action, next);
    } else {
      next(action);
    }
  }
}
