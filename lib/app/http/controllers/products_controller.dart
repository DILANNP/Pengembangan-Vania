import 'package:vania/vania.dart';
import 'package:vania_test/app/models/products.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductsController extends Controller {
  Future<Response> index() async {
    try {
      final listProduct = await Products().query().get();
      return Response.json({
        'message': 'Daftar produk',
        'data': listProduct,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data produk',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    request.validate({
      'prod_name': 'required|string|max_length:50',
      'prod_desc': 'required|string',
      'prod_price': 'required|numeric|min:0',
      'vend_id': 'required|string|max_length:5',
    }, {
      'prod_name.required': 'Nama produk tidak boleh kosong',
      'prod_name.string': 'Nama produk harus berupa teks',
      'prod_name.max_length': 'Nama produk maksimal 50 karakter',
      'prod_desc.required': 'Deskripsi produk tidak boleh kosong',
      'prod_desc.string': 'Deskripsi produk harus berupa teks',
      'prod_price.required': 'Harga produk tidak boleh kosong',
      'prod_price.numeric': 'Harga produk harus berupa angka',
      'prod_price.min': 'Harga produk tidak boleh kurang dari 0',
      'vend_id.required': 'Vendor ID tidak boleh kosong',
      'vend_id.string': 'Vendor ID harus berupa teks',
      'vend_id.max_length': 'Vendor ID maksimal 5 karakter',
    });

    try {
      final productData = request.input();

      // Pastikan produk tidak duplikat
      final existingProduct = await Products()
          .query()
          .where('prod_name', '=', productData['prod_name'])
          .first();

      if (existingProduct != null) {
        return Response.json({
          'message': 'Produk dengan nama ini sudah ada',
        }, 409);
      }

      productData['created_at'] = DateTime.now().toIso8601String();
      productData['updated_at'] = DateTime.now().toIso8601String();

      await Products().query().insert(productData);

      return Response.json({
        "message": "Produk berhasil ditambahkan!",
        "data": productData,
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan pada server: ${e.toString()}',
      }, 500);
    }
  }

  Future<Response> show(int id) async {
    try {
      final product =
          await Products().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan',
        }, 404);
      }

      return Response.json({
        'message': 'Detail produk',
        'data': product,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil detail produk',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'prod_id': 'required|integer',
        'vend_id': 'required|integer',
        'prod_name': 'required|string|max_length:100',
        'prod_desc': 'required|string|max_length:255',
        'prod_price': 'required|int|min:0'
      });

      final productData = request.input();

      final product =
          await Products().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }
      productData.remove('id');

      await Products().query().where('prod_id', '=', id).update(productData);

      return Response.json({
        'message': 'Produk berhasil diperbarui.',
        'data': productData,
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

  Future<Response> destroy(int id) async {
    try {
      // Cari produk berdasarkan ID
      final product =
          await Products().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      // Hapus produk
      await Products().query().where('prod_id', '=', id).delete();

      return Response.json({
        'message': 'Produk berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus produk.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductsController productController = ProductsController();
