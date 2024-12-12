import 'dart:io';
import 'package:vania/vania.dart';
import 'create_product_table.dart';
import 'create_customers_table.dart';
import 'create_orders_table.dart';
import 'create_orderitems_table.dart';
import 'create_vendors_table.dart';
import 'create_productnotes_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreateProductTable().up();
    await CreateCustomersTable().up();
    await CreateOrdersTable().up();
    await CreateOrderitemsTable().up();
    await CreateVendorsTable().up();
    await CreateProductnotesTable().up();
  }

  dropTables() async {
    await CreateProductnotesTable().down();
    await CreateVendorsTable().down();
    await CreateOrderitemsTable().down();
    await CreateOrdersTable().down();
    await CreateCustomersTable().down();
    await CreateProductTable().down();
  }
}
