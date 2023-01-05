import 'package:citations/models/saved_quotes.dart';
import 'package:citations/repository/saved_quotes_repository.dart';
import 'package:get_it/get_it.dart';

class SavedQuoteList {
  List<SavedQuote> quotes = [];

  Future<void> initialize() async {
    //collego al db, faccio select e metto in quotes
    var db = GetIt.I.get<SavedQuoteRepository>();
    quotes = await db.all();
  }

  Future<void> create(String autore, String citazione) async {
    final quote =
        await GetIt.I.get<SavedQuoteRepository>().create(autore, citazione);
    quotes.insert(0, quote); //LA INSERISCO IN CIMA
  }

  Future<void> delete(SavedQuote quoteToDelete) async {
    await GetIt.I.get<SavedQuoteRepository>().delete(quoteToDelete);
    quotes.removeWhere((element) => element.id == quoteToDelete.id);
  }
}
