-- 1. Relatório de Adoções (Pessoas e Pets)
-- Lista todas as pessoas, mesmo as que não adotaram,
-- e os pets que elas adotaram.
SELECT
    p.nome AS nome_pessoa,
    p.email AS email_pessoa,
    a.data_adocao,
    pt.nome AS nome_pet,
    pt.raca AS raca_pet
FROM
    pessoas p
LEFT JOIN -- Usamos LEFT JOIN para incluir pessoas que ainda não adotaram
    adocoes a ON p.id = a.pessoa_id
LEFT JOIN
    pets pt ON a.pet_id = pt.id;


-- 2. Buscar Pessoa por ID e trazer seu Endereço
-- Busca uma pessoa específica pelo seu UUID e junta
-- os dados do seu endereço.
SELECT
    p.nome AS nome_pessoa,
    p.email,
    p.telefone,
    p.data_nascimento,
    e.logradouro,
    e.numero,
    e.bairro,
    e.municipio,
    e.cep,
    e.estado
FROM
    pessoas p
LEFT JOIN -- Usamos LEFT JOIN caso a pessoa não tenha um endereço cadastrado
    enderecos e ON p.endereco_id = e.id
WHERE
    p.id = 'INSIRA_O_UUID_DA_PESSOA_AQUI'; -- Ex: 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'
