import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  final FakeAuthRepository authRepository;

  AccountScreenController({required this.authRepository})
      : super(const AsyncData<void>(null));

  Future<bool> signOut() async {
    // set state to loading
    // sign out (using auth repository)
    // if success, set state to data
    // if error, set state to error

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signOut());
    return state.hasError == false;
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return AccountScreenController(authRepository: authRepository);
});
