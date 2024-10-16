// Importa o roteador do Express, o Multer para upload de arquivos, Path para trabalhar com caminhos de arquivos e FS para manipular arquivos
const { Router } = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
//*                                                                                                         ------>  https://http.cat <------
// Cria um roteador para definir as rotas da aplicação
const rota = Router();                                    

// Configuração de armazenamento no multer (para uploads)
const storage = multer.diskStorage({
  destination: function (req, file, callback) {
    // Define a pasta 'uploads/' como o destino dos arquivos enviados
    callback(null, 'uploads/');
  },
  filename: function (req, file, callback) {
    // Define um nome único para o arquivo, usando a data atual e a extensão original do arquivo
    callback(null, Date.now() + path.extname(file.originalname));
  }
});

// Filtro para permitir apenas uploads de arquivos nos formatos PDF, JPEG, JPG e PNG
const upload = multer({
  storage: storage,
  fileFilter: function (req, file, callback) {
    const filetypes = /jpeg|jpg|png|pdf/; // Define os tipos permitidos
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase()); // Verifica a extensão do arquivo

    if (extname) {
      return callback(null, true); // Aceita o arquivo se a extensão for válida
    } else {
      // Rejeita o arquivo se a extensão não for suportada
      callback(new Error('Arquivo não suportado! Apenas PDF/JPEG/PNG são permitidos.'), false);
    }
  }
});

// Importa a conexão com o banco de dados (arquivo externo)
const dbConection = require('../data');

//! ============================> Rota para listar todos os bolsistas  <=========================
rota.get('/bolsista', (req, res) => {
  // Consulta o banco de dados para obter todos os bolsistas
  dbConection.query('SELECT * FROM bolsista;', (error, rows) => {
    if (!error) return res.json(rows); // Se não houver erro, retorna os dados em formato JSON
    else return console.log(error); // Caso contrário, exibe o erro no console
  });
});

//! Rota para acessar o comprovante de matrícula  <=========================
rota.get('/comprovante/:filename', (req, res) => {
  const { filename } = req.params; // Obtém o nome do arquivo da URL
  const filePath = path.join(__dirname, '../../uploads', filename); // Cria o caminho completo para o arquivo
  // Define o cabeçalho para exibir o arquivo PDF inline no navegador
  res.setHeader('Content-Disposition', 'inline');
  // Envia o arquivo para o navegador
  res.sendFile(filePath, (err) => {
    if (err) {
      console.log(err);
      res.status(404).send('Arquivo não encontrado'); // Caso o arquivo não seja encontrado, envia um erro 404
    }
  });
});

//! ============================> Rota para buscar um bolsista pelo ID  <=========================
rota.get('/:bolsista/:id', (req, res) => {
  const { id } = req.params; // Obtém o ID da URL
  // Consulta o banco de dados para obter o bolsista pelo ID
  dbConection.query('SELECT * FROM bolsista WHERE id = ?;', [id], (error, rows, fields) => {
    if (!error) return res.json(rows); // Retorna os dados do bolsista em formato JSON
    else return console.log(error); // Exibe o erro no console, se houver
  });
});

//! ============================> Rota para adicionar um novo bolsista  <=========================
rota.post('/bolsista', upload.single('c_matricula'), (req, res) => {
  const { nome_completo, data_nascimento, curso } = req.body; // Obtém os dados do corpo da requisição
  const c_matricula = req.file ? req.file.filename : null; // Obtém o nome do arquivo enviado, se existir
  // Insere o novo bolsista no banco de dados
  dbConection.query(`
    INSERT INTO bolsista (nome_completo, data_nascimento, curso, c_matricula)
    VALUES (?, ?, ?, ?);`,
    [nome_completo, data_nascimento.slice(0, 10), curso, c_matricula],
    (error, rows, fields) => {
      if (!error) {
        return res.status(201).json({ Status: 'Bolsista adicionado!' }); // Retorna status de sucesso se a inserção foi bem-sucedida
      } else {
        console.log(error);
        return res.status(500).json({ Status: 'Erro ao adicionar bolsista' }); // Retorna erro 500 se houve falha
      }
    });
});

