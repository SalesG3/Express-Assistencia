const puppeteer = require('puppeteer');

// Dados simulados (podem vir de uma API ou banco de dados)
const getDados = async () => [
    { nome: 'João', idade: 28, email: 'joao@email.com' },
    { nome: 'Maria', idade: 34, email: 'maria@email.com' },
    { nome: 'Carlos', idade: 23, email: 'carlos@email.com' }
];

// Gera o HTML do relatório
const gerarHTML = (dados) => `
    <html>
    <head>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; }
            h1 { text-align: center; color: #333; }
            table { width: 100%; border-collapse: collapse; margin-top: 20px; }
            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            th { background-color: #f4f4f4; }
        </style>
    </head>
    <body>
        <h1>Relatório Dinâmico</h1>
        <table>
            <thead>
                <tr>
                    <th>Nome</th>
                    <th>Idade</th>
                    <th>Email</th>
                </tr>
            </thead>
            <tbody>
                ${dados.map(d => `
                    <tr>
                        <td>${d.nome}</td>
                        <td>${d.idade}</td>
                        <td>${d.email}</td>
                    </tr>
                `).join('')}
            </tbody>
        </table>
    </body>
    </html>
`;

(async () => {
    // Inicializa o Puppeteer
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    // Obtém os dados dinâmicos
    const dados = await getDados();

    // Gera o conteúdo HTML
    const html = gerarHTML(dados);

    // Define o conteúdo da página
    await page.setContent(html);

    // Gera o PDF
    await page.pdf({ path: 'relatorio_dinamico.pdf', format: 'A4' });

    // Fecha o navegador
    await browser.close();

    console.log('Relatório gerado com sucesso!');
})();