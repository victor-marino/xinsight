String sanitizeToken(String token) {
  // Removes whitespaces and linebreaks
  String sanitizedToken = token.trim().replaceAll("\n", "").replaceAll(" ", "");
  return sanitizedToken;
}

bool validateTokenFormat(String token) {
  // RegEx to check if the token format is valid
  RegExp tokenFormat = RegExp(r'^[\w-]+\.[\w-]+\.[\w-]+$');
  if (tokenFormat.hasMatch(token)) {
    return true;
  } else {
    return false;
  }
}
