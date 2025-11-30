import 'package:async/async.dart';

class FutureGroupDelayed extends FutureGroup {
  addF(
    Future future,
  ) {
    return super.add(
      Future.delayed(
        Duration.zero,
        () => future,
      ),
    );
  }
}
