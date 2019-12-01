import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

/// A function which is executed when type matched of [ReducerOf].
typedef ReducerCallback<S, T> = S Function(S state, T action);

/// A Reducer class which provides type matching.
///
/// This is fully inspired from [TypedReducer] and modified that statement
/// for IDE support & readability.
class ReducerOf<S, T> implements ReducerClass<S> {
  const ReducerOf({
    @required this.callback,
  }) : assert(callback != null);

  /// A function which is executed when type matched.
  final ReducerCallback<S, T> callback;

  /// Lets [ReducerOf] act as a function.
  @override
  S call(S state, dynamic action) {
    if (action is T) {
      return callback(state, action);
    }
    return state;
  }
}
