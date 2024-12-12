import 'package:vania/vania.dart';

class Orders extends Model {
  Orders() {
    super.table('orders'); // Gunakan super.table untuk menetapkan nama tabel
  }

  List<String> get fillable => ['order_num', 'order_date', 'cust_id'];
}
