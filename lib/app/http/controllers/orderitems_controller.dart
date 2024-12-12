import 'package:vania/vania.dart';
import 'package:vania_test/app/models/orderitems.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderitemsController extends Controller {
  // Menampilkan semua data order item
  Future<Response> index() async {
    try {
      final listOrderItems = await Orderitems().query().get();
      return Response.json({
        'message': 'Daftar Order Items',
        'data': listOrderItems,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data order item',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menyimpan order item baru
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'order_num': 'required|integer',
        'prod_id': 'required|integer',
        'quantity': 'required|integer',
        'size': 'required|string',
      }, {
        'order_num.required': 'Nomor order tidak boleh kosong',
        'prod_id.required': 'ID produk tidak boleh kosong',
        'quantity.required': 'Jumlah tidak boleh kosong',
        'size.required': 'Ukuran tidak boleh kosong',
      });

      // Ambil data input
      final orderItemData = request.input();

      // Tambahkan nilai created_at dengan timestamp sekarang
      orderItemData['created_at'] = DateTime.now().toIso8601String();

      // Tambahkan data order item ke database
      await Orderitems().query().insert(orderItemData);

      return Response.json({
        'message': 'Order item berhasil dibuat',
        'data': orderItemData,
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat membuat order item',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menampilkan data order item berdasarkan ID
  Future<Response> show(String id) async {
    try {
      final orderItem =
          await Orderitems().query().where('order_item', '=', id).first();

      if (orderItem == null) {
        return Response.json({
          'message': 'Order item dengan ID $id tidak ditemukan',
        }, 404);
      }

      return Response.json({
        'message': 'Detail Order Item',
        'data': orderItem,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data order item',
        'error': e.toString(),
      }, 500);
    }
  }

  // Memperbarui order item
  Future<Response> update(Request request, int id) async {
    try {
      // Validasi input
      request.validate({
        'order_num': 'required|integer',
        'prod_id': 'required|integer',
        'quantity': 'required|integer',
        'size': 'required|integer',
      }, {
        'order_num.required': 'Nomor order tidak boleh kosong',
        'prod_id.required': 'ID produk tidak boleh kosong',
        'quantity.required': 'Jumlah tidak boleh kosong',
        'size.required': 'Ukuran tidak boleh kosong',
      });

      final orderItemData = request.input();
      orderItemData['updated_at'] = DateTime.now().toIso8601String();

      // Menangani order item berdasarkan ID
      final orderItem =
          await Orderitems().query().where('order_item', '=', id).first();

      if (orderItem == null) {
        return Response.json({
          'message': 'Order item dengan ID $id tidak ditemukan',
        }, 404);
      }

      await Orderitems()
          .query()
          .where('order_item', '=', id)
          .update(orderItemData);

      return Response.json({
        'message': 'Order item berhasil diperbarui',
        'data': orderItemData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          'errors': errorMessages,
        }, 400);
      } else {
        return Response.json({
          'message': 'Terjadi kesalahan pada server',
        }, 500);
      }
    }
  }

  // Menghapus order item berdasarkan ID
  Future<Response> destroy(int id) async {
    try {
      final orderItem =
          await Orderitems().query().where('order_item', '=', id).first();

      if (orderItem == null) {
        return Response.json({
          'message': 'Order item dengan ID $id tidak ditemukan',
        }, 404);
      }

      await Orderitems().query().where('order_item', '=', id).delete();

      return Response.json({
        'message': 'Order item berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus order item',
        'error': e.toString(),
      }, 500);
    }
  }
}

final OrderitemsController orderitemsController = OrderitemsController();
