const { app, conn } = require('../server.js');

// Dados para GRID: Andamentos
app.post('/grid/andamento', async(req, res) => {
    let { pesquisa } = req.body;

    pesquisa = pesquisa ? String(pesquisa).replaceAll(' ','|') : '|';

    let [query] = await conn.promise().execute('CALL grid_andamento ( ? )',
        [pesquisa]
    );

    res.send(query[0])
})

// Novo Registro: Andamentos
app.post('/novo/andamento', async(req, res) => {
    let { abertura, data, tecnico, registros } = req.body;

    let [query] = await conn.promise().query(`CALL novo_andamento ( ?, ? , ?)`,
        [abertura, data, tecnico]
    );

    if(query[0][0].duplicado){
        res.send({ duplicado : query[0] });
        return
    };

    id_andamento = query[0][0].id_andamento;
    for(let i = 0; i < registros.length; i++){
        [query] = await conn.promise().query(`CALL novo_executado ( ?, ?, ?, ?, ?, ?, ?)`,
            [id_andamento, registros[i].tipo, registros[i].executado , registros[i].quantidade, registros[i].desconto, registros[i].valor, registros[i].id]
        );
    };

    res.send({ sucesso : query });
});

// Alterar Sub-Registros: Andamento
app.put('/alterar/andamento/:id', async(req, res) => {
    let id_andamento = req.params.id;
    let { registros } = req.body;

    let query;
    for(let i = 0; i < registros.length; i++){

        if(registros[i].status == "Incluindo"){
            [query] = await conn.promise().execute(`CALL novo_executado ( ?, ?, ?, ?, ?, ?, ?)`,
                [id_andamento, registros[i].tipo, registros[i].executado, registros[i].quantidade, registros[i].desconto, registros[i].valor, registros[i].id]
            );
        }

        else if(registros[i].status == "Alterando"){
            [query] = await conn.promise().execute('CALL alterar_executado ( ?, ?, ?, ?, ?, ?, ? )',
                [id_andamento, registros[i].id, registros[i].tipo, registros[i].executado, registros[i].quantidade, registros[i].desconto, registros[i].valor]
            );
        }

        else if(registros[i].status == "Delete"){
            [query] = await conn.promise().execute(`CALL deletar_executado ( ?, ?)`,
                [id_andamento, registros[i].id]
            );
        }
    }

    res.send({
        sucesso : "Registro Atualizado!"
    })
});

// Consultar Registro e Sub-Registros: Andamento
app.get('/consulta/andamento/:id', async(req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL consultar_andamento( ? )',
        [ id ]
    );

    res.send(query)
})

// Deleter Registro e Sub-Registros: Andamento
app.delete('/delete/andamento/:id', async(req, res) => {
    let id = req.params.id;

    let [query] = await conn.promise().execute('CALL deletar_andamento ( ? )',
        [id]
    );
    
    res.send(query);
});