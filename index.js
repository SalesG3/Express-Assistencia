const { app, conn } = require('./server.js');
const md5 = require('md5');

app.post('/login', async (req, res) => {
    let {usuario, senha} = req.body;    

    let [query] = await conn.promise().execute('CALL login_usuario( ?, ?)',
        [usuario, md5(senha)]
    )

    if(query[0]){
        res.send({ sucesso : query[0] })
        return
    }

    if(!query[0]){
        res.send({ erro : "Login e Senha Incompatíveis!" })
        return
    }
})

require('./routes/clientes.js');
require('./routes/servicos.js');
require('./routes/categorias.js');
require('./routes/lookups.js');
require('./routes/produtos.js');
require('./routes/abertura.js');
require('./routes/andamento.js');
