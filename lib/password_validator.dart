import 'package:flutter_fit_utils/model/model.dart';
import 'package:flutter_fit_utils/model/modelable.dart';
import 'package:flutter_fit_utils_ui/fit_rule_validator/validator.dart';
import 'package:flutter_fit_utils_vaistudio/extensions/index.dart';

import 'config/ui_config.dart';

/// Caractéristique requises d'un mot de passe.
class PasswordValidator extends Modelable with RuleValidator {
  static const String _minCharKey = "min_char";
  static const String _maxCharKey = "max_char";
  static const String _needCapitalKey = "need_capital";
  static const String _needNumberKey = "need_number";
  static const String _needSpecialCharKey = "need_special_char";

  /// Caractère minimum.
  final int minChar;
  /// Caractère maximum.
  final int maxChar;

  /// Lettre majuscule requise.
  final bool needCapital;
  /// Nombre requis.
  final bool needNumber;
  /// Caractère spéciale requis.
  final bool needSpecialChar;

  final String currentPassword;

  /// Caractéristique requises d'un mot de passe.
  PasswordValidator({this.minChar = 0, this.maxChar = 0, this.needCapital = false, this.needNumber = false, this.needSpecialChar = false, this.currentPassword = "", super.id, super.userId, super.invalid});

  /// Créé une instance depuis un [Model].
  PasswordValidator.fromModel(super.model) :
    minChar = int.parse(model.data[_minCharKey].toString()),
    maxChar = int.parse(model.data[_maxCharKey].toString()),
    needCapital = model.data[_needCapitalKey].toString().parseBool(),
    needNumber = model.data[_needNumberKey].toString().parseBool(),
    needSpecialChar = model.data[_needSpecialCharKey].toString().parseBool(),
    currentPassword = "",
    super.fromModel();

  @override
  Modelable copyWith({String? id, String? userId, bool? invalid = false, int? minChar, int? maxChar, bool? needCapital, bool? needNumber, bool? needSpecialChar, String? currentPassword}) => PasswordValidator(
    minChar: minChar ?? this.minChar,
    maxChar: maxChar ?? this.maxChar,
    needCapital: needCapital ?? this.needCapital,
    needNumber: needNumber ?? this.needNumber,
    needSpecialChar: needSpecialChar ?? this.needSpecialChar,
    currentPassword: currentPassword ?? this.currentPassword,
  );

  @override
  Model toModel() => Model(
    id: id,
    userId: userId,
    data: {
      _minCharKey: minChar,
      _maxCharKey: maxChar,
      _needCapitalKey: needCapital,
      _needNumberKey: needNumber,
      _needSpecialCharKey: needSpecialChar,
    },
  );

  @override
  Map<String, bool> validate() => {
    getString("passwordRange", placeholders: {"MIN_CHAR": minChar.toString(), "MAX_CHAR": maxChar.toString()}): currentPassword.length >= minChar && currentPassword.length <= maxChar,
    if (needCapital)
      getString("passwordCapital"): currentPassword.containsCapitalLetter(),
    if (needNumber)
      getString("passwordNumber"): currentPassword.containsNumber(),
    if (needSpecialChar)
      getString("passwordSpecialChar"): currentPassword.containsSpecialChar(),
  };
}