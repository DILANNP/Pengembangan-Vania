import 'dart:io';
import 'package:vania/vania.dart';
import 'package:vania_test/database/migrations/create_personal_access_tokens_table.dart';
import 'create_product_table.dart';
import 'create_customers_table.dart';
import 'create_orders_table.dart';
import 'create_orderitems_table.dart';
import 'create_vendors_table.dart';
import 'create_productnotes_table.dart';
import 'create_user_table.dart';

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
    await CreatePersonalAccessTokensTable().up();
    await CreateProductTable().up();
    await CreateCustomersTable().up();
    await CreateOrdersTable().up();
    await CreateOrderitemsTable().up();
    await CreateVendorsTable().up();
    await CreateProductnotesTable().up();
    await CreateUserTable().up();
  }

  dropTables() async {
    await CreateUserTable().down();
    await CreateProductnotesTable().down();
    await CreateVendorsTable().down();
    await CreateOrderitemsTable().down();
    await CreateOrdersTable().down();
    await CreateCustomersTable().down();
    await CreateProductTable().down();
  }
}
