import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/features/auth/data/models/user_model.dart';
import 'package:echoemaar_commerce/features/auth/domain/entities/user.dart';
import 'package:echoemaar_commerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/login_with_email.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Import your domain files here...

// 1. Create a Mock class for the Repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {

  //repo
  late LoginWithEmail loginUseCase;
  late MockAuthRepository mockRepository;

  // setUp runs BEFORE every single test
  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginWithEmail(mockRepository);
  });
//output
  final tUser = User(uid: 1, email: 'abdo@gmail.com', username: 'Premium Client', partnerId: 1, companyName: '', sessionId: '');

  test('should return User when repository successfully logs in', () async {
    // 1. ARRANGE: Tell the mock what to do when called
    when(() => mockRepository.loginWithEmail('abdo@gmail.com', 'mmmmmmmm'))
        .thenAnswer((usr) async {

return Right(tUser);

        });

    // 2. ACT: Execute the specific method we are testing
    final result = await loginUseCase(LoginWithEmailParams(email:'abdo@gmail.com' ,password:'mmmmmmmm' ));

    // 3. ASSERT: Verify the result is exactly what we expect
    expect(result, Right(tUser));
    
    // Verify the repository was actually called exactly once
    verify(() => mockRepository.loginWithEmail('abdo@gmail.com', 'mmmmmmmm')).called(1);
  });
}