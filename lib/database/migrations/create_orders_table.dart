import 'package:vania/vania.dart';

class CreateOrdersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orders', () {
      integer('order_num', length: 5);
      primary('order_num');
      dateTime('order_date', nullable: false);
      string('cust_id',
          length: 36,
          nullable: false); // Kolom foreign key cust_id (not nullable)

      // Definisi foreign key
      foreign('cust_id', 'customers', 'cust_id',
          onDelete: 'CASCADE', onUpdate: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orders');
  }
}
