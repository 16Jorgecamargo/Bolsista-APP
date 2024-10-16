import 'package:mobx/mobx.dart'; // Biblioteca para gerenciamento de estado reativo (MobX)
import 'package:http/http.dart' as http; // Biblioteca para fazer requisições HTTP
import 'dart:convert'; // Biblioteca para conversão de JSON
import '../models/bolsista_model.dart'; // Importa o modelo de Bolsista

part 'bolsista_store.g.dart'; // Necessário para a geração do código MobX

// Define a classe BolsistaStore que estende o comportamento de _BolsistaStoreBase com código gerado
class BolsistaStore = _BolsistaStoreBase with _$BolsistaStore;

// Classe base que contém os observáveis e as ações do MobX
abstract class _BolsistaStoreBase with Store {
  
  @observable
  ObservableList<Bolsista> bolsistas = ObservableList<Bolsista>(); 
  // Lista observável que armazena os bolsistas

  @observable
  bool isLoading = false; 
  // Indica se os dados estão sendo carregados

  @observable
  String? errorMessage; 
  // Armazena possíveis mensagens de erro

  @action
  Future<void> fetchBolsistas() async {
    isLoading = true; 
    // Define isLoading como verdadeiro para indicar que o carregamento começou
    
    errorMessage = null; 
    // Limpa possíveis mensagens de erro anteriores

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/bolsista'));
      //! computador => final response = await http.get(Uri.parse('http://localhost:51932//bolsista')); 
      // Faz uma requisição GET para buscar a lista de bolsistas do servidor

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body); 
        // Decodifica o corpo da resposta em uma lista de dados dinâmicos (JSON)
        
        final List<Bolsista> fetchedBolsistas = 
            data.map((json) => Bolsista.fromJson(json)).toList(); 
        // Converte os dados JSON em uma lista de objetos Bolsista
        
        bolsistas.clear(); 
        // Limpa a lista atual de bolsistas

        bolsistas.addAll(fetchedBolsistas); 
        // Adiciona os bolsistas buscados à lista observável
      } else {
        errorMessage = 'Erro ao buscar bolsistas: ${response.statusCode}'; 
        // Define a mensagem de erro se o status da resposta não for 200
      }
    } catch (e) {
      errorMessage = 'Erro ao buscar bolsistas: $e'; 
      // Captura e define a mensagem de erro se ocorrer uma exceção
    } finally {
      isLoading = false; 
      // Define isLoading como falso para indicar que o carregamento terminou
    }
  }

  @action
  void atualizarBolsista(Bolsista bolsistaAtualizado) {
    final index = bolsistas.indexWhere((b) => b.id == bolsistaAtualizado.id); 
    // Encontra o índice do bolsista que será atualizado na lista observável

    if (index != -1) {
      bolsistas[index] = bolsistaAtualizado; 
      // Atualiza o bolsista na lista se ele for encontrado
    }
  }
}
