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

// Novo Registro: Serviços
app.post('/novo/servicos', async(req, res) => {
    let {codigo, servico, duracao, categoria, desconto, valor, descricao, ativo} = req.body;

    categoria = categoria ? categoria : null;
    desconto = desconto ? desconto : null;

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

// Alterar Registro: Serviços
app.put('/alterar/servicos/:id', async(req, res) => {
    let {codigo, servico, duracao, categoria, desconto, valor, descricao, ativo} = req.body;
    let id = req.params.id;

    categoria = categoria ? categoria : null;
    desconto = desconto ? desconto : null;

    let [query] = await conn.promise().execute('CALL alterar_servico ( ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [id, codigo, servico, duracao, categoria, desconto, valor, descricao, ativo]
    );

    if(!query[0]){
        res.send({ sucesso : query });
        return
    };

    if(query[0]){
        res.send({ duplicado : query[0] });
        return
    };
});

// Consultar Registro: Serviços
app.get('/consulta/servicos/:id', async(req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL consultar_servico ( ? )',
        [id]
    );

    res.send(query[0])
});

// Apagar Registro: Serviços
app.delete('/delete/servicos/:id', async(req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL deletar_servico ( ? )',
        [id]
    )

    res.send(query)
});