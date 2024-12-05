String formatPhoneNumber(String input) {
  // Retirer tout caractère non numérique
  String digits = input.replaceAll(RegExp(r'\D'), '');

  // Ajouter toujours '243' comme préfixe s'il n'est pas présent
  if (!digits.startsWith('243')) {
    digits = '243' + digits;
  }

  // Limiter la saisie aux 12 caractères (9 chiffres + 3 pour '243')
  if (digits.length > 12) {
    digits = digits.substring(0, 12);
  }

  // Formatage avec les traits
  StringBuffer formatted = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    formatted.write(digits[i]);
    // Ajouter un trait après 3, 6, et 9 chiffres
    if ((i == 2 || i == 5 || i == 8) && i != digits.length - 1) {
      formatted.write('-');
    }
  }

  return formatted.toString();
}

bool isValidPhone(String input) {
  // Retirer les traits et autres caractères non numériques
  String digits = input.replaceAll(RegExp(r'\D'), '');

  // Vérifier que la chaîne a exactement 12 chiffres et commence par '243'
  if (digits.length == 12 && digits.startsWith('243')) {
    return true;
  }

  // Retourner faux si les conditions ne sont pas remplies
  return false;
}

String extractPhoneNumber(String formattedInput) {
  // Retirer les traits pour récupérer uniquement les chiffres
  String digits = formattedInput.replaceAll(RegExp(r'\D'), '');

  // Vérifier que le numéro commence bien par '243' et contient au moins 12 caractères
  if (digits.startsWith('243') && digits.length >= 12) {
    return digits.substring(3); // Renvoyer uniquement les 9 derniers caractères
  }

  // Sinon, retourner une chaîne vide ou lever une erreur
  throw Exception("Numéro de téléphone invalide ou mal formaté");
}
