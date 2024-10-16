import 'dart:io'; // Biblioteca para manipulação de arquivos, usada para lidar com arquivos locais
import 'package:flutter/material.dart'; // Biblioteca principal do Flutter para construção de interfaces
import 'package:file_picker/file_picker.dart'; // Biblioteca para permitir seleção de arquivos do dispositivo
import 'package:http/http.dart' as http; // Biblioteca para realizar requisições HTTP
import 'package:intl/intl.dart'; // Biblioteca para formatação de datas
import 'package:path/path.dart' as p; // Biblioteca para manipulação de caminhos de arquivos
import '../models/bolsista_model.dart'; // Importa o modelo de dados do bolsista
import '../stores/bolsista_store.dart'; // Importa a store MobX para gerenciamento de estado

class BolsistaEditPage extends StatefulWidget {
  final Bolsista bolsista; // Dados do bolsista a ser editado
  final BolsistaStore bolsistaStore; // Store responsável por atualizar o estado do bolsista

  const BolsistaEditPage({super.key, required this.bolsista, required this.bolsistaStore});

  @override
  _BolsistaEditPageState createState() => _BolsistaEditPageState(); // Cria o estado da página
}

class _BolsistaEditPageState extends State<BolsistaEditPage> {
  final _formKey = GlobalKey<FormState>(); // Chave global para controle do formulário
  late TextEditingController _nomeController; // Controlador para o campo de texto de nome
  String? _cursoSelecionado; // Variável para armazenar o curso selecionado
  DateTime? _dataNascimento; // Armazena a data de nascimento selecionada
  File? _novoDocumento; // Armazena o arquivo do novo documento escolhido

  // Lista de cursos disponíveis
  final List<String> _cursos = [
    'Ciência da Computação',
    'Agronomia',
    'Biologia'
  ];

  @override
  void initState() {
    super.initState();
    // Inicializa o campo de texto e as variáveis com os dados do bolsista
    _nomeController = TextEditingController(text: widget.bolsista.nomeCompleto);
    _cursoSelecionado = widget.bolsista.curso;
    _dataNascimento = widget.bolsista.dataNascimento;
  }

