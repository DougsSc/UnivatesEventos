
import 'package:flutter/material.dart';
import 'package:minicurso/entitys/credit_card/credit_card.dart';

class PaymentCard {
  CardType type;
  String number;
  String name;
  int month;
  int year;
  int cvv;

  PaymentCard({
    this.type,
    this.number,
    this.name,
    this.month,
    this.year,
    this.cvv,
  });

  @override
  String toString() {
    return '[Type: $type, Number: $number, Name: $name, Month: $month, Year: $year, CVV: $cvv]';
  }

  CreditCard toCard() {
    return CreditCard(
      number: number,
      validate: '$month/$year',
      secureCode: cvv,
      flag: type.toString().replaceAll('CardType.', ''),
    );
  }
}

enum CardType {
  ELO,
  MASTER,
  VISA,
  VERVE,
  DISCOVER,
  AMEX,
  DINERS,
  JCB,
  OTHERS,
  INVALID
}

class CardUtils {
  static String validateCVV(String value) {
    if (value.isEmpty) {
      return 'Este campo é obrigatório';
    }

    if (value.length < 3 || value.length > 4) {
      return "CVV inválido";
    }
    return null;
  }

  static String validateDate(String value) {
    if (value.isEmpty) {
      return 'Este campo é obrigatório';
    }

    int year;
    int month;
    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(new RegExp(r'(\/)'))) {
      var split = value.split(new RegExp(r'(\/)'));
      // The value before the slash is the month while the value to right of
      // it is the year.
      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      // Only the month was entered
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }

    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return 'Mês inválido';
    }

    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      // We are assuming a valid should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return 'Ano inválido';
    }

    if (!hasDateExpired(month, year)) {
      return "Cartão expirado";
    }
    return null;
  }

  /// Convert the two-digit year to four-digit year if necessary
  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool hasDateExpired(int month, int year) {
    return !(month == null || year == null) && isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static List<int> getExpiryDate(String value) {
    var split = value.split(new RegExp(r'(\/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently is more than card's
    // year
    return fourDigitsYear < now.year;
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = new RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static CardType getCardType(String flag) {
    CardType cardType = CardType.values
        .firstWhere((e) => e.toString() == 'CardType.${flag.toUpperCase()}');
    return cardType;
  }

  static Widget getCardIcon(CardType cardType) {
    String img = "";
    Icon icon;
    switch (cardType) {
      case CardType.ELO:
        img = 'elo.png';
        break;
      case CardType.MASTER:
        img = 'mastercard.png';
        break;
      case CardType.VISA:
        img = 'visa.png';
        break;
      case CardType.VERVE:
        img = 'verve.png';
        break;
      case CardType.AMEX:
        img = 'amex.png';
        break;
      case CardType.DISCOVER:
        img = 'discover.png';
        break;
      case CardType.DINERS:
        img = 'dinners.png';
        break;
      case CardType.JCB:
        img = 'jcb.png';
        break;
      case CardType.OTHERS:
        icon = new Icon(Icons.credit_card, size: 30);
        break;
      case CardType.INVALID:
        icon = new Icon(
          Icons.warning,
          size: 30,
        );
        break;
    }
    Widget widget;
    if (img.isNotEmpty) {
      widget = Container(
        padding: EdgeInsets.only(right: 8),
        child: Image.asset(
          'assets/images/flags/$img',
          width: 50,
        ),
      );
    } else {
      widget = icon;
    }
    return widget;
  }

  /// With the card number with Luhn Algorithm
  /// https://en.wikipedia.org/wiki/Luhn_algorithm
  static String validateCardNum(String input) {
    if (input.isEmpty) {
      return 'Este campo é obrigatório';
    }

    input = getCleanedNumber(input);

    if (input.length < 8) {
      return 'Número inválido';
    }

    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(input[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return 'Número inválido';
  }

  static CardType getCardTypeFrmNumber(String input) {
    CardType cardType;
    if (input.startsWith(RegExp(
        '(40117[8-9]|431274|438935|451416|457393|45763[1-2]|506(699|7[0-6][0-9]|77[0-8])|509\\d{3}|504175|627780|636297|636368|65003[1-3]|6500(3[5-9]|4[0-9]|5[0-1])|6504(0[5-9]|[1-3][0-9])|650(4[8-9][0-9]|5[0-2][0-9]|53[0-8])|6505(4[1-9]|[5-8][0-9]|9[0-8])|6507(0[0-9]|1[0-8])|65072[0-7]|6509(0[1-9]|1[0-9]|20)|6516(5[2-9]|[6-7][0-9])|6550([0-1][0-9]|2[1-9]|[3-4][0-9]|5[0-8]))'))) {
      cardType = CardType.ELO;
    } else if (input.startsWith(new RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      cardType = CardType.MASTER;
    } else if (input.startsWith(new RegExp(r'[4]'))) {
      cardType = CardType.VISA;
    } else if (input
        .startsWith(new RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
      cardType = CardType.VERVE;
    } else if (input.startsWith(new RegExp(r'((34)|(37))'))) {
      cardType = CardType.AMEX;
    } else if (input.startsWith(new RegExp(r'((6[45])|(6011))'))) {
      cardType = CardType.DISCOVER;
    } else if (input
        .startsWith(new RegExp(r'((30[0-5])|(3[89])|(36)|(3095))'))) {
      cardType = CardType.DINERS;
    } else if (input.startsWith(new RegExp(r'(352[89]|35[3-8][0-9])'))) {
      cardType = CardType.JCB;
    } else if (input.length <= 8) {
      cardType = CardType.OTHERS;
    } else {
      cardType = CardType.INVALID;
    }
    return cardType;
  }
}
