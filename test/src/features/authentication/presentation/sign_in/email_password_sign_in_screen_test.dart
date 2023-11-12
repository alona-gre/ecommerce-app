import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  final testEmail = 'test@test.com';
  final testPassword = '123456';
  late MockAuthRepository authRepository;
  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('signIn', () {
    testWidgets('''
    Given formType is signIn
    When tap the sign-in button
    Then signInWithEmailAndPassword is not called
    ''', (tester) async {
      final r = AuthRobot(tester);

      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );
      await r.tapEmailAndPasswordSubmitButton();
      verifyNever(
        () => authRepository.signInWithEmailAndPassword(
          any(),
          any(),
        ),
      );
    });

    testWidgets('''
    Given formType is signIn
    When enter email and password
    And tap the sign-in button
    Then signInWithEmailAndPassword is called
    and onSignedIn callback is called
    And error alert is not shown
    ''', (tester) async {
      var didSignIn = false;
      final r = AuthRobot(tester);
      when(() => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          )).thenAnswer((_) => Future.value());
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
        onSignedIn: () => didSignIn = true,
      );
      await r.enterEmail(testEmail);
      await r.enterPassword(testPassword);
      await r.tapEmailAndPasswordSubmitButton();
      verify(() => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          )).called(1);
      r.expectErrorAlertNotFound();
      expect(didSignIn, true);
    });

    testWidgets('''
    Given formType is signIn
    When signInWithEmailAndPassword is called
    And Connection is failed
    Then error alert is shown
    ''', (tester) async {
      final r = AuthRobot(tester);
      final exception = Exception('Connection failed');
      when(() => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          )).thenThrow(exception);
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );
      await r.enterEmail(testEmail);
      await r.enterPassword(testPassword);
      await r.tapEmailAndPasswordSubmitButton();
      verify(() => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          )).called(1);
      r.expectErrorAlertFound();
    });

    testWidgets('''
    Given formType is signIn
    When tap 'not registered'
    Then formType is changed to register
    ''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );
      r.tapFormToggleButton();
    });

    testWidgets('''
    Given formType is register
    When tap 'Have an account? Sign in'
    Then formType is changed to signIn
    ''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
      );
      r.tapFormToggleButton();
    });
  });
}
