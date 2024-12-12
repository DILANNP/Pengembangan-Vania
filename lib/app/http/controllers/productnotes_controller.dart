import 'package:vania/vania.dart';
import 'package:vania_test/app/models/productnotes.dart'; // Pastikan untuk mengimport model Productnotes.
import 'package:vania/src/exception/validation_exception.dart';

class ProductnotesController extends Controller {
  // Menampilkan semua data catatan produk
  Future<Response> index() async {
    try {
      final listProductNotes = await Productnotes().query().get();
      return Response.json({
        'message': 'Daftar Catatan Produk',
        'data': listProductNotes,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data catatan produk',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menyimpan catatan produk baru
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'note_date': 'required|date',
        'note_text': 'required|string',
        'prod_id': 'required|integer',
      }, {
        'note_date.required': 'Tanggal catatan produk tidak boleh kosong',
        'note_text.required': 'Teks catatan tidak boleh kosong',
        'prod_id.required': 'ID produk tidak boleh kosong',
      });

      // Ambil data input
      final productNoteData = request.input();

      // Tambahkan nilai created_at dengan timestamp sekarang
      productNoteData['created_at'] = DateTime.now().toIso8601String();

      // Tambahkan data catatan produk ke database
      await Productnotes().query().insert(productNoteData);

      return Response.json({
        'message': 'Catatan produk berhasil dibuat',
        'data': productNoteData,
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat membuat catatan produk',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menampilkan data catatan produk berdasarkan ID
  Future<Response> show(int id) async {
    try {
      final productNote =
          await Productnotes().query().where('note_id', '=', id).first();

      if (productNote == null) {
        return Response.json({
          'message': 'Catatan produk dengan ID $id tidak ditemukan',
        }, 404);
      }

      return Response.json({
        'message': 'Detail Catatan Produk',
        'data': productNote,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data catatan produk',
        'error': e.toString(),
      }, 500);
    }
  }

  // Memperbarui catatan produk
  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'prod_id': 'required|integer',
        'note_date': 'required|date',
        'note_text': 'required|string'
      }, {
        'prod_id.required': 'ID produk wajib diisi.',
        'note_date.required': 'Tanggal catatan wajib diisi.',
        'note_text.required': 'Teks catatan wajib diisi.',
      });

      final noteData = request.input();

      final note =
          await Productnotes().query().where('note_id', '=', id).first();
      if (note == null) {
        return Response.json({
          'message': 'Catatan dengan ID $id tidak ditemukan.',
        }, 404);
      }

      noteData.remove('id');

      await Productnotes().query().where('note_id', '=', id).update(noteData);

      return Response.json({
        'message': 'Catatan berhasil diperbarui.',
        'data': noteData,
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

  // Menghapus catatan produk berdasarkan ID
  Future<Response> destroy(int id) async {
    try {
      final note =
          await Productnotes().query().where('note_id', '=', id).first();
      if (note == null) {
        return Response.json({
          'message': 'Catatan dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Productnotes().query().where('note_id', '=', id).delete();

      return Response.json({
        'message': 'Catatan berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus catatan.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductnotesController productnotesController = ProductnotesController();
