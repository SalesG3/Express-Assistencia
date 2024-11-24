const { app, conn } = require('../server.js');

app.get('/lookup/categoria', async(req, res) => {
    
    let [query] = await conn.promise().execute(`CALL lookup_categorias( )`);

    res.send(query[0]);
});

app.get('/lookup/cliente', async(req, res) => {
    
    let [query] = await conn.promise().execute(`CALL lookup_clientes( )`);

    res.send(query[0]);
});

app.get('/lookup/ordem_servico', async(req, res) => {

    let [query] = await conn.promise().execute(`CALL lookup_aberturas ( )`);

    res.send(query[0])
})

app.get('/lookup/sub-executado', async(req, res) => {

    let [query] = await conn.promise().execute(`CALL lookup_executado ( )`);

    res.send(query);
})