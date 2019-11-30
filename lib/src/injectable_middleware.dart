import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

typedef InjectableMiddlewareCallback<S, T, O> = void Function(
  O dependency,
  Store<S> store,
  T action,
  NextDispatcher next,
);

class _InjectableMiddleware<S, T, O> implements MiddlewareClass<S> {
  const _InjectableMiddleware({
    @required this.dependency,
    @required this.callback,
  })  : assert(dependency != null),
        assert(callback != null);

  final O dependency;
  final InjectableMiddlewareCallback<S, T, O> callback;

  @override
  void call(Store<S> store, dynamic action, NextDispatcher next) {
    if (action is T) {
      callback(dependency, store, action, next);
    } else {
      next(action);
    }
  }
}

class InjectableMiddlewareBuilder<S, T, O> {
  InjectableMiddlewareBuilder({
    @required this.callback,
  }) : assert(callback != null);

  final InjectableMiddlewareCallback<S, T, O> callback;

  _InjectableMiddleware<S, T, O> build(O dependency) {
    return _InjectableMiddleware<S, T, O>(
      dependency: dependency,
      callback: callback,
    );
  }
}

class InjectableMiddleware<S, O> {
  const InjectableMiddleware({
    this.builders = const [],
  }) : assert(builders != null);

  final Iterable<InjectableMiddlewareBuilder<S, dynamic, O>> builders;

  Iterable<MiddlewareClass<S>> cal(O dependency) {
    assert(builders != null);
    return [
      ...builders.map(
        (builder) => builder.build(dependency),
      ),
    ];
  }
}
