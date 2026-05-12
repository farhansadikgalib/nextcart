import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_viewmodel.g.dart';

@riverpod
class OnboardingPage extends _$OnboardingPage {
  @override
  int build() => 0;

  void set(int page) => state = page;
}
