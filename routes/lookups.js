const { app, conn } = require('../server.js');

app.get('/lookup/categoria', async(req, res) => {
    
    let [query] = await conn.promise().execute(`CALL lookup_categorias( )`);

    res.send(query[0]);
});

app.get('/lookup/cliente', async(req, res) => {
    
    let [query] = await conn.promise().execute(`CALL lookup_clientes( )`);

    res.send(query[0]);
});