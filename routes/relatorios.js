const { app, conn } = require('../server');
const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

app.get('/relatorios/listagem/aberturas', async(req, res) => {

    let [query] = await conn.promise().execute(`CALL listagem_aberturas ( )`);

    const html = gerarHTML(query[0]);

    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    await page.setContent(html);

    const filePath = path.join(__dirname, 'relatorio_dinamico.pdf');

    // Gera o PDF
    await page.pdf({ path: filePath, format: 'A4' });

    await browser.close();

    // Envia o PDF como resposta
    res.download(filePath, 'relatorio_dinamico.pdf', (err) => {
        if (err) {
            console.error('Erro ao enviar o arquivo:', err);
        }
        // Remove o arquivo temporário após o envio
        fs.unlinkSync(filePath);
    });
});

const gerarHTML = (dados) => `<html>
    <head>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; }
            h1 { text-align: center; color: #333; }
            table { width: 100%; border-collapse: collapse; margin-top: 20px; }
            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            th { background-color: #f4f4f4; };
            tbody, thead{ display: inline-block ;}

            
            .codigo{ width: 15%;}
            .cliente{width: 40%;}
            .equipamento{width: 25%;}
            .dt_abertura{width: 20%;}
        </style>
    </head>
    <body>
        <h1>Listagem de Aberturas</h1>
        <table>
            <thead>
                <tr>
                    <th class="codigo">Código</th>
                    <th class="cliente">Cliente</th>
                    <th class="equipamento">Equipamento</th>
                    <th class="dt_abertura">Data Abertura</th>

                </tr>
            </thead>
            <tbody>
                ${dados.map(d => `
                    <tr>
                        <td class="codigo">${d.codigo}</td>
                        <td class="cliente">${d.cliente}</td>
                        <td class="equipamento">${d.equipamento}</td>
                        <td class="dt_abertura">${d.dt_abertura}</td>
                    </tr>
                    <tr class="descricao">
                        <td colspan="4" class="descricao"><strong>Descrição: </strong>${d.descricao}</td>
                    </tr>
                `).join('')}
            </tbody>
        </table>
    </body>
    </html>
`;