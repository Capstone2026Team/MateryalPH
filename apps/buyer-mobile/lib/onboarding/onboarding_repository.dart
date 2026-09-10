import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingRepository {
  Future<bool> isComplete();

  Future<void> complete();
}

final class SharedPreferencesOnboardingRepository
    implements OnboardingRepository {
  static const _key = 'buyer_onboarding_complete_v1';

  @override
  Future<bool> isComplete() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_key) ?? false;
  }

  @override
  Future<void> complete() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_key, true);
  }
}
