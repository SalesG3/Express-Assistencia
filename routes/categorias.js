const { app, conn } = require('../server.js');

// Dados da GRID: categorias
app.post('/grid/categorias', async(req, res) => {
    let { pesquisa } = req.body;

    pesquisa = pesquisa ? String(pesquisa).replaceAll(' ','|') : '|';

    let [query] = await conn.promise().execute('CALL grid_categorias ( ? )',
        [pesquisa]
    );

    res.send(query[0])
})

// Código Automático: categorias
app.get('/codigo/categorias', async(req, res) => {

    let [query] = await conn.promise().execute('CALL codigo_categorias ( )');

    res.send(query[0])
});

// Novo Registro: categorias
app.post('/novo/categorias', async(req, res) => {
    let { codigo, categoria, descricao, ativo } = req.body;

    let [query] = await conn.promise().execute('CALL novo_categoria ( ?, ?, ?, ? )',
        [codigo, categoria, descricao, ativo]
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

// Alterar Registro: categorias
app.put('/alterar/categorias/:id', async (req, res) => {
    let { codigo, categoria, descricao, ativo } = req.body;
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL alterar_categoria ( ?, ?, ?, ?, ? )',
        [id, codigo, categoria, descricao, ativo]
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

// Consultar Registro: categorias
app.get('/consulta/categorias/:id', async (req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL consultar_categoria ( ? )',
        [id]
    );

    res.send(query[0]);
});

// Apagar Registro: categorias
app.delete('/delete/categorias/:id', async (req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL deletar_categoria ( ? )',
        [id]
    );
    
    if(query.affectedRows == 1){
        res.send({ sucesso : query })
    }

    if(query.affectedRows == 0){
        res.send({ dependencias : query})
    }
})