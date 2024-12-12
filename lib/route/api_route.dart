import 'package:vania/vania.dart';
import 'package:vania_test/app/http/controllers/orderitems_controller.dart';
import 'package:vania_test/app/http/controllers/productnotes_controller.dart';
import 'package:vania_test/app/http/controllers/products_controller.dart';
import 'package:vania_test/app/http/controllers/customers_controller.dart';
import 'package:vania_test/app/http/controllers/orders_controller.dart';
import 'package:vania_test/app/http/controllers/vendors_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    // Base Router
    Router.basePrefix('api');

    // Routes untuk product
    Router.get('products', productController.index);
    Router.get('products/{id}', productController.show);
    Router.post('products', productController.store);
    Router.put('products/{id}', productController.update);
    Router.delete('products/{id}', productController.destroy);

    // Routes untuk customers
    Router.get('customers', customersController.getAllCustomers);
    Router.get('customers/<custId>', customersController.getCustomerById);
    Router.post('customers', customersController.createCustomer);
    Router.put('customers/{custId}', customersController.update);
    Router.delete('customers/{custId}', customersController.destroy);

    // Routes untuk orders
    Router.post('orders', ordersController.store);
    Router.get('orders', ordersController.show);
    Router.put('orders/{order_num}', ordersController.update);
    Router.delete('orders/{id}', ordersController.destroy);

    //Routes Vendors
    Router.get('vendors/', vendorsController.index);
    Router.post('vendors/', vendorsController.store);
    Router.get('vendors/{id}', vendorsController.show);
    Router.put('vendors/{vendorId}', vendorsController.update);
    Router.delete('vendors/{id}', vendorsController.destroy);

    //Routes Productnotes
    Router.get('productnotes/', productnotesController.index);
    Router.post('productnotes/', productnotesController.store);
    Router.get('productnotes/{id}', productnotesController.show);
    Router.put('productnotes/{id}', productnotesController.update);
    Router.delete('productnotes/{id}', productnotesController.destroy);

    //Routes OrderItems
    Router.get('orderitems/', orderitemsController.index);
    Router.post('orderitems/', orderitemsController.store);
    Router.get('orderitems/{id}', orderitemsController.show);
    Router.put('orderitems/{id}', orderitemsController.update);
    Router.delete('orderitems/{id}', orderitemsController.destroy);
  }
}
