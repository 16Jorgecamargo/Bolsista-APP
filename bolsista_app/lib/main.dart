import 'package:flutter/material.dart'; // Importa o pacote Flutter para a construção de interfaces gráficas.
import 'package:provider/provider.dart'; // Importa o pacote Provider para gerenciamento de estado.
import 'pages/bolsista_list_page.dart'; // Importa a página que lista os bolsistas.
import 'stores/bolsista_store.dart'; // Importa o store (modelo de gerenciamento de estado) dos bolsistas.

void main() {
  runApp(const MyApp()); // Função principal que executa o aplicativo MyApp.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Construtor da classe MyApp com a chave.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Define o Provider para o BolsistaStore. Ele será acessível em toda a árvore de widgets.
        Provider<BolsistaStore>(
          create: (_) => BolsistaStore(), // Cria uma instância do BolsistaStore.
        ),
      ],
      child: MaterialApp(
        title: 'Gerenciamento de Bolsistas', // Define o título do aplicativo.
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue, // Define o tema principal do app, usando a cor azul.
        ),
        home: const BolsistaListPage(), // Define a página inicial como a lista de bolsistas.
      ),
    );
  }
}
