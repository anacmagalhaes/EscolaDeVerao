class StringUtils {
  static String formatUserName(String fullName) {
    List<String> nameParts = fullName.split(' '); // Divide o nome em partes
    String firstName = nameParts.first; // Pega apenas o primeiro nome

    if (firstName.length > 30) {
      return '${firstName.substring(0, 30)}...'; // Limita a 30 caracteres e adiciona "..."
    }

    return firstName;
  }

  static String formatEventTitle(String title) {
    const int maxLength = 60; // defina o limite desejado
    if (title.length > maxLength) {
      return '${title.substring(0, maxLength)}...';
    }
    return title;
  }
}
