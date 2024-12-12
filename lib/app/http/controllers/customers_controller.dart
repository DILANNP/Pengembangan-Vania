import 'package:vania/vania.dart';
import 'package:vania_test/app/models/customers.dart';
import 'package:vania/src/exception/validation_exception.dart';

class CustomersController extends Controller {
  Future<Response> getAllCustomers() async {
    try {
      final customers = await Customers().query().get();
      return Response.json({'message': 'Data pelanggan', 'data': customers});
    } catch (e) {
      return Response.json(
          {'message': 'Error fetching customers', 'error': e.toString()}, 500);
    }
  }

  Future<Response> getCustomerById(String custId) async {
    print("Received custId: $custId"); // Menampilkan nilai custId yang diterima
    try {
      final customer =
          await Customers().query().where('cust_id', '=', custId).first();
      print(
          "Customer found: $customer"); // Menampilkan data customer jika ditemukan
      if (customer == null) {
        print(
            "No customer found with cust_id: $custId"); // Log jika tidak ada customer
        return Response.json({'message': 'Customer not found'}, 404);
      }
      return Response.json({'message': 'Customer data', 'data': customer});
    } catch (e) {
      print(
          "Error fetching customer: $e"); // Menampilkan kesalahan yang terjadi
      return Response.json(
          {'message': 'Error fetching customer', 'error': e.toString()}, 500);
    }
  }

  Future<Response> createCustomer(Request request) async {
    // Validasi data input
    request.validate({
      'cust_id': 'required|string',
      'cust_name': 'required|string|max_length:100',
      'cust_address': 'required|string|max_length:255',
      'cust_city': 'required|string|max_length:100',
      'cust_state': 'required|string|max_length:50',
      'cust_zip': 'required|string|max_length:20',
      'cust_country': 'required|string|max_length:50',
      'cust_telp': 'required|string|max_length:15',
    });

    try {
      // Ambil data input dari request
      final customerData = request.input();

      // Tambahkan nilai created_at dengan timestamp sekarang
      customerData['created_at'] = DateTime.now().toIso8601String();

      // Debugging: periksa data sebelum insert
      print('Customer data before insert: $customerData');

      // Simpan data ke database
      await Customers().query().insert(customerData);

      // Respons sukses
      return Response.json(
        {'message': 'Customer created successfully', 'data': customerData},
        201,
      );
    } catch (e) {
      // Tangani error
      return Response.json(
        {'message': 'Error creating customer', 'error': e.toString()},
        500,
      );
    }
  }

  Future<Response> update(Request request, int custId) async {
    try {
      request.validate({
        'cust_name': 'string|max_length:50',
        'cust_address': 'string|max_length:50',
        'cust_city': 'string|max_length:20',
        'cust_state': 'string|max_length:5',
        'cust_zip': 'string|max_length:7',
        'cust_country': 'string|max_length:25',
        'cust_telp': 'string|max_length:15',
      }, {
        'cust_name.string': 'Nama customer harus berupa teks.',
        'cust_name.max_length': 'Nama customer maksimal 50 karakter.',
      });

      final customerData = request.input();

      // Ensure you're using the correct column name to query the customer
      final customer =
          await Customers().query().where('cust_id', '=', custId).first();

      if (customer == null) {
        return Response.json({
          'message': 'Customer dengan ID $custId tidak ditemukan.',
        }, 404);
      }
      customerData.remove('custid');
      await Customers()
          .query()
          .where('cust_id', '=', custId)
          .update(customerData);

      return Response.json({
        'message': 'Customer berhasil diperbarui.',
        'data': customerData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          'errors': errorMessages,
        }, 400);
      } else {
        return Response.json({
          'message':
              'Terjadi kesalahan di sisi server. Harap coba lagi nanti. $e',
        }, 500);
      }
    }
  }

  Future<Response> destroy(int custId) async {
    try {
      // Mencari customer berdasarkan cust_id
      final customer =
          await Customers().query().where('cust_id', '=', custId).first();

      if (customer == null) {
        return Response.json({
          'message': 'Customer dengan ID $custId tidak ditemukan.',
        }, 404);
      }

      // Menghapus customer
      await Customers().query().where('cust_id', '=', custId).delete();

      return Response.json({
        'message': 'Customer berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus customer.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final CustomersController customersController = CustomersController();
