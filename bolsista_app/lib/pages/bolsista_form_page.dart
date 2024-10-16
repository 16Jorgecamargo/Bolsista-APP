import 'dart:io'; // Importa a biblioteca para manipulação de arquivos.
import 'package:flutter/material.dart'; // Importa a biblioteca Flutter para a interface de usuário.
import 'package:file_picker/file_picker.dart'; // Importa a biblioteca para selecionar arquivos do dispositivo.
import 'package:http/http.dart' as http; // Importa a biblioteca HTTP para realizar requisições à API.
import 'package:path/path.dart' as p; // Importa a biblioteca para manipulação de caminhos de arquivos.
import 'package:intl/intl.dart'; // Importa a biblioteca para formatação de datas.

class BolsistaFormPage extends StatefulWidget {
  const BolsistaFormPage({super.key}); // Define a chave para o widget Stateful.

  @override
  _BolsistaFormPageState createState() => _BolsistaFormPageState(); // Cria o estado para o widget.
}

class _BolsistaFormPageState extends State<BolsistaFormPage> {
  final _formKey = GlobalKey<FormState>(); // Chave global para identificar o formulário.
  final _nomeController = TextEditingController(); // Controlador para o campo de texto do nome.
  String? _cursoSelecionado; // Variável que armazena o curso selecionado.
  DateTime? _dataNascimento; // Variável que armazena a data de nascimento selecionada.
  File? _documento; // Variável que armazena o documento selecionado.
  final List<String> _cursos = ['Ciência da Computação', 'Agronomia', 'Biologia']; // Lista de cursos disponíveis.

  // Função para abrir o seletor de data.
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Data inicial selecionada.
      firstDate: DateTime(1900), // Primeira data possível para seleção.
      lastDate: DateTime.now(), // Última data possível, a data atual.
    );
    if (picked != null && picked != _dataNascimento) {
      setState(() {
        _dataNascimento = picked; // Atualiza a data de nascimento selecionada.
      });
    }
  }

  // Função para escolher um documento do dispositivo.
  Future<void> _escolherDocumento() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // Define o tipo de arquivo permitido.
      allowedExtensions: ['pdf', 'jpeg', 'jpg', 'png'], // Extensões de arquivo permitidas.
    );
    if (result != null) {
      setState(() {
        _documento = File(result.files.single.path!); // Atualiza o caminho do documento selecionado.
      });
    }
  }

  // Função para enviar o formulário à API.
  Future<void> _enviarFormulario() async {
    // Valida se todos os campos obrigatórios foram preenchidos.
    if (_formKey.currentState!.validate() && _dataNascimento != null && _documento != null) {
      // Cria uma requisição POST com multipart para envio de arquivos.
      final request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:3000/bolsista'));
      request.fields['nome_completo'] = _nomeController.text; // Adiciona o nome ao corpo da requisição.
      request.fields['data_nascimento'] = _dataNascimento!.toIso8601String(); // Adiciona a data de nascimento.
      request.fields['curso'] = _cursoSelecionado!; // Adiciona o curso selecionado.
      
      // Anexa o arquivo do documento como parte da requisição.
      final multipartFile = await http.MultipartFile.fromPath(
        'c_matricula',
        _documento!.path,
      );
      request.files.add(multipartFile); // Adiciona o arquivo ao corpo da requisição.
      
      final response = await request.send(); // Envia a requisição ao servidor.
      if (response.statusCode == 201) {
        Navigator.of(context).pop(true); // Fecha a página e retorna sucesso se o status for 201.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao adicionar bolsista')), // Exibe uma mensagem de erro se a requisição falhar.
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Bolsista')), // Título da AppBar.
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding para espaçar o conteúdo da tela.
        child: Form(
          key: _formKey, // Associa o formulário à chave global.
          child: ListView(
            children: [
              // Campo de texto para o nome completo.
              TextFormField(
                controller: _nomeController, // Controlador do campo de texto.
                decoration: const InputDecoration(labelText: 'Nome Completo'), // Rótulo do campo.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome completo'; // Validação para campo vazio.
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10), // Espaçamento entre os campos.

              // Dropdown para selecionar o curso.
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Curso'), // Rótulo do dropdown.
                value: _cursoSelecionado, // Valor atual do dropdown.
                items: _cursos.map((String curso) {
                  return DropdownMenuItem<String>(
                    value: curso, // Valor do item.
                    child: Text(curso), // Texto exibido.
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _cursoSelecionado = newValue; // Atualiza o valor selecionado.
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione um curso'; // Validação para seleção de curso.
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Seletor de data de nascimento.
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dataNascimento == null
                          ? 'Selecione a Data de Nascimento' // Texto padrão quando a data não foi selecionada.
                          : DateFormat('dd/MM/yyyy').format(_dataNascimento!), // Exibe a data formatada.
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selecionarData(context), // Chama a função para selecionar a data.
                    child: const Text('Selecionar Data'), // Botão para selecionar a data.
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Seletor de arquivo para o documento.
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _documento == null
                          ? 'Nenhum documento selecionado' // Texto padrão quando o documento não foi selecionado.
                          : p.basename(_documento!.path), // Exibe o nome do arquivo selecionado.
                    ),
                  ),
                  TextButton(
                    onPressed: _escolherDocumento, // Chama a função para escolher o documento.
                    child: const Text('Escolher Documento'), // Botão para escolher o documento.
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Botão para enviar o formulário.
              ElevatedButton(
                onPressed: _enviarFormulario, // Chama a função de envio do formulário.
                child: const Text('Adicionar Bolsista'), // Texto do botão.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