//! ============================> Rota para atualizar um bolsista e gerenciar a exclusão do comprovante antigo  <=========================
rota.put('/bolsista/:id', upload.single('c_matricula'), (req, res) => {
  const { id } = req.params; // Obtém o ID do bolsista
  const { nome_completo, data_nascimento, curso, deletar_comprovante } = req.body; // Obtém os dados do corpo da requisição
  const novoComprovante = req.file ? req.file.filename : null; // Obtém o novo arquivo enviado, se existir

  // Consulta o banco de dados para obter o comprovante atual do bolsista
  dbConection.query('SELECT c_matricula FROM bolsista WHERE id = ?', [id], (error, rows) => {
    if (error) {
      console.log('Erro ao obter o bolsista:', error);
      return res.status(500).json({ error: 'Erro ao obter o bolsista' });
    }

    const comprovanteAntigo = rows[0].c_matricula; // Obtém o comprovante antigo

    // Atualiza os dados do bolsista no banco de dados
    dbConection.query(`
        UPDATE bolsista 
        SET nome_completo = ?, data_nascimento = ?, curso = ?, c_matricula = ?
        WHERE id = ?`,
      [nome_completo, data_nascimento.slice(0, 10), curso, novoComprovante || comprovanteAntigo, id],
      (error, result) => {
        if (!error) {
          // Se um novo comprovante foi enviado e o comprovante antigo deve ser deletado
          if (deletar_comprovante === 'true' && novoComprovante && comprovanteAntigo) {
            const caminhoAntigo = path.join(__dirname, '../../uploads', comprovanteAntigo);

            // Exclui o comprovante antigo do sistema de arquivos
            fs.unlink(caminhoAntigo, (err) => {
              if (err && err.code !== 'ENOENT') { // Ignora erro se o arquivo não existir
                console.log('Erro ao deletar o comprovante antigo:', err);
              } else {
                console.log('Comprovante antigo deletado:', comprovanteAntigo);
              }
            });
          }
          return res.json({ status: 'Bolsista atualizado com sucesso!' }); // Retorna status de sucesso após a atualização
        } else {
          console.log('Erro ao atualizar o bolsista:', error);
          return res.status(500).json({ error: 'Erro ao atualizar o bolsista' });
        }
      }
    );
  });
});

//! ============================> Rota para deletar um bolsista  <=========================
rota.delete('/bolsista/:id', (req, res) => {
  const { id } = req.params; // Obtém o ID do bolsista
  // Consulta o banco de dados para obter o comprovante do bolsista antes de deletá-lo
  dbConection.query('SELECT c_matricula FROM bolsista WHERE id = ?;', [id], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(500).json({ Status: 'Erro ao buscar o bolsista.' });
    }
    const bolsista = results[0];
    if (!bolsista) {
      return res.status(404).json({ Status: 'Bolsista não encontrado.' });
    }
    const filePath = path.join(__dirname, '../../uploads', bolsista.c_matricula); // Caminho do comprovante
    fs.unlink(filePath, (err) => {
      if (err && err.code !== 'ENOENT') {
        console.log(err);
        return res.status(500).json({ Status: 'Erro ao deletar o arquivo.' });
      }
      // Deleta o bolsista do banco de dados
      dbConection.query('DELETE FROM bolsista WHERE id = ?;', [id], (error) => {
        if (error) {
          console.log(error);
          return res.status(500).json({ Status: 'Erro ao deletar o bolsista.' });
        }
        return res.status(200).json({ Status: 'Bolsista e arquivo deletados com sucesso.' });
      });
    });
  });
});

// Exporta o roteador para ser usado em outros módulos da aplicação
module.exports = rota;
