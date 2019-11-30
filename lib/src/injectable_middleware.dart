import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

abstract class Injectable {}

typedef InjectableMiddlewareCallback<State, Action, O extends Injectable>
    = void Function(
        O dependency, Store<State> store, Action action, NextDispatcher next);

class _InjectableMiddlewareOf<State, Action, O extends Injectable>
    implements MiddlewareClass<State> {
  const _InjectableMiddlewareOf({
    @required this.dependency,
    @required this.callback,
  })  : assert(dependency != null),
        assert(callback != null);

  final O dependency;
  final InjectableMiddlewareCallback<State, Action, O> callback;

  @override
  void call(Store<State> store, dynamic action, NextDispatcher next) {
    if (action is Action) {
      callback(dependency, store, action, next);
    } else {
      next(action);
    }
  }
}

class InjectableMiddlewareBuilder<State, Action, O extends Injectable> {
  InjectableMiddlewareBuilder({
    @required this.callback,
  }) : assert(callback != null);

  final InjectableMiddlewareCallback<State, Action, O> callback;

  _InjectableMiddlewareOf<State, Action, O> build(O dependency) {
    return _InjectableMiddlewareOf<State, Action, O>(
      dependency: dependency,
      callback: callback,
    );
  }
}

class InjectableMiddlewareOf<State, O extends Injectable> {
  const InjectableMiddlewareOf({
    this.builders = const [],
  }) : assert(builders != null);

  final Iterable<InjectableMiddlewareBuilder<State, dynamic, O>> builders;

  Iterable<Middleware<State>> call(O dependency) {
    assert(dependency != null);
    return [
      ...builders.map(
        (builder) => builder.build(dependency),
      ),
    ];
  }
}
