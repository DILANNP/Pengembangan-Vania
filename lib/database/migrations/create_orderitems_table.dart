import 'package:vania/vania.dart';

class CreateOrderitemsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orderitems', () {
      integer('order_item', length: 11);
      primary('order_item');
      integer('order_num', length: 5, nullable: false);
      integer('quantity', length: 11);
      integer('size', length: 11);
      timeStamps();
      integer('prod_id',
          length: 10,
          nullable: false); // Kolom foreign key cust_id (not nullable)

      // Definisi foreign key
      foreign('prod_id', 'products', 'prod_id',
          onDelete: 'CASCADE', onUpdate: 'CASCADE');
      foreign('order_num', 'orders', 'order_num',
          onDelete: 'CASCADE', onUpdate: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
