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
        [query] = await conn.promise().query(`CALL novo_executado ( ?, ?, ?, ?, ?, ?)`,
            [id_andamento, registros[i].tipo, registros[i].executado , registros[i].quantidade, registros[i].desconto, registros[i].liquido]
        );
    };

    res.send({ sucesso : query });
})