import 'package:vania/vania.dart';

class Orderitems extends Model {
  Orderitems() {
    super.table('orderitems');
  }
  List<String> get fillable =>
      ['order_item', 'order_num', 'quantity', 'size', 'prod_id'];
}
