const { app, conn } = require('../server.js');

// Dados da GRID: Produtos
app.post('/grid/produtos', async(req, res) => {
    let { pesquisa } = req.body;

    pesquisa = pesquisa ? String(pesquisa).replaceAll(' ','|') : '|';

    let [query] = await conn.promise().execute('CALL grid_produtos ( ? )',
        [pesquisa]
    );

    res.send(query[0])
});

// Código Automático: Produtos
app.get('/codigo/produtos', async(req, res) => {
    
    let [query] = await conn.promise().execute('CALL codigo_produtos ( )');

    res.send(query[0])
});

// Novo Registro: Produtos
app.post('/novo/produtos', async(req, res) => {
    let {codigo, produto, marca, categoria, custo, desconto, valor, descricao, ativo} = req.body;

    categoria = categoria ? categoria : null;
    custo = custo ? custo : 0;
    desconto = desconto ? desconto : 0;

    let [query] = await conn.promise().execute('CALL novo_produto ( ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [codigo, produto, marca, categoria, custo, desconto, valor, descricao, ativo]
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

// Alterar Registro: Produtos
app.put('/alterar/produtos/:id', async(req, res) => {
    let {codigo, produto, marca, categoria, custo, desconto, valor, descricao, ativo} = req.body;
    let id = req.params.id;

    categoria = categoria ? categoria : null;
    custo = custo ? custo : 0;
    desconto = desconto ? desconto : 0;

    let [query] = await conn.promise().execute('CALL alterar_produto ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [id, codigo, produto, marca, categoria, custo, desconto, valor, descricao, ativo]
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
app.get('/consulta/produtos/:id', async(req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL consultar_produto ( ? )',
        [id]
    );

    res.send(query[0])
});

// Apagar Registro: Serviços
app.delete('/delete/produtos/:id', async(req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL deletar_produto ( ? )',
        [id]
    )

    res.send(query)
});