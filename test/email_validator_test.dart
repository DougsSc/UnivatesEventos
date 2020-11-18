import 'package:flutter_test/flutter_test.dart';
import 'package:minicurso/utils/validator.dart';

void main() {
  test('Invalid', () {
    var result = FieldValidator.isValidEmail('teste.com.br');
    expect(result, false);
  });

  test('Valid', () {
    var result = FieldValidator.isValidEmail('teste@univates.com.br');
    expect(result, true);
  });
}
