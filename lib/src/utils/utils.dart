/// Basic sprintf implementation. It replaces inside [input],
/// the placeholder '<>' with the [value] provided.
String format(String input, dynamic value) {
  return input.replaceAll("<>", value.toString());
}
