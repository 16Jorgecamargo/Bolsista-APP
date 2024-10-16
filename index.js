// Importa o módulo 'express', que é um framework para construir servidores em Node.js
const express = require('express');

// Cria uma instância da aplicação 'express', que é o servidor
const app = express();

// Define a porta do servidor. O valor pode vir de uma variável de ambiente (process.env.PORT)
// ou, se não houver, usa a porta 3000 por padrão
app.set('port', process.env.PORT || 3000);

// Middleware para permitir que o servidor entenda requisições no formato JSON
app.use(express.json());

// Importa e usa as rotas definidas no arquivo './src/rotas/rotas'.
// Esse arquivo deve conter as definições das rotas (endpoints) que o servidor irá responder
app.use(require('./src/rotas/rotas'));

// Inicia o servidor e faz com que ele escute na porta definida
// O segundo parâmetro é uma função callback que será executada quando o servidor iniciar
app.listen(app.get('port'), () => {
    console.log('Servidor ON', app.get('port')); // Exibe uma mensagem no console indicando que o servidor está rodando e a porta
});
