import 'package:vania/vania.dart';

class User extends Model {
  User() {
    super.table('user');
  }

  List<String> get fillable => [
        'id',
        'username',
        'email',
        'password',
      ];
}
