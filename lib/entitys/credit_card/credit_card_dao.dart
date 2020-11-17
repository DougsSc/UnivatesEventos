import '../base_dao.dart';
import 'credit_card.dart';

class CardDAO extends BaseDAO<CreditCard> {

  @override
  String get tableName => CreditCard.ENTITY;

  @override
  fromMap(Map<String, dynamic> map) {
    return CreditCard.fromMap(map);
  }
}