/// This function checks if a string is numeric.
/// It returns true if the string is numeric, and false otherwise.
bool isNumeric(String? str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}
