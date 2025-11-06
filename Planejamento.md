# Switch Dreams Challenge - Fit Dreams API

Este repositório contém a minha solução para o desafio de backend da **Switch Dreams**, onde criei uma API RESTful para gerenciar as aulas da academia Fit Dreams.

Desenvolvi a aplicação utilizando Ruby on Rails no modo API, com foco em boas práticas, código limpo e organização.

**URL da API (Deploy):** https://backend-challange-49e1fdfd811c.herokuapp.com  
**Dashboard Heroku:** https://dashboard.heroku.com/apps/backend-challange

> **Nota importante:** No momento, não há banco de dados provisionado no Heroku (camada gratuita do Postgres indisponível). Endpoints que dependem de banco (signup/login/CRUD) não funcionam em produção até configurar um banco externo ou add-on pago. Para testes, utilize o ambiente local.

---

## 📋 Índice

* [Tecnologias Utilizadas](#-tecnologias-utilizadas)
* [Funcionalidades](#-funcionalidades)
* [Estrutura da API](#-estrutura-da-api)
* [Como Executar o Projeto](#-como-executar-o-projeto)
* [Variáveis de Ambiente](#-variáveis-de-ambiente)
* [Usando a API em Produção (Heroku)](#-usando-a-api-em-produção-heroku)
* [Planejamento e Desenvolvimento](#-planejamento-e-desenvolvimento)

---

## ✨ Tecnologias Utilizadas

* **Ruby:** 3.2.3
* **Ruby on Rails:** 7.x (API-only)
* **Banco de Dados:** PostgreSQL
* **Autenticação:** JWT (JSON Web Tokens)
* **Autorização:** Pundit
* **Testes:** RSpec
* **Linter:** Rubocop
* **Segurança:** Rack-CORS, Rack-Attack (rate limiting)

---

## 🚀 Funcionalidades

- [x] **Gerenciamento de Usuários:** Cadastro e autenticação de usuários com três perfis (roles): `aluno`, `professor` e `admin`.
- [x] **Autenticação Segura:** Sistema de login via endpoint `/login` que retorna um token JWT.
- [x] **Controle de Acesso por Perfil:**
    * **Admins e Professores:** Podem criar, editar e deletar Categorias e Aulas.
    * **Alunos:** Podem visualizar Categorias e Aulas, e se matricular nelas.
- [x] **Gerenciamento de Categorias:** CRUD completo para organizar as aulas.
- [x] **Gerenciamento de Aulas:** CRUD completo, com cada aula associada a uma categoria.
- [x] **Sistema de Matrículas:** Alunos podem se matricular em múltiplas aulas, e uma aula pode ter múltiplos alunos.
- [x] **Paginação e Filtros:** Endpoints de listagem com suporte a paginação e filtros (ex.: aulas por categoria e data).
- [x] **Rate Limiting:** Proteção contra abuso com limites de requisições por IP.
- [x] **CORS Configurável:** Controle de origens permitidas via variável de ambiente.

---

## 🌐 Estrutura da API

Versionei a API para garantir manutenibilidade. A estrutura base dos endpoints é:

`http://localhost:3000/api/v1/...` (local)  
`https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/...` (produção)

### Endpoints Principais:

| Método | Rota                       | Descrição                                 | Acesso                    |
| :----- | :------------------------- | :---------------------------------------- | :------------------------ |
| `POST` | `/api/v1/signup`           | Registra um novo usuário (padrão: aluno). | Público                   |
| `POST` | `/api/v1/login`            | Autentica um usuário e retorna um token.  | Público                   |
| `GET`  | `/api/v1/me`               | Retorna informações do usuário logado.    | Autenticado               |
| `GET`  | `/api/v1/categories`       | Lista todas as categorias.                | Autenticado               |
| `POST` | `/api/v1/categories`       | Cria uma nova categoria.                  | Admin / Professor         |
| `GET`  | `/api/v1/categories/:id`   | Exibe uma categoria específica.           | Autenticado               |
| `PATCH`| `/api/v1/categories/:id`   | Atualiza uma categoria.                   | Admin / Professor         |
| `DELETE`| `/api/v1/categories/:id`  | Remove uma categoria.                     | Admin / Professor         |
| `GET`  | `/api/v1/aulas`            | Lista todas as aulas (com filtros).       | Autenticado               |
| `POST` | `/api/v1/aulas`            | Cria uma nova aula.                       | Admin / Professor         |
| `GET`  | `/api/v1/aulas/:id`        | Exibe uma aula específica.                | Autenticado               |
| `PATCH`| `/api/v1/aulas/:id`        | Atualiza uma aula.                        | Admin / Professor         |
| `DELETE`| `/api/v1/aulas/:id`       | Remove uma aula.                          | Admin / Professor         |
| `POST` | `/api/v1/aulas/:id/enroll` | Matricula o usuário logado na aula.       | Aluno                     |

### Padrão de Respostas

**Sucesso:**
```json
{
  "data": { ... }
}
```

**Erro:**
```json
{
  "errors": ["mensagem de erro"]
}
```

**Listagens com Paginação:**
```json
{
  "data": [ ... ],
  "meta": {
    "pagination": {
      "current_page": 1,
      "per_page": 10,
      "total_pages": 5,
      "total_count": 42
    }
  }
}
```

---

## 💻 Como Executar o Projeto

Estes são os passos para configurar e rodar a aplicação em um ambiente local.

### Pré-requisitos

* Ruby 3.2.3
* Bundler (`gem install bundler`)
* PostgreSQL rodando

### Passos

1.  **Clone o repositório:**
    ```bash
    git clone git@github.com:GabD-S/back-end-challenge.git
    cd back-end-challenge
    git checkout feat/api
    ```

2.  **Instale as dependências:**
    ```bash
    bundle install
    ```

3.  **Configure o banco de dados:**
    * Certifique-se de que seu PostgreSQL está rodando.
    * O arquivo `config/database.yml` já aponta para os bancos locais `fit_dreams_api_development` e `fit_dreams_api_test`.
    * Ajuste usuário/senha/host se necessário.

4.  **Crie e prepare o banco de dados:**
    ```bash
    bundle exec rails db:prepare
    bundle exec rails db:seed          # opcional: dados de exemplo
    bundle exec rails bootstrap:setup  # opcional: cria admin/professor/aluno + categorias
    ```

5.  **Execute o servidor:**
    ```bash
    bundle exec rails s
    ```
    A API estará disponível em `http://localhost:3000`.

6.  **Execute os testes:**
    ```bash
    bundle exec rspec
    ```

### Exemplos de Uso (curl)

**Signup:**
```bash
curl -s -X POST http://localhost:3000/api/v1/signup \
  -H 'Content-Type: application/json' \
  -d '{
    "user": {
      "name": "Alice",
      "email": "alice@example.com",
      "password": "Password!23",
      "password_confirmation": "Password!23"
    }
  }'
```

**Login (obter token):**
```bash
curl -s -X POST http://localhost:3000/api/v1/login \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "admin@example.com",
    "password": "Password!23"
  }'
```

**Usar token (exemplo /me):**
```bash
TOKEN="<cole-o-token-aqui>"
curl -s http://localhost:3000/api/v1/me \
  -H "Authorization: Bearer $TOKEN"
```

**Listar categorias:**
```bash
curl -s http://localhost:3000/api/v1/categories \
  -H "Authorization: Bearer $TOKEN"
```

**Criar categoria (admin/professor):**
```bash
curl -s -X POST http://localhost:3000/api/v1/categories \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "category": {
      "name": "Cardio",
      "description": "Aulas de alta intensidade"
    }
  }'
```

**Listar aulas com filtros:**
```bash
curl -s "http://localhost:3000/api/v1/aulas?page=1&per_page=10&category_id=1" \
  -H "Authorization: Bearer $TOKEN"
```

---

## 🔐 Variáveis de Ambiente

### Obrigatórias
* `SECRET_KEY_BASE` ou `RAILS_MASTER_KEY`: Chave secreta para JWT e criptografia do Rails
* `DATABASE_URL`: URL de conexão com PostgreSQL (produção)

### Opcionais
* `JWT_EXP`: Tempo de expiração do token JWT em horas (padrão: 24)
* `ALLOWED_ORIGINS`: Lista de origens permitidas para CORS, separadas por vírgula (padrão: `*`)
* `RACK_ATTACK_REQ_LIMIT_PER_MIN`: Limite de requisições por minuto por IP (padrão: 60)
* `RACK_ATTACK_LOGIN_LIMIT`: Limite de tentativas de login a cada 20s por IP (padrão: 5)
* `RACK_ATTACK_SIGNUP_LIMIT`: Limite de cadastros por minuto por IP (padrão: 5)

### Bootstrap (usuários padrão)
* `ADMIN_EMAIL`, `ADMIN_PASSWORD`
* `PROFESSOR_EMAIL`, `PROFESSOR_PASSWORD`
* `ALUNO_EMAIL`, `ALUNO_PASSWORD`

---

## 🌍 Usando a API em Produção (Heroku)

Base da API: https://backend-challange-49e1fdfd811c.herokuapp.com

### Status Atual

**Sem banco configurado no Heroku** - apenas verificações simples funcionam. Para usar login/signup/CRUD é necessário configurar um Postgres.

**Teste rápido (validar servidor):**
```bash
# Deve retornar 404 (servidor funcionando)
curl -i https://backend-challange-49e1fdfd811c.herokuapp.com/

# Rota protegida sem token (retorna 401)
curl -i https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/me
```

### Habilitar Banco de Dados

**Opção A: Postgres externo gratuito** (ex.: Neon, ElephantSQL)
1. Criar database e obter URL de conexão
2. Definir no Heroku:
```bash
heroku config:set DATABASE_URL="postgres://USER:PASSWORD@HOST:PORT/DBNAME" -a backend-challange-49e1fdfd811c
```
3. Rodar migrations:
```bash
heroku run rails db:migrate -a backend-challange-49e1fdfd811c
```
4. (Opcional) Popular dados:
```bash
heroku run rails bootstrap:setup -a backend-challange-49e1fdfd811c
```

**Opção B: Postgres do Heroku** (pago)
1. Provisionar add-on Postgres (automaticamente define `DATABASE_URL`)
2. Seguir passos 3 e 4 acima

### Usuários Padrão (após bootstrap)
* **Admin:** `admin@example.com` / `Password!23`
* **Professor:** `prof@example.com` / `Password!23`
* **Aluno:** `aluno@example.com` / `Password!23`

### Exemplos de Chamadas em Produção

**Login:**
```bash
curl -s -X POST \
  https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"admin@example.com","password":"Password!23"}'
```

**Usar token:**
```bash
TOKEN="<cole-o-token-aqui>"

# Meu usuário logado
curl -s https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/me \
  -H "Authorization: Bearer $TOKEN"

# Listar categorias
curl -s https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/categories \
  -H "Authorization: Bearer $TOKEN"
```

**Criar categoria (professor/admin):**
```bash
curl -s -X POST \
  https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/categories \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"category": {"name":"Cardio","description":"Aulas de alta intensidade"}}'
```

**Filtros e paginação:**
```bash
curl -s "https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/aulas?page=1&per_page=10" \
  -H "Authorization: Bearer $TOKEN"
```

---

## ✅ Planejamento e Desenvolvimento

O projeto foi desenvolvido seguindo um planejamento estruturado em fases:

### Fase 0: Configuração do Ambiente ✅
- [x] Iniciei o projeto Rails 7 em modo API com PostgreSQL
- [x] Configurei o repositório Git e fiz o primeiro push no GitHub
- [x] Criei o banco de dados local com `rails db:create`
- [x] Adicionei e configurei `rspec-rails` e `rubocop`

### Fase 1: Modelagem de Dados e Migrations ✅
- [x] Gerei o model `User` (name, birth_date, email, password_digest, role)
- [x] Gerei o model `Category` (name, description)
- [x] Gerei o model `Aula` (name, start_time, duration, teacher_name, description, category)
- [x] Gerei o model de junção `Enrollment` (user, aula)
- [x] Executei `rails db:migrate`

### Fase 2: Configurar Models (Validações e Associações) ✅
- [x] Implementei `has_secure_password`, enum role e associações no `User`
- [x] Configurei associações e validações no `Aula`
- [x] Adicionei validação de unicidade no `Enrollment`
- [x] Introduzi `FactoryBot` e `Faker` para testes
- [x] Adicionei validação e normalização de e-mail
- [x] Criei seeds com dados exemplo

### Fase 3: Autenticação (JWT) ✅
- [x] Adicionei a gem `jwt`
- [x] Criei serviço `JsonWebToken` para encode/decode
- [x] Criei `AuthenticationController` com login
- [x] Configurei `before_action` no `ApplicationController` para verificação de token
- [x] Implementei request specs para autenticação

### Fase 4: Autorização (Pundit) ✅
- [x] Instalei e configurei Pundit
- [x] Implementei `CategoryPolicy` e `AulaPolicy`
- [x] Protegi controllers com autorização adequada
- [x] Padronizei respostas JSON com status adequados
- [x] Cobri autorização com request specs

### Fase 5: API Endpoints (Controllers e Rotas) ✅
- [x] Estruturei rotas em `namespace :api, :v1`
- [x] Criei `UsersController` para signup
- [x] Completei CRUD de `CategoriesController`
- [x] Completei CRUD de `AulasController` + endpoint de matrícula
- [x] Implementei endpoint `/api/v1/me`

### Fase 6: Testes e Documentação ✅
- [x] Request specs para todos os endpoints principais
- [x] Cobertura de casos de sucesso e erro (401, 403, 422)
- [x] Criei coleção Postman para documentação
- [x] Documentei exemplos de uso em curl

### Fase 6.5: Preparação para Deploy ✅
- [x] Configurei CORS via `rack-cors`
- [x] Implementei rate limiting com `rack-attack`
- [x] Adicionei paginação e filtros nos endpoints de listagem
- [x] Criei tarefa Rake de bootstrap para dados iniciais
- [x] Garanti índices e constraints no banco
- [x] Adicionei `Procfile` para Heroku

### Fase 7: Deploy ✅
- [x] Criei aplicação no Heroku
- [x] Deploy da branch `main` para o Heroku
- [x] Documentei processo de configuração de banco externo
- [x] Atualizei README com URL da API e instruções

---

## 📚 Recursos Adicionais

* **Documentação Postman:** Coleção disponível em `postman/fit_dreams_api.postman_collection.json`
* **Testes Automatizados:** Execute `bundle exec rspec` para rodar toda a suite de testes
* **Linter:** Execute `bundle exec rubocop` para verificar o código



**Desenvolvido como parte do desafio técnico da Switch Dreams**