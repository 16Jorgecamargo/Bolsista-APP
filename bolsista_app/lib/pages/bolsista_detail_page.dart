import 'package:bolsista_app/pages/bolsista%20_edit_page.dart'; // Importa a página de edição do bolsista
import 'package:flutter/material.dart'; // Importa os widgets e funções principais do Flutter
import 'package:http/http.dart' as http; // Importa a biblioteca HTTP para requisições web
import 'package:url_launcher/url_launcher.dart'; // Biblioteca para abrir URLs no navegador ou apps externos
import 'package:intl/intl.dart'; // Biblioteca para formatação de datas
import '../models/bolsista_model.dart'; // Importa o modelo de dados do bolsista
import '../stores/bolsista_store.dart'; // Importa a store MobX para gerenciamento de estado

class BolsistaDetailPage extends StatelessWidget {
  final Bolsista bolsista; // Objeto bolsista com os dados que serão exibidos
  final BolsistaStore bolsistaStore; // Store para gerenciamento de estado do bolsista

  const BolsistaDetailPage({super.key, required this.bolsista, required this.bolsistaStore});

  // Função para deletar o bolsista
  Future<void> deletarBolsista(BuildContext context) async {
    final Uri url = Uri.parse('http://10.0.2.2:3000/bolsista/${bolsista.id}'); // URL para deletar o bolsista

    try {
      final response = await http.delete(url); // Requisição DELETE para remover o bolsista

      if (response.statusCode == 200) {
        // Se o bolsista for deletado com sucesso
        Navigator.of(context).pop(true); // Fecha a página atual e retorna à anterior
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bolsista deletado com sucesso')), // Exibe uma notificação de sucesso
        );
      } else {
        // Se ocorrer algum erro ao deletar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao deletar o bolsista')), // Exibe um erro
        );
      }
    } catch (e) {
      // Se houver uma exceção de rede
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão ao tentar deletar')), // Exibe um erro de conexão
      );
    }
  }

  // Função que exibe um diálogo de confirmação para deletar o bolsista
  Future<void> _mostrarDialogoConfirmacao(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // O usuário não pode fechar o diálogo clicando fora dele
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'), // Título do diálogo
          content: const Text('Tem certeza que deseja apagar este bolsista?'), // Conteúdo de confirmação
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo sem deletar
              },
            ),
            TextButton(
              child: const Text('Apagar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                deletarBolsista(context); // Executa a função de deletar o bolsista
              },
            ),
          ],
        );
      },
    );
  }

  // Função para abrir o comprovante de matrícula
  Future<void> abrirComprovante(BuildContext context, String filename) async {
    final Uri url = Uri.parse('http://10.0.2.2:3000/comprovante/$filename'); // URL para acessar o comprovante

    try {
      final response = await http.head(url); // Requisição HEAD para verificar se o comprovante existe

      if (response.statusCode == 200) {
        // Se o comprovante existir
        if (await canLaunchUrl(url)) {
          // Verifica se pode abrir o URL
          await launchUrl(url, mode: LaunchMode.externalApplication); // Abre o comprovante em um app externo
        } else {
          _showComprovanteNaoEncontradoDialog(context); // Exibe uma mensagem caso não seja possível abrir o comprovante
        }
      } else {
        _showComprovanteNaoEncontradoDialog(context); // Caso o comprovante não seja encontrado
      }
    } catch (e) {
      // Se houver uma exceção durante o acesso
      _showComprovanteNaoEncontradoDialog(context); // Exibe uma mensagem de erro
    }
  }

  // Função que exibe um alerta quando o comprovante não é encontrado
  void _showComprovanteNaoEncontradoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'), // Título do alerta
          content: const Text('Comprovante não encontrado.'), // Mensagem de erro
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Formata a data de nascimento no padrão brasileiro (dd/MM/yyyy)
    final String dataFormatada = DateFormat('dd/MM/yyyy').format(bolsista.dataNascimento);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Bolsista'), // Título da AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaçamento interno
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha os itens à esquerda
          children: [
            Text(
              bolsista.nomeCompleto.toUpperCase(), // Exibe o nome do bolsista em maiúsculas
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black), // Estilo do nome
            ),
            const SizedBox(height: 8), // Espaçamento

            const Text(
              'DATA DE NASCIMENTO',
              style: TextStyle(fontSize: 12, color: Colors.grey), // Texto do rótulo
            ),
            Text(
              dataFormatada, // Exibe a data formatada
              style: const TextStyle(fontSize: 18, color: Colors.black), // Estilo da data
            ),
            const SizedBox(height: 8), // Espaçamento

            const Text(
              'CURSO',
              style: TextStyle(fontSize: 12, color: Colors.grey), // Texto do rótulo do curso
            ),
            Text(
              bolsista.curso, // Exibe o nome do curso do bolsista
              style: const TextStyle(fontSize: 18, color: Colors.black), // Estilo do curso
            ),
            const SizedBox(height: 30), // Espaçamento maior

            // Botão para visualizar o comprovante de matrícula
            SizedBox(
              width: double.infinity, // O botão ocupa toda a largura disponível
              child: ElevatedButton(
                onPressed: () {
                  abrirComprovante(context, bolsista.cMatricula); // Abre o comprovante quando pressionado
                },
                child: const Text('Comprovante de Matrícula'), // Texto do botão
              ),
            ),

            const Spacer(), // Preenche o espaço restante entre os elementos

            // Botões para editar ou apagar o bolsista
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Navega até a página de edição e aguarda o resultado
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BolsistaEditPage(
                            bolsista: bolsista, // Passa os dados do bolsista
                            bolsistaStore: bolsistaStore, // Passa a store para gerenciamento de estado
                          ),
                        ),
                      );

                      if (resultado == true) {
                        // Se o usuário salvar as alterações
                        bolsistaStore.fetchBolsistas(); // Atualiza a lista de bolsistas
                        Navigator.of(context).pop(true); // Volta para a página anterior
                      }
                    },
                    icon: const Icon(Icons.edit, color: Colors.white), // Ícone do botão de edição
                    label: const Text('Editar', style: TextStyle(color: Colors.white)), // Texto do botão
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Cor de fundo do botão
                      padding: const EdgeInsets.symmetric(vertical: 16), // Padding interno do botão
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Espaçamento entre os botões
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _mostrarDialogoConfirmacao(context); // Exibe o diálogo de confirmação para deletar
                    },
                    icon: const Icon(Icons.delete, color: Colors.white), // Ícone do botão de deletar
                    label: const Text('Apagar', style: TextStyle(color: Colors.white)), // Texto do botão
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Cor de fundo do botão
                      padding: const EdgeInsets.symmetric(vertical: 16), // Padding interno do botão
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
