import 'package:vania/vania.dart';

class Customers extends Model {
  Customers() {
    super.table('customers');
  }
  List<String> get fillable => [
        'cust_id',
        'cust_name',
        'cust_address',
        'cust_city',
        'cust_state',
        'cust_zip',
        'cust_country',
        'cust_telp',
        'created_at',
        'updated_at'
      ];
}
