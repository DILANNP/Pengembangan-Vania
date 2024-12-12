import 'package:vania/vania.dart';
import 'package:vania_test/app/models/orderitems.dart';
import 'package:vania_test/app/models/orders.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrdersController extends Controller {
  // Menampilkan semua data order
  Future<Response> index() async {
    try {
      final listOrders = await Orders().query().get();
      return Response.json({
        'message': 'Daftar Order',
        'data': listOrders,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data order',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menyimpan order baru
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'cust_id': 'required|string',
        'order_date': 'required|date',
      }, {
        'cust_id.required': 'Customer ID tidak boleh kosong',
        'order_date.required': 'Tanggal order tidak boleh kosong',
      });

      // Ambil data input
      final orderData = request.input();

      // Generate order_num (misalnya, jika auto-increment tidak digunakan)
      final lastOrder =
          await Orders().query().orderBy('order_num', 'desc').first();
      orderData['order_num'] = (lastOrder?['order_num'] ?? 0) + 1;

      // Tambahkan data ke database
      await Orders().query().insert(orderData);

      return Response.json({
        'message': 'Order berhasil dibuat',
        'data': orderData,
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat membuat order',
        'error': e.toString(),
      }, 500);
    }
  }

// Menampilkan data order berdasarkan ID
  Future<Response> show() async {
    try {
      // Mengambil semua data order
      final orders = await Orders().query().get();

      if (orders.isEmpty) {
        return Response.json({
          'message': 'Tidak ada order ditemukan',
        }, 404);
      }

      return Response.json({
        'message': 'Daftar Order',
        'data': orders,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data order',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, int orderNum) async {
    try {
      // Validasi input
      request.validate({
        'order_date': 'required|date',
        'cust_id': 'required|string|max_length:5',
        'items': 'array',
      }, {
        'order_date.required': 'Tanggal order wajib diisi.',
        'cust_id.required': 'ID pelanggan wajib diisi.',
        'cust_id.string': 'ID pelanggan harus berupa teks.',
        'cust_id.max_length': 'ID pelanggan maksimal 5 karakter.',
      });

      final orderData = request.input();

      // Pastikan order dengan order_num terkait ada
      final order =
          await Orders().query().where('order_num', '=', orderNum).first();

      if (order == null) {
        return Response.json({
          'message': 'Order dengan ID $orderNum tidak ditemukan.',
        }, 404);
      }

      // Hilangkan field yang tidak perlu
      orderData.remove('order_num');

      // Perbarui data order
      await Orders()
          .query()
          .where('order_num', '=', orderNum)
          .update(orderData);

      // Perbarui item order jika ada dalam input
      if (orderData.containsKey('items')) {
        // Hapus item lama
        await Orderitems().query().where('order_num', '=', orderNum).delete();

        // Tambahkan item baru
        for (var item in orderData['items']) {
          item['order_num'] = orderNum;
          await Orderitems().query().insert(item);
        }
      }

      return Response.json({
        'message': 'Order berhasil diperbarui.',
        'data': orderData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        // Tangani kesalahan validasi
        final errorMessages = e.message;
        return Response.json({
          'errors': errorMessages,
        }, 400);
      } else {
        // Tangani kesalahan lainnya
        return Response.json({
          'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
          'error': e.toString(),
        }, 500);
      }
    }
  }

// Menghapus order berdasarkan ID
  Future<Response> destroy(int id) async {
    try {
      final order = await Orders().query().where('order_num', '=', id).first();

      if (order == null) {
        return Response.json({
          'message': 'Order dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Orders().query().where('order_num', '=', id).delete();
      await Orderitems().query().where('order_num', '=', id).delete();

      return Response.json({
        'message': 'Order berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus order.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final OrdersController ordersController = OrdersController();
