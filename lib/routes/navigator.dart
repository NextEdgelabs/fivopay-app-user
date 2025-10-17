import '../main.dart';

Future<dynamic> push(String routeName, {Object? arguments}) =>
    navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);

Future<dynamic> pushReplacement(String routeName, {Object? arguments}) =>
    navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);

Future<dynamic> pushAndRemoveUntil(String routeName, {Object? arguments}) =>
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);

pop([data]) => navigatorKey.currentState!.pop(data);
