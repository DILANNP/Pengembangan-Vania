import 'package:vania/vania.dart';
import 'package:vania_test/app/models/user.dart';

class AuthController extends Controller {
  Future<Response> login(Request request) async {
    try {
      // Ambil input email dan password
      final String? email = request.input('email');
      final String? password = request.input('password');

      // Validasi input
      if (email == null || password == null) {
        return Response.json(
          {'message': 'Email and password are required'},
          400,
        );
      }

      // Ambil data user berdasarkan email
      final Map<String, dynamic>? user =
          await User().query().where('email', '=', email).first();

      // Periksa apakah user ditemukan
      if (user == null) {
        return Response.json(
          {'message': 'User not found'},
          404,
        );
      }

      // Verifikasi password
      final bool isPasswordValid = Hash().verify(password, user['password']);
      if (!isPasswordValid) {
        return Response.json({'message': 'Password salah'}, 401);
      }

      // Autentikasi user dan buat token
      final Map<String, dynamic> token = await Auth()
          .login(user)
          .createToken(expiresIn: Duration(hours: 24), withRefreshToken: true);

      // Berikan respons sukses dengan token
      return Response.json({
        'message': 'Login successful',
        'token': token,
      }, 200);
    } catch (e) {
      // Tangani kesalahan tak terduga
      return Response.json({
        'error': 'An unexpected error occurred',
        'details': e.toString(),
      }, 500);
    }
  }

  Future<Response> register(Request request) async {
    try {
      request.validate({
        'username': 'required',
        'email': 'required',
        'password': 'required',
      }, {
        // Pesan kustom untuk 'username'
        'username.required': 'Username tidak boleh kosong',

        // Pesan kustom untuk 'email'
        'email.required': 'Email tidak boleh kosong',

        // Pesan kustom untuk 'password'
        'password.required': 'Password tidak boleh kosong',
      });

      final dataInput = request.input();
      final password = dataInput['password'];
      dataInput['password'] = Hash().make(password);

      final existingEmail =
          await User().query().where('email', '=', dataInput['email']).first();

      if (existingEmail != null) {
        return Response.json({'message': 'Email sudah dipakai'}, 409);
      }

      await User().query().insert(dataInput);

      return Response.json(
          {'message': 'Akun berhasil dibuat', 'data': dataInput}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Gagal membuat akun', 'error': e.toString()}, 201);
    }
  }

  Future<Response> allLogout(Request request) async {
    try {
      Auth().deleteCurrentToken();
      return Response.json({
        'message': 'Logout successful',
      }, 200);
    } catch (e) {
      return Response.json({
        'error': 'An unexpected error occurred',
        'details': e.toString(),
      }, 500);
    }
  }
}

final AuthController authController = AuthController();
