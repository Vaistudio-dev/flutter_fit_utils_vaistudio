/// Valide une addresse email.
bool validateEmail(String? input) => RegExp(r"^[a-zA-Z\d.a-zA-Z!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+").hasMatch(input ??= "");

/// Valide qu'un champ n'est pas vide.
bool validateNotEmpty(String? input) {
  input = input?.trim();
  return input != null && input.isNotEmpty;
}

/// Valide qu'un nombre est positif.
bool validatePositiveNumber({String? input, bool zeroAccepted = false, bool acceptDecimal = true, bool acceptNull = false}) {
  input ??= "";
  double? number = double.tryParse(input);
  if (!acceptNull && number == null) return false;
  number ??= 0;

  if (!zeroAccepted && number == 0) return false;
  if (!acceptDecimal && input.contains(".")) return false;
  return number >= 0;
}