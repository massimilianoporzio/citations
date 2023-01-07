import 'package:auto_size_text/auto_size_text.dart';
import 'package:citations/models/quotes.dart';
import 'package:citations/models/saved_quotes.dart';
import 'package:citations/models/saved_quotes_list.dart';
import 'package:citations/repository/quotes_repository.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Quote> mainQuoteFuture;
  final SavedQuoteList citazioniSalvate = SavedQuoteList();

  @override
  void initState() {
    super.initState();
    mainQuoteFuture = Quotesrepository.get();
    //*LEGGE DA DB E METTE NELLA LISTA DI SAVEDQUOTE
    citazioniSalvate.initialize().then((_) {
      setState(() {
        //*vuoto mi serve solo a rigenerare l'albero
      });
    });
  }

  void createQuote(Quote quote) {
    if (!citazioniSalvate.contains(quote.citazione)) {
      citazioniSalvate.create(quote.autore, quote.citazione).then(
        (_) {
          setState(() {});
        },
      );
    }
  }

  void deleteQuote(SavedQuote quoteToDel) {
    citazioniSalvate.delete(quoteToDel).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          sezioneCitazionePrincipale(),
          sezioneListaSalvate(),
        ],
      ),
    );
  }

  Widget sezioneCitazionePrincipale() {
    return SliverToBoxAdapter(
      //*serve perché Container non è uno sliver
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<Quote>(
            future: mainQuoteFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: AutoSizeText(
                            '"${snapshot.data!.citazione}"',
                            maxLines: 7,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          snapshot.data!.autore,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.end,
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: ricaricaCitazione,
                            icon: Icon(
                              Icons.replay,
                              size: 40,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          IconButton(
                              onPressed: () => createQuote(snapshot.data!),
                              icon: Icon(
                                citazioniSalvate
                                        .contains(snapshot.data!.citazione)
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                size: 40,
                                color: citazioniSalvate
                                        .contains(snapshot.data!.citazione)
                                    ? Colors.red
                                    : Colors.red.shade300,
                              ))
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  Widget sezioneListaSalvate() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => GestureDetector(
                onDoubleTap: () => deleteQuote(citazioniSalvate.quotes[index]),
                child: Container(
                  color: colors[index % colors.length],
                  height: 175,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: AutoSizeText(
                          textAlign: TextAlign.left,
                          maxLines: 4,
                          citazioniSalvate.quotes[index].citazione,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        citazioniSalvate.quotes[index].autore,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.end,
                      )
                    ],
                  ),
                ),
              ),
          childCount: citazioniSalvate.quotes.length),
    );
  }

  final colors = const [
    Color(0xFF66ffbe),
    Color(0xFFfff267),
    Color(0xFFffb968),
    Color(0xFF80e0ff),
    Color(0xFF9980ff),
    Color(0xFFd680ff),
    Color(0xFFff7fb5),
  ];

  void ricaricaCitazione() {
    setState(() {
      mainQuoteFuture = Quotesrepository.get();
    });
  }
}
