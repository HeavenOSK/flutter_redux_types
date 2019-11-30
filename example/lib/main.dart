import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_types/redux_types.dart';

/// AppState which has only counter value.
@immutable
class AppState {
  const AppState._({
    this.counter,
  });

  factory AppState.initialize() {
    return const AppState._(
      counter: 0,
    );
  }

  final int counter;

  AppState copyWith({
    int counter,
  }) {
    return AppState._(
      counter: counter ?? this.counter,
    );
  }

  @override
  String toString() => 'AppState{'
      'counter:$counter'
      '}';
}

/// Actions
class IncrementAction {}

class DecrementAction {}

/// Reducers
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

    /// An example of using [TypeReducer]. It's hard to write
    /// parameters because IDE doesn't know about [TypedReducer].
    TypedReducer<AppState, DecrementAction>(
      (state, action) {
        return state.copyWith(
          counter: state.counter - 1,
        );
      },
    ),
  ],
);

/// Middleware
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

    /// An example of using [TypedMiddleware]. It's hard to write
    /// parameters because IDE doesn't know about [TypedMiddleware].
    TypedMiddleware<AppState, DecrementAction>(
      (store, action, next) {
        print('DecrementAction was called!');
        next(action);
      },
    ),
  ];
}

class PushAction {}

final InjectableMiddleware<AppState, GlobalKey<NavigatorState>>
    navigatorMiddleware =
    InjectableMiddleware<AppState, GlobalKey<NavigatorState>>(
  builders: [
    InjectableMiddlewareBuilder<AppState, PushAction,
        GlobalKey<NavigatorState>>(
      callback: (dependency, store, action, next) {
        showDialog<void>(
          context: dependency.currentState.overlay.context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Injectable'),
            );
          },
        );
      },
    ),
  ],
);

void main() {
  final navigatorKey = GlobalKey<NavigatorState>();
  runApp(
    StoreProvider<AppState>(
      store: Store<AppState>(
        appReducer,
        initialState: AppState.initialize(),
        middleware: [
          ...counterMiddleware(),
        ],
      ),
      child: MaterialApp(
        title: 'redux_util_demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: navigatorKey,
        home: const HomePage(),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('redux_util_demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            StoreConnector<AppState, String>(
              converter: (store) => store.state.counter.toString(),
              builder: (context, count) {
                return Text(
                  count,
                  style: Theme.of(context).textTheme.display1,
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () => store.dispatch(IncrementAction()),
            tooltip: 'Increment',
            child: new Icon(Icons.plus_one),
          ),
          FloatingActionButton(
            onPressed: () => store.dispatch(DecrementAction()),
            tooltip: 'Decrement',
            child: new Icon(Icons.exposure_neg_1),
          ),
        ],
      ),
    );
  }
}
