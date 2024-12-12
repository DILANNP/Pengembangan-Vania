import 'package:vania/vania.dart';
import 'package:vania_test/app/models/vendors.dart';
import 'package:vania/src/exception/validation_exception.dart';

class VendorsController extends Controller {
  // Get all vendors
  Future<Response> index() async {
    try {
      final listVendors = await Vendors().query().get();
      return Response.json({
        'message': 'Daftar semua vendor',
        'data': listVendors,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data vendor',
        'error': e.toString(),
      }, 500);
    }
  }

  // Store a new vendor
  Future<Response> store(Request request) async {
    request.validate({
      'vend_id': 'required|string|max_length:5',
      'vend_name': 'required|string|max_length:50',
      'vend_address': 'required|string',
      'vend_kota': 'required|string',
      'vend_state': 'required|string|max_length:5',
      'vend_zip': 'required|string|max_length:7',
      'vend_country': 'required|string|max_length:25',
    });

    try {
      final vendorData = request.input();

      // Check for duplicate vendor ID
      final existingVendor = await Vendors()
          .query()
          .where('vend_id', '=', vendorData['vend_id'])
          .first();

      if (existingVendor != null) {
        return Response.json({
          'message': 'Vendor dengan ID ini sudah ada',
        }, 409);
      }

      vendorData['created_at'] = DateTime.now().toIso8601String();

      await Vendors().query().insert(vendorData);

      return Response.json({
        'message': 'Vendor berhasil ditambahkan!',
        'data': vendorData,
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan pada server',
        'error': e.toString(),
      }, 500);
    }
  }

  // Show a specific vendor
  Future<Response> show(int id) async {
    try {
      final vendor = await Vendors().query().where('vend_id', '=', id).first();

      if (vendor == null) {
        return Response.json({
          'message': 'Vendor dengan ID $id tidak ditemukan',
        }, 404);
      }

      return Response.json({
        'message': 'Detail vendor',
        'data': vendor,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil detail vendor',
        'error': e.toString(),
      }, 500);
    }
  }

  // Update a vendor
  Future<Response> update(Request request, int vendorId) async {
    try {
      request.validate({
        'vend_name': 'string|max_length:100',
        'vend_address': 'string|max_length:255',
        'vend_kota': 'string|max_length:50',
        'vend_state': 'string|max_length:50',
        'vend_zip': 'string|max_length:10',
        'vend_country': 'string|max_length:50',
      }, {
        'vend_name.string': 'Nama vendor harus berupa teks.',
        'vend_name.max_length': 'Nama vendor maksimal 100 karakter.',
      });

      final vendorData = request.input();

      final vendor =
          await Vendors().query().where('vend_id', '=', vendorId).first();
      if (vendor == null) {
        return Response.json({
          'message': 'Vendor dengan ID $vendorId tidak ditemukan.',
        }, 404);
      }
      vendorData['vend_id'] = vendorData.remove('vendorid');
      print(vendorData);
      await Vendors()
          .query()
          .where('vend_id', '=', vendorId)
          .update(vendorData);

      return Response.json({
        'message': 'Vendor berhasil diperbarui.',
        'data': vendorData,
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

  // Delete a vendor
  Future<Response> destroy(int id) async {
    try {
      final vendor = await Vendors().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json({
          'message': 'Vendor dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Vendors().query().where('vend_id', '=', id).delete();

      return Response.json({
        'message': 'Vendor berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus vendor.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final VendorsController vendorsController = VendorsController();
