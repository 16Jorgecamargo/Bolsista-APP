import 'package:mobx/mobx.dart'; // Importa MobX, usado para gerenciamento de estado reativo
import 'dart:async'; // Importa o pacote de assincronismo para trabalhar com timers

part 'timer_store.g.dart'; // Gera automaticamente o código necessário para o MobX

// Define a classe TimerStore como uma combinação de _TimerStoreBase e _$TimerStore, gerada pelo MobX
class TimerStore = _TimerStoreBase with _$TimerStore;

// Classe base da lógica de Timer, com os estados gerenciados por MobX
abstract class _TimerStoreBase with Store {
  Timer? _timer; // Armazena uma referência ao timer do Dart

  // Estado observável que armazena o tempo decorrido em segundos
  @observable
  int elapsedTime = 0; // Tempo em segundos

  // Estado observável que conta quantas vezes o timer foi iniciado
  @observable
  int startCount = 0;

  // Estado observável que conta quantas vezes o timer foi parado
  @observable
  int stopCount = 0;

  // Estado observável que indica se o timer está rodando
  @observable
  bool isRunning = false;

  // Getter que calcula o tempo decorrido formatado no estilo MM:SS
  @computed
  String get formattedTime {
    final minutes =
        (elapsedTime ~/ 60).toString().padLeft(2, '0'); // Calcula os minutos
    final seconds =
        (elapsedTime % 60).toString().padLeft(2, '0'); // Calcula os segundos
    return '$minutes:$seconds'; // Retorna no formato MM:SS
  }

  // Ação para iniciar o timer
  @action
  void startTimer() {
    if (!isRunning) {
      // Só inicia o timer se ele não estiver rodando
      startCount++; // Incrementa o contador de inícios
      isRunning = true; // Define que o timer está rodando
      // Cria um timer que incrementa o tempo a cada segundo
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        incrementTime(); // Incrementa o tempo a cada segundo
      });
    }
  }

  // Ação para parar o timer
  @action
  void stopTimer() {
    if (isRunning) {
      // Só para o timer se ele estiver rodando
      stopCount++; // Incrementa o contador de paradas
      isRunning = false; // Define que o timer parou
      _timer?.cancel(); // Cancela o timer
    }
  }

  // Ação para incrementar o tempo decorrido
  @action
  void incrementTime() {
    if (isRunning) {
      // Só incrementa o tempo se o timer estiver rodando
      elapsedTime++; // Incrementa o tempo em um segundo
    }
  }

  // Ação para resetar o timer
  @action
  void resetTimer() {
    stopTimer(); // Para o timer
    elapsedTime = 0; // Reseta o tempo decorrido para zero
  }
}
