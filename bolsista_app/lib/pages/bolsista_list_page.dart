import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces de usuário.
import 'package:flutter_mobx/flutter_mobx.dart'; // Importa o pacote MobX para gerenciamento de estado reativo.
import '../stores/bolsista_store.dart'; // Importa o arquivo do store que gerencia o estado dos bolsistas.
import 'bolsista_detail_page.dart'; // Importa a página de detalhes de um bolsista.
import 'bolsista_form_page.dart'; // Importa a página do formulário para adicionar ou editar um bolsista.
import 'timer_page.dart'; // Importa a página do cronômetro para o bolsista.

class BolsistaListPage extends StatefulWidget { 
  const BolsistaListPage({super.key}); // Define a chave do widget Stateful.

  @override
  _BolsistaListPageState createState() => _BolsistaListPageState(); // Cria o estado para o widget.
}

class _BolsistaListPageState extends State<BolsistaListPage> {
  final BolsistaStore bolsistaStore = BolsistaStore(); // Cria uma instância do BolsistaStore.

  @override
  void initState() {
    super.initState(); // Inicializa o estado.
    bolsistaStore.fetchBolsistas(); // Chama o método para buscar a lista de bolsistas do store ao iniciar a tela.
  }

  // Função para capitalizar a primeira letra de uma palavra.
  String capitalize(String palavra) {
    if (palavra.isEmpty) return palavra; // Verifica se a palavra está vazia.
    return palavra[0].toUpperCase() + palavra.substring(1).toLowerCase(); // Capitaliza a primeira letra e transforma o resto em minúsculas.
  }

  // Função para formatar o nome completo do bolsista (capitaliza o primeiro e o último nome).
  String formatarNome(String nomeCompleto) {
    final nomes = nomeCompleto.split(' '); // Divide o nome completo por espaços.
    if (nomes.length > 1) {
      final primeiroNome = capitalize(nomes.first); // Capitaliza o primeiro nome.
      final ultimoNome = capitalize(nomes.last); // Capitaliza o último nome.
      return '$primeiroNome $ultimoNome'; // Retorna o nome formatado.
    } else {
      return capitalize(nomeCompleto); // Se houver apenas um nome, capitaliza ele.
    }
  }

  // Função que navega para a página de detalhes do bolsista.
  Future<void> _navegarParaDetalhes(BuildContext context, int index) async {
    final bolsista = bolsistaStore.bolsistas[index]; // Obtém o bolsista pelo índice.
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BolsistaDetailPage(
          bolsista: bolsista,
          bolsistaStore: bolsistaStore, // Passa o bolsista e o store para a página de detalhes.
        ),
      ),
    );
    if (resultado == true) {
      await bolsistaStore.fetchBolsistas(); // Se a página de detalhes retornar 'true', atualiza a lista de bolsistas.
    }
  }

  // Função que navega para a página do cronômetro.
  Future<void> _navegarParaCronometro(BuildContext context, int index) async {
    final bolsista = bolsistaStore.bolsistas[index]; // Obtém o bolsista pelo índice.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerPage(bolsista: bolsista), // Navega para a página do cronômetro, passando o bolsista.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width; // Obtém a largura da tela.

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Coluna contendo o título e o subtítulo da AppBar.
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rede Campo', // Título principal da AppBar.
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Se o texto for muito longo, será cortado com reticências.
                ),
                Text(
                  'Lista de Bolsistas', // Subtítulo da AppBar.
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const Spacer(), // O Spacer empurra a imagem para o lado direito da AppBar.
            // Exibe a imagem do logo na AppBar.
            Image.asset(
              'assets/images/logo_rede_campo.png', // Caminho para a imagem da logo.
              width: 80, // Largura da imagem.
              height: 60, // Altura da imagem.
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Expande o ListView para ocupar o espaço disponível acima do botão.
          Expanded(
            child: Observer(
              builder: (_) {
                if (bolsistaStore.isLoading) {
                  return const Center(child: CircularProgressIndicator()); // Mostra o indicador de carregamento se estiver carregando.
                }
                if (bolsistaStore.errorMessage != null) {
                  return Center(child: Text(bolsistaStore.errorMessage!)); // Mostra a mensagem de erro, se houver.
                }
                // Constroi a lista de bolsistas usando ListView.builder.
                return ListView.builder(
                  itemCount: bolsistaStore.bolsistas.length, // Define a quantidade de itens na lista.
                  itemBuilder: (context, index) {
                    final bolsista = bolsistaStore.bolsistas[index]; // Obtém o bolsista pelo índice.
                    return ListTile(
                      title: Text(
                        formatarNome(bolsista.nomeCompleto), // Exibe o nome formatado do bolsista.
                        style: const TextStyle(
                          fontFamily: 'Poppins', // Define a fonte.
                          fontWeight: FontWeight.w300, // Define a espessura da fonte.
                          fontSize: 20, // Define o tamanho da fonte.
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botão que navega para a página do cronômetro.
                          IconButton(
                            icon: const Icon(Icons.timer),
                            onPressed: () {
                              _navegarParaCronometro(context, index); // Chama a função que navega para o cronômetro.
                            },
                          ),
                          // Botão que navega para a página de detalhes.
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye),
                            onPressed: () {
                              _navegarParaDetalhes(context, index); // Chama a função que navega para a página de detalhes.
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Botão flutuante "Adicionar Bolsista".
          Padding(
            padding: const EdgeInsets.all(8.0), // Define o padding ao redor do botão.
            child: SizedBox(
              width: screenWidth * 0.8, // Define a largura do botão como 80% da tela.
              height: 50, // Define a altura do botão.
              child: ElevatedButton(
                onPressed: () async {
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BolsistaFormPage(), // Navega para a página de formulário de bolsistas.
                    ),
                  );
                  if (resultado == true) {
                    await bolsistaStore.fetchBolsistas(); // Se um bolsista for adicionado, atualiza a lista.
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10), // Define o padding vertical dentro do botão.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Define bordas arredondadas para o botão.
                  ),
                ),
                child: const Text(
                  'Adicionar Bolsista', // Texto do botão.
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
