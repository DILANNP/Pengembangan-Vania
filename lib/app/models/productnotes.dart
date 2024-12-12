import 'package:vania/vania.dart';

class Productnotes extends Model {
  Productnotes() {
    super.table('productnotes');
  }
  List<String> get fillable => ['note_id', 'note_date', 'note_text', 'prod_id'];
}
