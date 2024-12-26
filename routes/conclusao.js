const { app, conn } = require('../server');

// Dados para GRID: Conclusão OS
app.post('/grid/conclusao', async(req, res) => {
    let { pesquisa } = req.body;

    pesquisa = pesquisa ? String(pesquisa).replaceAll(' ','|') : '|';

    let [query] = await conn.promise().execute('CALL grid_conclusoes ( ? )',
        [pesquisa]
    );

    res.send(query[0])
});

// Novo Registro: Conclusão OS
app.post('/novo/conclusao', async(req, res) => {
    let { andamento, conclusao, entrega, pagamento, garantia, observacoes } = req.body;

    entrega = entrega || null;
    pagamento = pagamento || null;
    garantia = garantia || null;

    let [query] = await conn.promise().execute(`CALL novo_conclusao ( ?, ?, ?, ?, ?, ?)`,
        [andamento, conclusao, entrega, pagamento, garantia, observacoes]
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

// Alterar Registro: Conclusão
app.put('/alterar/conclusao/:id', async(req, res) => {
    let { andamento, conclusao, entrega, pagamento, garantia, observacoes } = req.body;
    let id_conclusao = req.params.id;

    entrega = entrega || null;
    pagamento = pagamento || null;
    garantia = garantia || null;

    let [query] = await conn.promise().execute(`CALL alterar_conclusao ( ?, ?, ?, ?, ?, ?, ?)`,
        [id_conclusao, andamento, conclusao, entrega, pagamento, garantia, observacoes]
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

// Consultar Registro: Conclusão
app.get('/consulta/conclusao/:id', async(req, res) => {
    let id_conclusao = req.params.id;

    let [query] = await conn.promise().execute('CALL consultar_conclusao ( ? )',
        [id_conclusao]
    );

    res.send(query[0]);
});

// Deletar Registro: Conclusão
app.delete('/delete/conclusao/:id', async(req, res) => {
    let id_conclusao = req.params.id;

    let [query] = await conn.promise().execute('CALL deletar_conclusao ( ? )',
        [id_conclusao]
    );

    res.send(query);
})