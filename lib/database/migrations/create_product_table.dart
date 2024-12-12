import 'package:vania/vania.dart';

class CreateProductTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('products', () {
      integer('prod_id', length: 10);
      primary('prod_id');
      string('prod_name', length: 50);
      decimal('prod_price', precision: 10, scale: 2);
      text('prod_desc');
      timeStamps();
      integer('vend_id', length: 5, nullable: false);

      foreign('vend_id', 'vendors', 'vend_id',
          onDelete: 'CASCADE', onUpdate: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}
