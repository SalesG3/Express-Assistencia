const { app, conn } = require('../server.js');

app.post('/grid/clientes', async(req, res) => {
    let { pesquisa } = req.body;

    pesquisa = pesquisa ? String(pesquisa).replaceAll(' ','|') : '|';

    let [query] = await conn.promise().execute('CALL grid_clientes ( ? )',
        [pesquisa]
    );

    res.send(query[0])
})

app.get('/codigo/clientes', async(req, res) => {

    let [query] = await conn.promise().execute('CALL codigo_cliente ( )');

    res.send(query[0])
});

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
})