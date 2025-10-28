-- Inicia uma transação.
-- Isso garante que, se qualquer parte do script falhar,
-- todas as alterações serão revertidas.
BEGIN;

-- 1. HABILITAR EXTENSÃO (se ainda não estiver habilitada)
-- Precisamos disso para a função uuid_generate_v4()
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. CRIAR TIPOS ENUM CUSTOMIZADOS
-- Isso garante que apenas os valores permitidos entrem nas colunas 'sexo' e 'raca'
CREATE TYPE enum_sexo AS ENUM ('FEMININO', 'MASCULINO');
CREATE TYPE enum_raca AS ENUM ('CACHORRO', 'GATO');

-- 3. CRIAR TABELAS (em ordem de dependência)

-- Tabela 'enderecos' (não depende de ninguém)
-- Usei o plural 'enderecos' como convenção
CREATE TABLE enderecos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    logradouro TEXT,
    numero INT,
    bairro TEXT,
    municipio TEXT,
    cep TEXT,
    estado TEXT
);

-- Tabela 'pets' (não depende de ninguém)
-- Usei o plural 'pets' como convenção
CREATE TABLE pets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome TEXT,
    data_nascimento DATE,
    sexo enum_sexo,
    raca enum_raca,
    observacoes TEXT
);

-- Tabela 'pessoas' (depende de 'enderecos')
-- Usei o plural 'pessoas' como convenção
CREATE TABLE pessoas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    telefone TEXT NOT NULL UNIQUE,
    data_nascimento DATE,
    
    -- Chave estrangeira para a tabela 'enderecos'
    endereco_id UUID,
    
    CONSTRAINT fk_endereco
        FOREIGN KEY(endereco_id) 
        REFERENCES enderecos(id)
        ON DELETE SET NULL -- Se um endereço for apagado, o campo 'endereco_id' ficará nulo
);

-- Tabela 'adocoes' (depende de 'pessoas' e 'pets')
-- Esta é uma tabela de junção (many-to-many)
CREATE TABLE adocoes (
    -- Chave estrangeira para 'pessoas'
    pessoa_id UUID,
    
    -- Chave estrangeira para 'pets'
    pet_id UUID,
    
    data_adocao DATE,
    
    -- Chave primária composta: impede que a mesma pessoa adote o mesmo pet duas vezes
    PRIMARY KEY (pessoa_id, pet_id),
    
    CONSTRAINT fk_pessoa
        FOREIGN KEY(pessoa_id)
        REFERENCES pessoas(id)
        ON DELETE CASCADE, -- Se a pessoa for deletada, o registro de adoção também será
        
    CONSTRAINT fk_pet
        FOREIGN KEY(pet_id)
        REFERENCES pets(id)
        ON DELETE CASCADE -- Se o pet for deletado, o registro de adoção também será
);

-- Finaliza e confirma a transação
COMMIT;
