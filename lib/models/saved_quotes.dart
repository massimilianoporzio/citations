class SavedQuote {
  final int id;
  final String autore;
  final String citazione;

  SavedQuote({required this.id, required this.autore, required this.citazione});

  factory SavedQuote.fromRecord(Map<String, dynamic> data) {
    final id = data["id"];
    final autore = data["author"];
    final citazione = data["citation"];
    return SavedQuote(id: id, autore: autore, citazione: citazione);
  }
}
