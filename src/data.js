// Importa o módulo 'mysql2', que permite trabalhar com bancos de dados MySQL no Node.js
const mysql = require('mysql2');

// Cria uma conexão com o banco de dados MySQL
const dbConection = mysql.createConnection({
    host: 'localhost', // O servidor onde o banco de dados está rodando (neste caso, na própria máquina local)
    user: 'root', // O nome de usuário para acessar o banco de dados (geralmente 'root' em ambientes de desenvolvimento)
    password: '12345678', // A senha do usuário para acessar o banco de dados
    database: 'db_exercicio' // O nome do banco de dados que será usado
});

// Estabelece a conexão com o banco de dados
dbConection.connect(function(error) {
    // Se ocorrer um erro ao tentar conectar, imprime o erro no console
    if (error) return console.log(error);
    // Se a conexão for bem-sucedida, imprime uma mensagem de sucesso no console
    else return console.log("Banco de dados conectado!");
});

// Exporta a conexão para que possa ser utilizada em outros arquivos do projeto
module.exports = dbConection;
