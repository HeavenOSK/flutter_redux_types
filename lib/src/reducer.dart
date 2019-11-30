import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

/// A function which is executed when type matched of [ReducerOf].
typedef ReducerCallback<State, Action> = State Function(
  State state,
  Action action,
);

/// A Reducer class which provides type matching.
///
/// This is fully inspired from [TypedReducer] and modified that statement
/// for IDE support & readability.
class ReducerOf<State, Action> implements ReducerClass<State> {
  const ReducerOf({
    @required this.callback,
  }) : assert(callback != null);

  /// A function which is executed when type matched.
  final ReducerCallback<State, Action> callback;

  /// Lets [ReducerOf] act as a function.
  @override
  State call(State state, dynamic action) {
    if (action is Action) {
      return callback(state, action);
    }
    return state;
  }
}
