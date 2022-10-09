// ignore_for_file: avoid_classes_with_only_static_members

class Validator {
  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    final RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",);

    if (email.isEmpty) {
      return "Email is required";
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Invalid email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return "Password is required";
    } else if (password.length < 6) {
      return 'Enter a password with length at least 8';
    }

    return null;
  }
}
