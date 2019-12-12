import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

/// A callback for [InjectionMiddlewareOf].
///
/// * [S] is type of your [Store]'s state.
/// * [A] is type of action which is matched.
/// * [D] is type of a dependency which is injected.
///
typedef InjectionMiddlewareCallback<S, A, D> = void Function(
  Store<S> store,
  A action,
  NextDispatcher next,
  D dependency,
);

/// A type matching middleware which can use injected dependency.
///
/// This class is wrapper of [TypedMiddleware] which can use an
/// injected dependency.
///
/// * [S] is type of your [Store]'s state.
/// * [A] is type of action which is matched.
/// * [D] is type of a dependency which is injected.
///
/// # Usage
///
/// List<Middleware<AppState>> navigatorMiddleware(
///  GlobalKey<NavigatorState> navigatorKey,
/// ) {
///   return [
///     InjectionMiddlewareOf<AppState, ShowDialogAction,
///         GlobalKey<NavigatorState>>(
///       dependency: navigatorKey,
///       callback: (state, action, next, key) {
///         showDialog<void>(
///           context: key.currentState.overlay.context,
///           builder: (context) {
///            return const AlertDialog(
///              content: Text('Injectable'),
///             );
///           },
///         );
///       },
///     ),
///   ];
/// }
///
class InjectionMiddlewareOf<S, A, D> implements MiddlewareClass<S> {
  const InjectionMiddlewareOf({
    @required this.dependency,
    @required this.callback,
  })  : assert(dependency != null),
        assert(callback != null);

  /// Any dependency.
  final D dependency;

  /// A callback for middleware with dependency.
  final InjectionMiddlewareCallback<S, A, D> callback;

  /// Executes [callback] if the type of [action] is matched to [A].
  @override
  void call(Store<S> store, dynamic action, NextDispatcher next) {
    if (action is A) {
      callback(store, action, next, dependency);
    } else {
      next(action);
    }
  }
}
