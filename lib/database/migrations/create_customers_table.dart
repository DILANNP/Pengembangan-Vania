import 'package:vania/vania.dart';

class CreateCustomersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('customers', () {
      string('cust_id', length: 36); // Definisi kolom biasa
      primary('cust_id'); // Jadikan sebagai primary key
      string('cust_name', length: 100);
      string('cust_address', length: 255);
      string('cust_city', length: 100);
      string('cust_state', length: 100);
      string('cust_zip', length: 20);
      string('cust_country', length: 100);
      string('cust_telp', length: 15);
      timeStamps(); // Menambahkan kolom created_at dan updated_at
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('customers'); // Hapus tabel jika rollback
  }
}
