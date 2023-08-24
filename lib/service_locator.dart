
import 'package:get_it/get_it.dart';
import 'package:somtok/screens/feed_viewmodel.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<FeedViewModel>(FeedViewModel());
}
