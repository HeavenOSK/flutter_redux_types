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

class ShowDialogAction {}

/// An example of using [ReducerOf].
final appReducer = combineReducers<AppState>(
  [
    ReducerOf<AppState, IncrementAction>(
      callback: (state, action) {
        return state.copyWith(
          counter: state.counter + 1,
        );
      },
    ),
    ReducerOf<AppState, DecrementAction>(
      callback: (state, action) {
        return state.copyWith(
          counter: state.counter - 1,
        );
      },
    ),
  ],
);

/// An example of using [MiddlewareOf].
List<Middleware<AppState>> counterMiddleware() {
  return [
    MiddlewareOf<AppState, IncrementAction>(
      callback: (store, action, next) {
        print('IncrementAction was called!');
        next(action);
      },
    ),
    MiddlewareOf<AppState, DecrementAction>(
      callback: (store, action, next) {
        print('DecrementAction was called!');
        next(action);
      },
    ),
  ];
}

/// An example of using [InjectionMiddlewareOf].
List<Middleware<AppState>> navigatorMiddleware(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return [
    InjectionMiddlewareOf<AppState, ShowDialogAction,
        GlobalKey<NavigatorState>>(
      dependency: navigatorKey,
      callback: (state, action, next, key) {
        showDialog<void>(
          context: key.currentState.overlay.context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Injectable'),
            );
          },
        );
      },
    ),
  ];
}

void main() {
  final navigatorKey = GlobalKey<NavigatorState>();
  runApp(
    StoreProvider<AppState>(
      store: Store<AppState>(
        appReducer,
        initialState: AppState.initialize(),
        middleware: [
          ...counterMiddleware(),
          ...navigatorMiddleware(navigatorKey),
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
            child: const Icon(Icons.plus_one),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => store.dispatch(DecrementAction()),
            tooltip: 'Decrement',
            child: const Icon(Icons.exposure_neg_1),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => store.dispatch(ShowDialogAction()),
            tooltip: 'Decrement',
            child: const Icon(Icons.flash_on),
          ),
        ],
      ),
    );
  }
}
