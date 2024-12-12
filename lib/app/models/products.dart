import 'package:vania/vania.dart';

class Products extends Model {
  Products() {
    super.table('products');
  }

  List<String> get fillable => [
        'prod_id',
        'prod_name',
        'prod_price',
        'prod_desc',
        'vend_id',
        'created_at',
        'updated_at'
      ];
}
