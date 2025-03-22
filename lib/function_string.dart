import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'env.dart';

Map<String, dynamic>? strToMap(dynamic data) {
  if (data == null) return null;
  if (data is String) return jsonDecode(data);
  return data;
}

String removeAsAndAfter(String input) {
  // Find the index of ' as ' in the input string
  int index = input.indexOf(' as ');

  // If ' as ' is found, return the substring before it
  // Otherwise, return the original input string
  return index != -1 ? input.substring(0, index) : input;
}

String? makeStr(d) =>
    (d == null)
        ? null
        : (d == 'null')
        ? null
        : d.toString();
int? makeInt(dynamic d) {
  if (d == null) return null;
  if (d is int) return d;
  if (d is double) return d.toInt();
  return int.tryParse(d.toString());
}

double? makeDouble(d) => (double.tryParse(d.toString()));
double? makeDouble2(d) => double.tryParse(d.toString().replaceAll(',', '.').replaceAll('.', '')) ?? 0;
bool? makeBool(d) => ((d is bool) ? d : bool.tryParse(d.toString()) ?? false);
bool isNumeric(String s) {
  if (s.isEmpty) {
    return false;
  }
  return num.tryParse(s) != null;
}

imagetoThumbs(s) {
  return 'thumbs/$s';
}

dp(String? s /* , {StackTrace? stackTrace} */) {
  //debugPrintStack(label: s /* , stackTrace: stackTrace */);
  if (kDebugMode) debugPrint(s /* , stackTrace: stackTrace */);
}

setProses([String? s]) {
  dp(s);
  s ??= prosestxt;
  dp(s);
}

final CurrencyTextInputFormatter uangformatter = CurrencyTextInputFormatter.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
final CurrencyTextInputFormatter angkaformatter = CurrencyTextInputFormatter.currency(locale: 'id', decimalDigits: 0, symbol: "");
formatangka(a) {
  double value = double.tryParse(a.toString().replaceAll(",", "")) ?? 0;
  return NumberFormat("#,##0.#", "id_ID").format(value);
}

formatuang(a) => uangformatter.formatDouble(double.tryParse(a.toString().replaceAll(",", "")) ?? 0);

String addWhere(String baseSql, String? whereCondition) {
  if (baseSql.isEmpty) {
    throw ArgumentError('Base SQL query cannot be empty');
  }

  String dynamicQuery = baseSql.trim();
  bool hasWhereClause = dynamicQuery.toUpperCase().contains('WHERE');
  if (whereCondition != null && whereCondition.isNotEmpty) {
    if (hasWhereClause) {
      dp('edit');
      dynamicQuery = dynamicQuery.replaceFirst('where', 'WHERE');
      dynamicQuery = dynamicQuery.replaceFirst('WHERE', 'WHERE $whereCondition AND');
    } else {
      dp('baru');
      dynamicQuery += ' WHERE $whereCondition';
    }
  } else {
    dp('kosong');
  }
  return dynamicQuery;
}

String createWhere(String source, List<String> fields) {
  if (source.isEmpty || fields.isEmpty) {
    return ''; // Handle case where input is empty
  }

  // Split the source string into individual words and sanitize each word
  List<String> words =
      source
          .toLowerCase()
          .split(' ')
          .map((word) => word.trim()) // Remove extra spaces
          .where((word) => word.isNotEmpty) // Filter out empty words
          .toList();

  // Create a list to hold all groups of conditions
  List<String> groups = [];

  // For each word, create a group of conditions
  for (var word in words) {
    // Escape special characters for SQL LIKE
    String sanitizedWord = word.replaceAll("'", "''"); // Escape single quotes for SQL

    // Create conditions for each field
    var wordConditions = fields.map((field) => "LOWER($field) LIKE '%$sanitizedWord%'").toList();

    // Join conditions for the current word with OR
    groups.add('(${wordConditions.join(' OR ')})');
  }

  // Join the groups with AND
  return groups.isNotEmpty ? "(${groups.join(' AND ')})" : '';
}

String createWhereold(String source, List<String> fields) {
  // Split the source string into individual words
  List<String> words = source.toLowerCase().split(' ');

  // Create a list to hold all groups of conditions
  List<String> groups = [];

  // For each word, create a group of conditions
  for (var word in words) {
    var wordConditions = fields.map((field) => "LOWER($field) LIKE '%$word%'").toList();
    // Join conditions for the current word with OR
    groups.add('(${wordConditions.join(' OR ')})');
  }

  // Join the groups with AND
  return "(${groups.join(' AND ')})";
}

String formattanggal(String? tgl, [String format = "dd/MM/yy"]) {
  /// EEEE, MMMM d, yyyy
  if (tgl == null) return '-';
  try {
    final tanggal = DateTime.tryParse(tgl) ?? DateTime.now();
    return DateFormat(format, 'id_ID').format(tanggal);
  } catch (e) {
    dp("formattanggal(e): $e");
    return "-";
  }
}

String namaBulan(int? bln) {
  if (bln == null) return '';
  switch (bln) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'Mei';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Agu';
    case 9:
      return 'Sep';
    case 10:
      return 'Okt';
    case 11:
      return 'Nov';
    case 12:
      return 'Des';

    default:
      return '';
  }
}

String? generateInsertQuery(String table, List<String> fields, List<Map<String, dynamic>> values) {
  if (fields.isEmpty || values.isEmpty || table.isEmpty) {
    return null;
  }

  // Membuat string kolom
  String columns = fields.join(', ');

  // Membuat string nilai untuk setiap baris
  List<String> valueStrings =
      values.map((valueMap) {
        List<String> valueList =
            fields.map((field) {
              var value = valueMap[field];
              if (value is String) {
                return "'$value'";
              }
              return value.toString();
            }).toList();
        return "(${valueList.join(', ')})";
      }).toList();

  // Menggabungkan semua nilai menjadi satu string
  String valuesString = valueStrings.join(', ');

  // Membuat query lengkap
  return "INSERT INTO $table ($columns) VALUES $valuesString;";
}

String convertParamsToString(String sql, List<dynamic> params) {
  for (var param in params) {
    sql = sql.replaceFirst('?', param?.toString() ?? 'NULL');
  }
  return sql;
}

String extractColumnName(String input) {
  // Split the input string by " as "
  List<String> parts = input.split(' ');

  // Return the first part, which is the column name
  return parts[0];
}
