import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';

import 'package:sqflite/sqflite.dart';

import 'package:citations/models/saved_quotes.dart';

class SavedQuoteRepository {
  late Database database;

  Future<void> initalize() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = path.join(databasesPath, 'citazioni.db');

    // Delete any existing database:
    await deleteDatabase(dbPath);

    // Create the writable database file from the bundled demo database file:
    ByteData data = await rootBundle.load("assets/saved_citations.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    database = await openDatabase(dbPath);
  }

  Future<SavedQuote> create(String autore, String citazione) async {
    final id = await database
        .insert("saved_citations", {"author": autore, "citation": citazione});
    return SavedQuote(id: id, autore: autore, citazione: citazione);
  }

  Future<void> delete(SavedQuote quoteToDelete) async {
    await database.delete(
      "saved_citations",
      where: "id = ?",
      whereArgs: [quoteToDelete.id],
    );
  }

  //RESTITUISCE TUTTI I RECORD
  Future<List<SavedQuote>> all() async {
    final records = await database.query("saved_citations");
    //*MAPPO
    return records.map((record) => SavedQuote.fromRecord(record)).toList();
  }
}
