const { app, conn } = require('../server.js');

app.get('/codigo/andamento', async(req, res) => {
    
    let [query] = await conn.promise().execute(``)
});

app.post('/novo/andamento', async(req, res) => {
    let { abertura, data, tecnico, registros } = req.body;

    let [query] = await conn.promise().query(`CALL novo_andamento ( ?, ? , ?)`,
        [abertura, data, tecnico]
    );
    id = query[0][0].ID

    for(let i = 0; i < registros.length; i++){
        [query] = await conn.promise().query(`CALL novo_executado ( ?, ?, ?, ?, ?, ?)`,
            [id, registros[i].tipo, registros[i].executado , registros[i].quantidade, registros[i].desconto, registros[i].liquido]
        );
    };

    res.send(query);
})