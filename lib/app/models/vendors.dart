import 'package:vania/vania.dart';

class Vendors extends Model {
  Vendors() {
    super.table('vendors');
  }

  List<String> get fillable => [
        'vend_id',
        'vend_name',
        'vend_address',
        'vend_kota',
        'vend_state',
        'vend_zip',
        'vend_country'
      ];
}
