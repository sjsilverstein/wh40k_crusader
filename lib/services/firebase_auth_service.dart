import 'package:firebase_auth/firebase_auth.dart';
import 'package:wh40k_crusader/app/app_logger.dart';

class FirebaseAuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // String? _pendingEmail;
  AuthCredential? _pendingCredential;

  /// Returns the current logged in Firebase User
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  /// Returns the latest userToken stored in the Firebase Auth lib
  Future<String>? get userToken {
    return _firebaseAuth.currentUser?.getIdToken();
  }

  /// Returns true when a user has logged in or signed on this device
  bool get hasUser {
    return _firebaseAuth.currentUser != null;
  }

  Future<FirebaseAuthenticationResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // log?.d('email:$email');
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Link the pending credential with the existing account
      if (_pendingCredential != null) {
        await result.user?.linkWithCredential(_pendingCredential!);
        _clearPendingData();
      }

      return FirebaseAuthenticationResult(user: result.user);
    } on FirebaseAuthException catch (e) {
      // log?.e('A firebase exception has occured. $e');
      return FirebaseAuthenticationResult.error(
          errorMessage: getErrorMessageFromFirebaseException(e));
    } on Exception catch (e) {
      logger.e('A general exception has occured. $e');
      return FirebaseAuthenticationResult.error(
          errorMessage:
              'We could not log into your account at this time. Please try again.');
    }
  }

  /// Uses `createUserWithEmailAndPassword` to sign up to the Firebase application
  Future<FirebaseAuthenticationResult> createAccountWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // log?.d('email:$email');
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // log?.d(
      //     'Create user with email result: ${result.credential} ${result.user}');

      return FirebaseAuthenticationResult(user: result.user);
    } on FirebaseAuthException catch (e) {
      // log?.e('A firebase exception has occured. $e');
      return FirebaseAuthenticationResult.error(
          errorMessage: getErrorMessageFromFirebaseException(e));
    } on Exception catch (e) {
      logger.e('A general exception has occured. $e');
      return FirebaseAuthenticationResult.error(
          errorMessage:
              'We could not create your account at this time. Please try again.');
    }
  }

  /// Sign out of the social accounts that have been used
  Future logout() async {
    // log?.i('');

    try {
      await _firebaseAuth.signOut();
      // await _googleSignIn.signOut();
      _clearPendingData();
    } catch (e) {
      // log?.e('Could not sign out of social account. $e');
    }
  }

  void _clearPendingData() {
    // _pendingEmail = null;
    _pendingCredential = null;
  }
}

class FirebaseAuthenticationResult {
  /// Firebase user
  final User? user;

  /// Contains the error message for the request
  final String? errorMessage;

  FirebaseAuthenticationResult({this.user}) : errorMessage = null;

  FirebaseAuthenticationResult.error({this.errorMessage}) : user = null;

  /// Returns true if the response has an error associated with it
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}

String getErrorMessageFromFirebaseException(FirebaseAuthException exception) {
  switch (exception.code.toLowerCase()) {
    case 'email-already-in-use':
      return 'An account already exists for the email you\'re trying to use. Login instead.';
    case 'invalid-email':
      return 'The email you\'re using is invalid. Please use a valid email.';
    case 'operation-not-allowed':
      return 'The authentication is not enabled on Firebase. Please enable the Authentitcation type on Firebase';
    case 'weak-password':
      return 'Your password is too weak. Please use a stronger password.';
    case 'wrong-password':
      return 'You seemed to have entered the wrong password. Double check it and try again.';
    default:
      return exception.message ??
          'Something went wrong on our side. Please try again';
  }
}
