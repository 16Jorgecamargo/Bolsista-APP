import 'package:flutter/material.dart'; // Importa os componentes principais de UI do Flutter.
import 'package:flutter_mobx/flutter_mobx.dart'; // Importa o MobX, uma biblioteca de gerenciamento de estado reativo.
import '../stores/timer_store.dart'; // Importa o store (estado) que gerencia o cronômetro.
import '../models/bolsista_model.dart'; // Importa o modelo que representa um bolsista.

class TimerPage extends StatelessWidget {
  final Bolsista bolsista; // Declaração do bolsista que será passado para a página.
  final TimerStore timerStore = TimerStore(); // Instancia o TimerStore para gerenciar o estado do cronômetro.

  TimerPage({super.key, required this.bolsista}); // Construtor que requer o objeto bolsista ao criar a página.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Cria o botão de voltar (seta para esquerda).
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Ícone da seta para voltar.
          onPressed: () {
            Navigator.of(context).pop(); // Ao pressionar, navega para a tela anterior.
          },
        ),
      ),
      body: Center( // Centraliza o conteúdo no corpo da página.
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Adiciona padding ao redor do conteúdo.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente.
            crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente.
            children: [
              const Icon(
                Icons.timer, // Exibe um ícone de cronômetro.
                size: 120, // Tamanho do ícone.
                color: Colors.blue, // Cor azul para o ícone.
              ),
              const SizedBox(height: 30), // Espaçamento entre o ícone e o texto.
              
              // Exibe o nome completo do bolsista em letras maiúsculas.
              Text(
                bolsista.nomeCompleto.toUpperCase(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Estilização do nome.
                maxLines: 1, // Limita o texto a uma linha.
                overflow: TextOverflow.ellipsis, // Corta o texto com reticências se for muito longo.
              ),
              const SizedBox(height: 24), // Espaço entre o nome e o próximo texto.

              // Texto informativo para o usuário.
              const Text(
                'É hora de trabalhar!', 
                style: TextStyle(fontSize: 18), // Estilo do texto.
              ),
              const SizedBox(height: 24), // Espaço entre os textos.

              // Exibe o tempo formatado do cronômetro usando o MobX para reagir às mudanças de estado.
              Observer(
                builder: (_) => Text(
                  timerStore.formattedTime, // Mostra o tempo formatado do cronômetro.
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold), // Estiliza o tempo.
                ),
              ),
              const SizedBox(height: 40), // Espaço entre o tempo e o botão.

              // Botão para iniciar/parar o cronômetro.
              Observer(
                builder: (_) {
                  return ElevatedButton(
                    // Alterna entre iniciar ou parar o cronômetro dependendo do estado.
                    onPressed: timerStore.isRunning
                        ? timerStore.stopTimer // Se o cronômetro estiver rodando, o botão para.
                        : timerStore.startTimer, // Caso contrário, o botão inicia o cronômetro.
                    style: ElevatedButton.styleFrom(
                      backgroundColor: timerStore.isRunning
                          ? Colors.red // Se o cronômetro estiver rodando, o botão fica vermelho.
                          : Colors.blue, // Se estiver parado, o botão fica azul.
                    ),
                    child: Text(
                      timerStore.isRunning ? 'Parar' : 'Iniciar', // Texto do botão, dependendo do estado.
                      style: const TextStyle(
                        color: Colors.white, // O texto do botão é branco.
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40), // Espaço entre o botão e o contador de inícios/paradas.

              // Mostra quantas vezes o cronômetro foi iniciado e parado, também observando o estado com MobX.
              Observer(
                builder: (_) => Text(
                  'Iniciado: ${timerStore.startCount} vezes\n  Parado: ${timerStore.stopCount} vezes', // Exibe a contagem de inícios e paradas.
                  style: const TextStyle(fontSize: 16), // Estilo do texto.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