  // Função para selecionar uma nova data de nascimento usando um seletor de data
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime.now(), // Define a data inicial no seletor
      firstDate: DateTime(1900), // Primeira data disponível no seletor
      lastDate: DateTime.now(), // Última data disponível no seletor
    );
    if (picked != null && picked != _dataNascimento) {
      // Se uma nova data for escolhida, atualiza o estado com a nova data
      setState(() {
        _dataNascimento = picked;
      });
    }
  }

  // Função para escolher um novo documento (ex: comprovante de matrícula)
  Future<void> _escolherDocumento() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // Define que os arquivos a serem escolhidos têm tipos específicos
      allowedExtensions: ['pdf', 'jpeg', 'jpg', 'png'], // Extensões permitidas
    );

    if (result != null) {
      // Se um arquivo for selecionado, atualiza o estado com o caminho do novo documento
      setState(() {
        _novoDocumento = File(result.files.single.path!);
      });
    }
  }

  // Função para salvar as alterações feitas no formulário
  Future<void> _salvarAlteracoes(BuildContext context) async {
    // Verifica se o formulário está válido
    if (!_formKey.currentState!.validate()) return;

    // Exibe um diálogo de confirmação antes de salvar
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar alterações'), // Título do diálogo
          content: const Text('Deseja salvar as alterações?'), // Texto do diálogo
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false); // Cancela e fecha o diálogo
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirma e fecha o diálogo
              },
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        // Cria uma requisição HTTP Multipart para enviar os dados e o arquivo ao servidor
        final request = http.MultipartRequest(
          'PUT',
          Uri.parse('http://10.0.2.2:3000/bolsista/${widget.bolsista.id}'), // URL do servidor
        );

        // Adiciona os campos de texto na requisição
        request.fields['nome_completo'] = _nomeController.text;
        request.fields['data_nascimento'] = _dataNascimento!.toIso8601String();
        request.fields['curso'] = _cursoSelecionado!;

        // Se um novo documento foi escolhido, adiciona o arquivo à requisição
        if (_novoDocumento != null) {
          final multipartFile = await http.MultipartFile.fromPath(
            'c_matricula', // Campo para o comprovante
            _novoDocumento!.path, // Caminho do arquivo
          );
          request.files.add(multipartFile); // Adiciona o arquivo ao request
          request.fields['deletar_comprovante'] = 'true'; // Informa que o comprovante antigo será deletado
        } else {
          request.fields['deletar_comprovante'] = 'false'; // Informa que o comprovante antigo será mantido
        }

        // Envia a requisição para o servidor
        final response = await request.send();

        if (response.statusCode == 200) {
          // Se a requisição for bem-sucedida, atualiza o objeto bolsista
          final Bolsista bolsistaAtualizado = Bolsista(
            id: widget.bolsista.id,
            nomeCompleto: _nomeController.text,
            dataNascimento: _dataNascimento!,
            curso: _cursoSelecionado!,
            cMatricula: _novoDocumento != null
                ? _novoDocumento!.path
                : widget.bolsista.cMatricula, // Atualiza o caminho do documento se houver
          );

          widget.bolsistaStore.atualizarBolsista(bolsistaAtualizado); // Atualiza a store com o bolsista modificado
          Navigator.of(context).pop(true); // Retorna à lista de bolsistas
        } else {
          // Se houver erro ao salvar, exibe uma notificação
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao salvar as alterações')),
          );
        }
      } catch (e) {
        // Se houver exceção, exibe uma notificação de erro de conexão
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao tentar salvar. Verifique sua conexão.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Interface da página
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Bolsista'), // Título da página
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Define o espaçamento interno
        child: Form(
          key: _formKey, // Define a chave do formulário
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController, // Controlador do campo de texto do nome
                decoration: const InputDecoration(labelText: 'Nome Completo'), // Label do campo
                validator: (value) {
                  // Validação do campo de nome
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome completo'; // Retorna mensagem de erro se vazio
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10), // Espaçamento vertical entre os campos
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Curso'), // Label do dropdown
                value: _cursoSelecionado, // Valor atual do dropdown
                items: _cursos.map((String curso) {
                  // Gera os itens do dropdown a partir da lista de cursos
                  return DropdownMenuItem<String>(
                    value: curso, // Valor do item
                    child: Text(curso), // Texto exibido para o curso
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Atualiza o valor do curso selecionado
                  setState(() {
                    _cursoSelecionado = newValue;
                  });
                },
                validator: (value) {
                  // Validação do dropdown
                  if (value == null) {
                    return 'Por favor, selecione um curso'; // Mensagem de erro se vazio
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10), // Espaçamento
              Row(
                children: [
                  Expanded(
                    // Exibe a data de nascimento selecionada ou uma mensagem caso não tenha sido escolhida
                    child: Text(
                      _dataNascimento == null
                          ? 'Selecione a Data de Nascimento'
                          : DateFormat('dd/MM/yyyy').format(_dataNascimento!), // Formata a data
                    ),
                  ),
                  TextButton(
                    // Botão para abrir o seletor de data
                    onPressed: () => _selecionarData(context),
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Espaçamento
              Row(
                children: [
                  Expanded(
                    // Exibe o nome do documento atual ou do novo documento escolhido
                    child: Text(
                      _novoDocumento == null
                          ? 'Comprovante Atual: ${p.basename(widget.bolsista.cMatricula)}' // Exibe o comprovante atual
                          : p.basename(_novoDocumento!.path), // Exibe o novo comprovante, se houver
                    ),
                  ),
                  TextButton(
                    // Botão para escolher um novo documento
                    onPressed: _escolherDocumento,
                    child: const Text('Escolher Novo Comprovante'),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Espaçamento
              ElevatedButton(
                // Botão para salvar as alterações
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Se o formulário for válido, salva as alterações
                    _salvarAlteracoes(context);
                  }
                },
                child: const Text('Salvar Alterações'), // Texto do botão
              ),
            ],
          ),
        ),
      ),
    );
  }
}
