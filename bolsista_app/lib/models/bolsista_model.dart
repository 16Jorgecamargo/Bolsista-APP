//* Criação da classe Bolsista que recebe os dados do banco de dados
class Bolsista {
  final int id; // Identificador único do bolsista
  final String nomeCompleto; // Nome completo do bolsista
  final DateTime dataNascimento; // Data de nascimento do bolsista
  final String curso; // Curso do bolsista
  final String cMatricula; // Caminho ou identificador do comprovante de matrícula

  //* Construtor da classe Bolsista que recebe os parâmetros obrigatórios
  Bolsista({
    required this.id, // ID do bolsista
    required this.nomeCompleto, // Nome completo do bolsista
    required this.dataNascimento, // Data de nascimento do bolsista
    required this.curso, // Curso do bolsista
    required this.cMatricula, // Comprovante de matrícula do bolsista
  });

  //* Fábrica que cria uma instância de Bolsista a partir de um JSON
  factory Bolsista.fromJson(Map<String, dynamic> json) {
    return Bolsista(
      id: json['id'], // Atribui o valor do campo 'id' do JSON
      nomeCompleto: json['nome_completo'], // Atribui o nome completo do JSON
      dataNascimento: DateTime.parse(json['data_nascimento']), // Converte a string de data em DateTime
      curso: json['curso'], // Atribui o curso do JSON
      cMatricula: json['c_matricula'], // Atribui o comprovante de matrícula do JSON
    );
  }
}
