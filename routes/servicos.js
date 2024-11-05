const { app, conn } = require('../server.js');

// Dados da GRID: Serviços
app.post('/grid/servicos', async(req, res) => {
    let { pesquisa } = req.body;

    pesquisa = pesquisa ? String(pesquisa).replaceAll(' ','|') : '|';

    let [query] = await conn.promise().execute('CALL grid_servicos ( ? )',
        [pesquisa]
    );

    res.send(query[0])
});

// Código Automático: Serviços
app.get('/codigo/servicos', async(req, res) => {
    
    let [query] = await conn.promise().execute('CALL codigo_servicos ( )');

    res.send(query[0])
});

app.post('/novo/servicos', async(req, res) => {
    let {codigo, servico, duracao, categoria, desconto, valor, descricao, ativo} = req.body;

    let [query] = await conn.promise().execute('CALL novo_servico ( ?, ?, ?, ?, ?, ?, ?, ?)',
        [codigo, servico, duracao, categoria, desconto, valor, descricao, ativo]
    );

    if(!query[0]){
        res.send({ sucesso : query });
        return
    }

    if(query[0]){
        res.send({ duplicado : query[0] });
        return
    }
});