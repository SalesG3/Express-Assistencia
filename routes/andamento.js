const { app, conn } = require('../server.js');

app.get('/codigo/andamento', async(req, res) => {
    
    let [query] = await conn.promise().execute(``)
})