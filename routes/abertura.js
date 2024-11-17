const { app, conn } = require('../server.js');

// Dados da GRID: Abertura
app.post('/grid/abertura', async(req, res) => {
    let { pesquisa } = req.body;

    pesquisa = pesquisa ? String(pesquisa).replaceAll(' ','|') : '|';
    

    let [query] = await conn.promise().execute('CALL grid_abertura ( ? )',
        [pesquisa]
    );

    let format = { year: 'numeric', month: 'numeric', day: 'numeric' };

    console.log(query.toLocaleDateString())

    console.log(query)

    res.send(query[0])
});

// Código Automático: Abertura
app.get('/codigo/abertura', async(req, res) => {
    
    let [query] = await conn.promise().execute('CALL codigo_abertura ( )');

    res.send(query[0])
});

// Novo Registro: Abertura
app.post('/novo/abertura', async(req, res) => {
    let {codigo, abertura, status,usuario, cliente, equipamento, descricao} = req.body;

    let [query] = await conn.promise().execute('CALL novo_abertura ( ?, ?, ?, ?, ?, ?, ?)',
        [codigo, abertura, status,usuario, cliente, equipamento, descricao]
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

// Alterar Registro: Abertura
app.put('/alterar/abertura/:id', async(req, res) => {
    let {codigo, abertura, status,usuario, cliente, equipamento, descricao} = req.body;
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL alterar_abertura ( ?, ?, ?, ?, ?, ?, ?, ?)',
        [id, codigo, abertura, status,usuario, cliente, equipamento, descricao]
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

// Consultar Registro: Abertura
app.get('/consulta/abertura/:id', async(req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL consultar_abertura ( ? )',
        [id]
    );

    res.send(query[0])
});

// Apagar Registro: Abertura
app.delete('/delete/abertura/:id', async(req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL deleter_abertura ( ? )',
        [id]
    )

    res.send(query)
});