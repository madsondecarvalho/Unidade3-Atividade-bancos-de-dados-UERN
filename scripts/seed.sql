BEGIN;

DO $$
DECLARE
    -- IDs para Endereços
    addr_id_1 UUID := uuid_generate_v4();
    addr_id_2 UUID := uuid_generate_v4();
    addr_id_3 UUID := uuid_generate_v4();
    
    -- IDs para Pessoas
    pessoa_id_1 UUID := uuid_generate_v4();
    pessoa_id_2 UUID := uuid_generate_v4();
    pessoa_id_3 UUID := uuid_generate_v4();
    
    -- IDs para Pets
    pet_id_1 UUID := uuid_generate_v4();
    pet_id_2 UUID := uuid_generate_v4();
    pet_id_3 UUID := uuid_generate_v4();
    pet_id_4 UUID := uuid_generate_v4();
    pet_id_5 UUID := uuid_generate_v4();
    pet_id_6 UUID := uuid_generate_v4();
    pet_id_7 UUID := uuid_generate_v4();
    pet_id_8 UUID := uuid_generate_v4();
    pet_id_9 UUID := uuid_generate_v4();
    pet_id_10 UUID := uuid_generate_v4();

BEGIN
    
    -- 1. INSERIR ENDEREÇOS
    RAISE NOTICE 'Inserindo endereços...';
    INSERT INTO enderecos (id, logradouro, numero, bairro, municipio, cep, estado) VALUES
    (addr_id_1, 'Rua das Flores', 123, 'Centro', 'São Paulo', '01000-000', 'SP'),
    (addr_id_2, 'Avenida Principal', 456, 'Tijuca', 'Rio de Janeiro', '20510-000', 'RJ'),
    (addr_id_3, 'Praça da Savassi', 789, 'Savassi', 'Belo Horizonte', '30110-000', 'MG');

    -- 2. INSERIR 3 PESSOAS
    RAISE NOTICE 'Inserindo pessoas...';
    INSERT INTO pessoas (id, nome, email, telefone, data_nascimento, endereco_id) VALUES
    (pessoa_id_1, 'Ana Silva', 'ana.silva@email.com', '11911112222', '1990-05-15', addr_id_1),
    (pessoa_id_2, 'Bruno Costa', 'bruno.costa@email.com', '21922223333', '1985-08-20', addr_id_2),
    (pessoa_id_3, 'Carla Dias', 'carla.dias@email.com', '31933334444', '1995-02-10', addr_id_3);

    -- 3. INSERIR 10 PETS
    RAISE NOTICE 'Inserindo pets...';
    INSERT INTO pets (id, nome, data_nascimento, sexo, raca, observacoes) VALUES
    (pet_id_1, 'Rex', '2022-01-10', 'MASCULINO', 'CACHORRO', 'Dócil e brincalhão'),
    (pet_id_2, 'Mia', '2023-03-15', 'FEMININO', 'GATO', 'Calma e gosta de dormir'),
    (pet_id_3, 'Thor', '2021-11-05', 'MASCULINO', 'CACHORRO', 'Muito enérgico'),
    (pet_id_4, 'Luna', '2022-07-20', 'FEMININO', 'CACHORRO', 'Adora passear'),
    (pet_id_5, 'Simba', '2023-01-30', 'MASCULINO', 'GATO', 'Curioso'),
    (pet_id_6, 'Bella', '2020-05-01', 'FEMININO', 'CACHORRO', 'Precisa de dieta especial'),
    (pet_id_7, 'Oliver', '2023-06-10', 'MASCULINO', 'GATO', 'Muito carinhoso'),
    (pet_id_8, 'Max', '2019-02-14', 'MASCULINO', 'CACHORRO', 'Idoso e tranquilo'),
    (pet_id_9, 'Nina', '2023-08-01', 'FEMININO', 'GATO', 'Filhote, ainda assustada'),
    (pet_id_10, 'Zeus', '2022-04-04', 'MASCULINO', 'CACHORRO', 'Adora buscar a bolinha');

    -- 4. FAZER 2 ADOÇÕES
    RAISE NOTICE 'Inserindo adoções...';
    -- Ana (pessoa_id_1) adota Rex (pet_id_1)
    INSERT INTO adocoes (pessoa_id, pet_id, data_adocao) VALUES (pessoa_id_1, pet_id_1, '2024-10-01');
    -- Bruno (pessoa_id_2) adota Mia e Thor (pet_id_2)
    INSERT INTO adocoes (pessoa_id, pet_id, data_adocao) VALUES (pessoa_id_2, pet_id_2, '2024-10-05');
    INSERT INTO adocoes (pessoa_id, pet_id, data_adocao) VALUES (pessoa_id_2, pet_id_3, '2024-10-05');


    -- 5. EDITAR UM USUÁRIO (Pessoa)
    RAISE NOTICE 'Atualizando pessoa...';
    UPDATE pessoas
    SET nome = 'Ana Silva Souza'
    WHERE id = pessoa_id_1;

    -- 6. REMOVER UM PET (um que não foi adotado)
    RAISE NOTICE 'Removendo pet...';
    DELETE FROM pets
    WHERE id = pet_id_10; -- Remove o 'Zeus'
    
    RAISE NOTICE 'Carga de dados (seed) concluída.';

END $$;

-- Finaliza a transação
COMMIT;
