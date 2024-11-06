const { app, conn } = require('../server.js');

// Dados da GRID: Clientes
app.post('/grid/clientes', async(req, res) => {
    let { pesquisa } = req.body;

    pesquisa = pesquisa ? String(pesquisa).replaceAll(' ','|') : '|';

    let [query] = await conn.promise().execute('CALL grid_clientes ( ? )',
        [pesquisa]
    );

    res.send(query[0])
})

// Código Automático: Clientes
app.get('/codigo/clientes', async(req, res) => {

    let [query] = await conn.promise().execute('CALL codigo_cliente ( )');

    res.send(query[0])
});

// Novo Registro: Clientes
app.post('/novo/clientes', async(req, res) => {
    let { codigo, cliente, tipo, cadastro, contato, email, endereco, historico, ativo, notificar} = req.body;

    let [query] = await conn.promise().execute('CALL novo_cliente ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )',
        [codigo, cliente, tipo, cadastro, contato, email, endereco, historico, ativo, notificar]
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

// Alterar Registro: Clientes
app.put('/alterar/clientes/:id', async (req, res) => {
    let { codigo, cliente, tipo, cadastro, contato, email, endereco, historico, ativo, notificar} = req.body;
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL alterar_cliente ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )',
        [id, codigo, cliente, tipo, cadastro, contato, email, endereco, historico, ativo, notificar]
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

// Consultar Registro: Clientes
app.get('/consulta/clientes/:id', async (req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL consultar_cliente ( ? )',
        [id]
    );

    res.send(query[0]);
});

// Apagar Registro: Clientes
app.delete('/delete/clientes/:id', async (req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL deletar_cliente ( ? )',
        [id]
    );

    res.send(query);
})