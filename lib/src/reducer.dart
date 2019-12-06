import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

/// A function which is executed when type matched of [ReducerOf].
typedef ReducerCallback<S, A> = S Function(S state, A action);

/// A Reducer class which provides type matching.
///
/// This is fully inspired from [TypedReducer] and modified that statement
/// for IDE support & readability.
///
/// * [S] is type of your [Store]'s state.
/// * [A] is type of action which is matched.
///
/// # Usage
///
/// final appReducer = combineReducers<AppState>(
///   [
///     ReducerOf<AppState, IncrementAction>(
///       callback: (state, action) {
///         return state.copyWith(
///           counter: state.counter + 1,
///         );
///       },
///     ),
///     ReducerOf<AppState, DecrementAction>(
///       callback: (state, action) {
///         return state.copyWith(
///           counter: state.counter - 1,
///         );
///       },
///     ),
///   ],
/// );
///
class ReducerOf<S, A> implements ReducerClass<S> {
  const ReducerOf({
    @required this.callback,
  }) : assert(callback != null);

  /// A function which is executed when type matched.
  final ReducerCallback<S, A> callback;

  /// Lets [ReducerOf] act as a function.
  @override
  S call(S state, dynamic action) {
    if (action is A) {
      return callback(state, action);
    }
    return state;
  }
}
