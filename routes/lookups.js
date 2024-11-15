const { app, conn } = require('../server.js');

app.get('/lookup/categorias', async(req, res) => {
    
    let [query] = await conn.promise().execute(`CALL lookup_categorias( )`);

    res.send(query[0]);
});