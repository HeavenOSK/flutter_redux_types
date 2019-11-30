# redux_types
A package of simple utilities for development with [Redux](https://pub.dartlang.org/packages/redux).

It helps you write Redux boilerplate comfortably & cleanly.

This package is fully inspired from [Redux.dart](https://pub.dartlang.org/packages/redux) 3.0.0+.

## Dependencies
  * Dart 2.2.3+
  * [Redux.dart](https://pub.dartlang.org/packages/redux) 3.0.0+.

## `ReducerOf` & `MiddlewareOf`
These are more cleaned type matching classes for Redux than `TypedReducer` & `TypedMiddleware` of [Redux.dart](https://pub.dartlang.org/packages/redux). You can comfortably write type matching classes with IDE support like Android Studio.

  * `ReducerOf` - A Reducer class for type matching. It's better to write & read with IDE support.
  * `MiddlewareOf` - A Middleware class for type matching. It's better to write & read with IDE support.

## Usage

Demonstrate how to use `redux_types`.

### ReducerOf

```dart
final Reducer<AppState> appReducer = combineReducers(
  [
    /// An example of using [ReducerOf]. It provides you
    /// an ease of writing by IDE support and readability.
    ReducerOf<AppState, IncrementAction>(
      callback: (state, action) {
        return state.copyWith(
          counter: state.counter + 1,
        );
      },
    ),
  ],
);
```

### MiddlewareOf

```dart
List<Middleware<AppState>> counterMiddleware() {
  return [
    /// An example of using [MiddlewareOf]. It provides you
    /// an ease of writing by IDE support and readability.
    MiddlewareOf<AppState, IncrementAction>(
      callback: (store, action, next) {
        print('IncrementAction was called!');
        next(action);
      },
    ),
  ];
}
```
