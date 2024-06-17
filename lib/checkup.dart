import 'package:flutter_fit_utils/flutter_fit_utils.dart';

/// Represents a verification date.
/// Each index works separatly.
/// 
/// E.g: If we update [day], we don't have to update [week], it will be updated
/// on the next weekly checkup.
class Checkup extends Modelable {
  static const String _dayKey = "day";
  static const String _weekKey = "week";
  static const String _monthKey = "month";
  static const String _yearKey = "year";

  /// Index of the last daily checkup.
  final int day;

  /// Index of the last weekly checkup.
  final int week;

  /// Index of the last monthly checkup.
  final int month;

  /// Index of the last yearly checkup.
  final int year;

  /// Creates a new [Checkup].
  const Checkup({this.day = 0, this.week = 0, this.month = 0, this.year = 0});

  /// Creates a new [Checkup] from a [Model].
  Checkup.fromModel(Model model) :
    day = model.data[_dayKey].toInt() as int,
    week = model.data[_weekKey].toInt() as int,
    month = model.data[_monthKey].toInt() as int,
    year = model.data[_yearKey].toInt() as int;

  @override
  Checkup copyWith({String? id, String? userId, bool? invalid, int? day, int? week, int? month, int? year}) => Checkup(
    day: day ?? this.day,
    week: week ?? this.week,
    month: month ?? this.month,
    year: year ?? this.year,
  );

  @override
  Model toModel() => Model(
    id: "",
    data: {
      _dayKey: day,
      _weekKey: week,
      _monthKey: month,
      _yearKey: year,
    },
  );
}