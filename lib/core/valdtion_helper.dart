
class ValidationHelper {
  static final ValidationHelper _validationHelper =
      ValidationHelper._internal();

  ValidationHelper._internal();

  factory ValidationHelper() {
    return _validationHelper;
  }

  String? validatePassword(String value) {
     return null;
    if (value.trim().isEmpty) {
      return "هذه الخانة مطلوبه! ";
    } else if (value.trim().length < 4) {
      return "يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.";
    } else {
      return null;
    }
  }

  String? validatePhone(String value) {
    if (value.trim().isEmpty) {
      return "هذه الخانة مطلوبه! ";
    } else if (value.trim().length < 8) {
      return "يجب أن يتكون الهاتف من 8 ارقام على الأقل.";
    } else {
      return null;
    }
  }

  String? validateConfrmationPassword(String value, String confirmValue) {
    if (value.trim().isEmpty) {
      return "هذه الخانة مطلوبه! ";
    } else if (value.trim() != confirmValue) {
      return "كلمة المرور غير متطابقة";
    } else {
      return null;
    }
  }

  validateField(String value) {
    if (value.trim().isEmpty) {
      return "هذه الخانة مطلوبه! ";
    } else {
      return null;
    }
  }

  // String? validateWebsite(String value) {
  //   bool _validURL = Uri.parse(value).isAbsolute;
  //   if (!_validURL) {
  //     return "الرابط غير صالح";
  //   } else
  //     return null;
  // }

  String? validateEmail(String value) {
    if (value.isNotEmpty) {
      final RegExp regex = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!regex.hasMatch(value)) {
        return " عنوان بريد إلكتروني غير صالح!";
      } else {
        return null;
      }
    } else {
      return "هذه الخانة مطلوبه! ";
    }
  }
}
