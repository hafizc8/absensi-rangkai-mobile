class MessageCode {
  String getMessage(String? code) {
    switch (code) {
      case "USER_NOT_FOUND":
        return "User tidak terdaftar.";

      case "WRONG_PASSWORD":
        return "Password salah.";

      default:
        return "Terjadi kesalahan internal server.";
    }
  }
}