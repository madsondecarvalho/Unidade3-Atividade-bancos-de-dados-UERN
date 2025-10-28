# Sistema de Adoção de Pets - Scripts de Banco de Dados

Este projeto contém scripts SQL para configurar um banco de dados PostgreSQL destinado a gerenciar um sistema de adoção de pets. O banco é executado através do Docker Compose.

## Estrutura do Projeto

```
├── docker-compose.yaml     # Configuração do container PostgreSQL
└── scripts/
    ├── init-database.sql   # Script de criação da estrutura do banco
    ├── seed.sql           # Script de carga inicial de dados de teste
    └── querys.sql         # Consultas SQL de exemplo
```

## Descrição dos Scripts

### 1. `init-database.sql`
**Objetivo:** Criar a estrutura completa do banco de dados.

**Funcionalidades:**
- Habilita a extensão `uuid-ossp` para gerar UUIDs automaticamente
- Cria tipos ENUM personalizados:
  - `enum_sexo`: valores permitidos ('FEMININO', 'MASCULINO')
  - `enum_raca`: valores permitidos ('CACHORRO', 'GATO')
- Cria as seguintes tabelas:
  - **`enderecos`**: Armazena informações de endereços
  - **`pets`**: Dados dos animais disponíveis para adoção
  - **`pessoas`**: Informações dos potenciais adotantes
  - **`adocoes`**: Tabela de relacionamento entre pessoas e pets (many-to-many)

**Características técnicas:**
- Utiliza UUIDs como chaves primárias
- Implementa chaves estrangeiras com políticas de deleção apropriadas
- Transação controlada (BEGIN/COMMIT) para garantir integridade

### 2. `seed.sql`
**Objetivo:** Popular o banco com dados de teste para desenvolvimento e demonstração.

**Conteúdo inserido:**
- **3 endereços** em diferentes cidades (São Paulo, Rio de Janeiro, Belo Horizonte)
- **3 pessoas** com dados completos (nome, email, telefone, data de nascimento)
- **10 pets** diversos (cachorros e gatos, com diferentes características)
- **3 adoções** de exemplo
- Demonstra operações CRUD:
  - Atualização de dados de uma pessoa
  - Remoção de um pet não adotado

**Características técnicas:**
- Usa bloco PL/pgSQL (DO $$) para maior controle
- Gera UUIDs únicos para cada registro
- Inclui mensagens de progresso (RAISE NOTICE)
- Transação controlada para garantir consistência

### 3. `querys.sql`
**Objetivo:** Fornecer consultas SQL de exemplo para interagir com o banco.

**Consultas disponíveis:**

#### Consulta 1: Relatório de Adoções
```sql
-- Lista todas as pessoas e os pets que adotaram
-- Inclui pessoas que ainda não adotaram nenhum pet
```
- Utiliza LEFT JOIN para incluir pessoas sem adoções
- Mostra nome da pessoa, email, data da adoção e dados do pet

#### Consulta 2: Buscar Pessoa por ID com Endereço
```sql
-- Busca uma pessoa específica e seus dados de endereço
-- Requer substituição do UUID na cláusula WHERE
```
- Demonstra junção entre tabelas pessoas e endereços
- Exemplo de consulta parametrizada

## Como Usar

### Pré-requisitos
- Docker
- Docker Compose

### Executando o Sistema

1. **Iniciar o banco de dados:**
```bash
docker-compose up -d
```

2. **Conectar ao banco:**
```bash
docker exec -it adocao_postgres psql -U root -d adocao_db
```

3. **Executar consultas:**
- Os scripts `init-database.sql` e `seed.sql` são executados automaticamente
- Use as consultas em `querys.sql` como referência

### Configuração do Banco
- **Host:** localhost
- **Porta:** 5432
- **Usuário:** root
- **Senha:** root
- **Banco:** adocao_db

## Modelo de Dados

O sistema implementa as seguintes entidades e relacionamentos:

- **Endereços** (1) ←→ (N) **Pessoas**
- **Pessoas** (N) ←→ (N) **Pets** através da tabela **Adoções**

### Características do Modelo:
- Uma pessoa pode ter um endereço (opcional)
- Uma pessoa pode adotar múltiplos pets
- Um pet pode ser adotado por apenas uma pessoa
- Suporte a rastreamento de data de adoção

## Desenvolvimento

Para modificar ou estender o sistema:

1. **Alterações na estrutura:** Modifique `init-database.sql`
2. **Novos dados de teste:** Atualize `seed.sql`
3. **Novas consultas:** Adicione em `querys.sql`

Lembre-se de recriar o container após mudanças estruturais:
```bash
docker-compose down
docker volume rm adocao_postgres_data
docker-compose up -d
```

## Notas Importantes

- Os dados são persistidos através de um volume Docker (`postgres_data`)
- O sistema usa UUIDs para garantir unicidade em ambientes distribuídos
- As chaves estrangeiras implementam políticas de deleção adequadas para manter integridade referencial
- Todos os scripts são executados em transações para garantir consistência