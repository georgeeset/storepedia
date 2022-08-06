class Validator {
  String? validateString(String value) {
    if (value.length < 4) {
      return 'Data is too Short';
    }
    return null;
  }

  String? validateStringWithoutSpace(String value) {
    if (!RegExp(r"^[a-zA-Z0-9]+-[0-9]+-[0-9]").hasMatch(value)) {
      return 'Format: IK12-19-05';
    }
    if (value.contains(' ')) {
      return 'White space not allowed';
    }
    return null;
  }

  String? validatePassword(String val) {
    if (val.isEmpty) {
      return 'Password must not be empty';
    } else {
      if (val.length < 6) {
        return 'Your password is too short';
      }
      return null;
    }
  }

  String? validateEmail(String val) {
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)) {
      return 'Invalid email';
    }

    return null;
  }
}
