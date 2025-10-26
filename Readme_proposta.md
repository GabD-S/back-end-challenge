# Switch Dreams Challenge - Fit Dreams API

Este repositório contém a minha solução para o desafio de backend da **Switch Dreams**, onde criei uma API RESTful para gerenciar as aulas da academia Fit Dreams.

Desenvolvi a aplicação utilizando Ruby on Rails no modo API, com foco em boas práticas, código limpo e organização.

**URL da API (Deploy):** https://backend-challange-49e1fdfd811c.herokuapp.com

---

## 📋 Índice

* [Tecnologias Utilizadas](#-tecnologias-utilizadas)
* [Funcionalidades](#-funcionalidades)
* [Estrutura da API](#-estrutura-da-api)
* [Como Executar o Projeto](#-como-executar-o-projeto)
* [Plano de Ações e Desenvolvimento](#-plano-de-ações-e-desenvolvimento)

---

## ✨ Tecnologias Utilizadas

* **Ruby:** 3.x
* **Ruby on Rails:** 7.x (API-only)
* **Banco de Dados:** PostgreSQL
* **Autenticação:** JWT (JSON Web Tokens)
* **Autorização:** Pundit
* **Testes (Diferencial):** RSpec
* **Linter (Diferencial):** Rubocop

---

## 🚀 Funcionalidades

* [ ] **Gerenciamento de Usuários:** Cadastro e autenticação de usuários com três perfis (roles): `aluno`, `professor` e `admin`.
* [ ] **Autenticação Segura:** Sistema de login via endpoint `/login` que retorna um token JWT.
* [ ] **Controle de Acesso por Perfil:**
    * **Admins e Professores:** Podem criar, editar e deletar Categorias e Aulas.
    * **Alunos:** Podem visualizar Categorias e Aulas, e se matricular nelas.
* [ ] **Gerenciamento de Categorias:** CRUD completo para organizar as aulas.
* [ ] **Gerenciamento de Aulas:** CRUD completo, com cada aula associada a uma categoria.
* [ ] **Sistema de Matrículas:** Alunos podem se matricular em múltiplas aulas, e uma aula pode ter múltiplos alunos.

---

## 🌐 Como estruturei a API

Versionei a API para garantir manutenibilidade. A estrutura base dos endpoints é:

`http://localhost:3000/api/v1/...`

### Endpoints Principais:

| Método | Rota                  | Descrição                                 | Acesso                    |
| :----- | :-------------------- | :---------------------------------------- | :------------------------ |
| `POST` | `/api/v1/signup`      | Registra um novo usuário (padrão: aluno). | Público                   |
| `POST` | `/api/v1/login`       | Autentica um usuário e retorna um token.  | Público                   |
| `GET`  | `/api/v1/categories`  | Lista todas as categorias.                | Autenticado               |
| `POST` | `/api/v1/categories`  | Cria uma nova categoria.                  | Admin / Professor         |
| `GET`  | `/api/v1/aulas`       | Lista todas as aulas.                     | Autenticado               |
| `POST` | `/api/v1/aulas`       | Cria uma nova aula.                       | Admin / Professor         |
| `POST` | `/api/v1/aulas/:id/enroll` | Matricula o usuário logado na aula.    | Aluno                     |
| ...    | ...                   | Outros endpoints de `show`, `update`, `delete`. | Conforme a regra de perfil|

*A documentação completa dos endpoints será feita utilizando **Postman/Insomnia** ou através dos testes de requisição do **RSpec**.*

---

## 💻 Como eu executo o projeto

Estes são os passos que sigo para configurar e rodar a aplicação em um ambiente local.

### Meus pré-requisitos

* Ruby (versão 3.x)
* Bundler (`gem install bundler`)
* PostgreSQL

### Passos que eu sigo

1.  **Eu clono o repositório:**
    ```bash
    git clone [https://github.com/seu-usuario/switch_dreams_api.git](https://github.com/seu-usuario/switch_dreams_api.git)
    cd switch_dreams_api
    ```

2.  **Eu instalo as dependências:**
    ```bash
    bundle install
    ```

3.  **Eu configuro o banco de dados:**
    * Certifique-se de que seu PostgreSQL está rodando.
    * Se necessário, ajuste o arquivo `config/database.yml` com suas credenciais.
    * Crie e prepare o banco de dados:
    ```bash
    rails db:create
    rails db:migrate
    ```

4.  **Eu executo o servidor:**
    ```bash
    rails server
    ```
    A API estará disponível em `http://localhost:3000`.

5.  **(Opcional) Eu executo os testes:**
    ```bash
    rspec
    ```

---

## ✅ Meu plano de ações e desenvolvimento

Este é o checklist que guiará o desenvolvimento do projeto, dividido em fases para melhor organização.

### Fase 0: Configuração do Ambiente
- [x] Iniciei o projeto Rails 7 em modo API com PostgreSQL (`rails new ...`).
    - 20/10/2025: Gerei o app Rails 7.2.2.2 (API-only) na pasta `fit_dreams_api/` com `--database=postgresql`. Configurei o Bundler para `vendor/bundle` e removi o `.git` interno criado pelo `rails new` para evitar repositório aninhado.
- [x] Configurei o repositório Git e fiz o primeiro push no GitHub.
    - 20/10/2025: Configurei o remoto via SSH. Criei branches de trabalho e realizei o push da Fase 0 na branch `feat/rails-setup`.
- [x] Criei o banco de dados local com `rails db:create`.
    - 20/10/2025: Ajustei o usuário do PostgreSQL e criei os bancos `fit_dreams_api_development` e `fit_dreams_api_test` com `bin/rails db:create`.
- [x] (Diferencial) Adicionei e configurei as gems `rspec-rails` e `rubocop`.
    - 20/10/2025: Adicionei `rspec-rails (~> 6.1)` e executei `rails generate rspec:install` (criei `.rspec`, `spec/spec_helper.rb` e `spec/rails_helper.rb`). Adicionei `rubocop-rails-omakase` e rodei o RuboCop para corrigir trailing blank lines no `Gemfile` (commit "chore(lint)").
    - Extra: Rodei o Brakeman (baseline de segurança) sem alertas.

### Fase 1: Modelagem de Dados e Migrations
- [x] Gerei o model `User` (`name`, `birth_date`, `email`, `password_digest`, `role`).
    - 21/10/2025: Criei `User` com migração reforçada: `name/email/password_digest` com `null: false`, `role` com `default: 0` (aluno) e índice único em `email`.
- [x] Gerei o model `Category` (`name`, `description`).
    - 21/10/2025: Criei `Category` com `name` obrigatório e índice em `name`.
- [x] Gerei o model `Aula` (`name`, `start_time`, `duration`, `teacher_name`, `description`, `category:references`).
    - 21/10/2025: Criei `Aula` com campos obrigatórios, `category` como FK e índice em `start_time`.
- [x] Gerei o model de junção `Enrollment` (`user:references`, `aula:references`).
    - 21/10/2025: Criei `Enrollment` com FKs e índice único composto em `[user_id, aula_id]`.
- [x] Executei `rails db:migrate`.
    - 21/10/2025: Apliquei as migrations com sucesso; `db/schema.rb` atualizado.

### Fase 2: Configurar Models (Validações e Associações)
- [x] Em `User`, adicionei `has_secure_password`, `enum role`, e as associações `has_many :aulas, through: :enrollments`.
    - 21/10/2025: Implementei `has_secure_password`, `enum :role` (aluno/professor/admin), `has_many :enrollments` (com `dependent: :destroy`) e `has_many :aulas, through: :enrollments`. Validei presença (name, email) e unicidade (email).
- [x] Em `Aula`, adicionei as associações `belongs_to :category` e `has_many :alunos, through: :enrollments`.
    - 21/10/2025: Implementei `belongs_to :category`, `has_many :enrollments` (com `dependent: :destroy`) e `has_many :alunos, through: :enrollments, source: :user`. Validei presença (name, start_time, duration, teacher_name, category) e que `duration` é inteiro > 0.
- [x] Em `Enrollment`, adicionei validação de unicidade para o par `user_id` e `aula_id`.
    - 21/10/2025: Adicionei validação de unicidade de `user_id` com escopo em `aula_id` (além do índice único na migration).
- [x] Adicionei validações de presença (`presence: true`) e formato nos campos necessários.
    - 21/10/2025: Apliquei presença conforme descrito acima. Deixei a validação de formato de e-mail como melhoria complementar (e depois implementei).

> Observação: Usei exemplos simples e apenas coloquei nomes aleatórios; ainda falta colocar links para usuário preencher nomes e criar e-mails por si só.

Observações desta etapa:
- Adicionei `FactoryBot` e `Faker` para gerar dados realistas em testes e seeds.
- Implementei normalização de e-mail (downcase + strip) e validação de formato; apliquei unicidade case-insensitive na validação e no banco (índice único em `LOWER(email)`).
- Criei seeds com usuários, categorias e aulas; rodei `rails db:seed` e verifiquei o conteúdo do banco (nomes/e-mails/roles e aulas com categorias).
- Refatorei testes de models para usar factories; todos os specs de models ficaram passando.
- Próximos passos: request specs de signup/login, documentação interativa (Swagger/rswag) e/ou front-end para entradas via formulário.

Objetivos complementares desta fase:
- [x] Introduzi `FactoryBot` e `Faker` para gerar dados realistas em testes (substituindo nomes/e-mails fixos).
- [x] Adicionei validação de formato de e-mail (`URI::MailTo::EMAIL_REGEXP`) e normalização (`before_validation` para `email.downcase`).
- [x] Tornei a unicidade de e-mail case-insensitive (validação e índice único em `LOWER(email)` via migration).
- [x] Criei seeds (`db/seeds.rb`) com dados exemplo usando Faker para facilitar testes manuais.
- [ ] Vou adicionar request specs para o fluxo de cadastro (signup) onde o usuário fornece `name/email/password` (preparando terreno para a Fase 3 - JWT).
- [ ] Vou atualizar a documentação em `testes/` com exemplos de uso e como rodar os novos testes (incluindo uso de FactoryBot/Faker nos specs).

### Fase 3: Autenticação (JWT)
- [x] Adicionei a gem `jwt`.
- [x] Criei uma classe de serviço em `lib/json_web_token.rb` para `encode` e `decode`.
- [x] Criei o `AuthenticationController` com a ação `create` para o endpoint de login.
- [x] Configurei um `before_action` no `ApplicationController` para verificar o token em todas as requisições protegidas.

Observações desta etapa:
- Implementei o fluxo de login via `POST /api/v1/login` retornando `{ token, exp, user }`.
- Criei o serviço `JsonWebToken` (HS256) usando `secret_key_base`, com expiração padrão em 24h.
- Expus `authenticate_request!` e `current_user` no `ApplicationController` para proteger futuras rotas.
- Criei request specs em `spec/requests/authentication_spec.rb` e documentação em `testes/auth_tests.md`.
- Apliquei lint (RuboCop sem offenses) após ajustes de estilo (tabs → spaces, aspas, espaçamento em arrays).

Como testar rapidamente o login:
```bash
bundle exec rails db:prepare
bundle exec rails s
# Em outro terminal:
curl -i -X POST http://localhost:3000/api/v1/login \
    -H 'Content-Type: application/json' \
    -d '{"email":"<seu_email>","password":"<sua_senha>"}'
```
Use o token retornado no header `Authorization: Bearer <token>` nas rotas protegidas.

### Fase 4: Autorização (Pundit)
- [x] Adicionei e instalei a gem `Pundit`.
- [x] Incluí `Pundit::Authorization` no `ApplicationController` e tratei `Pundit::NotAuthorizedError`.
- [x] Gerei e implementei a `CategoryPolicy` (permito `create?`, `update?`, `destroy?` para admin/professor; `index?`/`show?` para autenticados).
- [x] Gerei e implementei a `AulaPolicy` (`create?` para admin/professor; `index?`/`show?` para autenticados; `enroll?` apenas para aluno).

Observações desta etapa (o que já fiz):
- Protegi rotas e controllers com Pundit:
    - `CategoriesController`: `index` (policy_scope), `show`, `create` (staff), `update` (staff), `destroy` (staff).
    - `AulasController`: `index` (policy_scope), `show`, `create` (staff), `enroll` (apenas aluno) criando `Enrollment`.
- Exigi autenticação via `authenticate_request!` em todos os endpoints protegidos.
- Padronizei as respostas em JSON com status adequados (200/201/204/401/403/422): sucesso `{ data: ... }`, erro `{ errors: [...] }`.
- Cobri autorização e fluxos feliz/erro com request specs para `categories` e `aulas` (todos verdes).
- Implementei o endpoint utilitário `GET /api/v1/me` para retornar o usuário autenticado.
    - (Opcional) Posso disponibilizar uma coleção Postman com exemplos prontos (incluindo variável `token` populada automaticamente ao logar). O arquivo anterior foi removido durante a reestruturação do repositório para colocar o app na raiz.

### Fase 5: API Endpoints (Controllers e Rotas)
 - [x] Estruturei as rotas dentro de um `namespace :api, :v1`.
 - [x] Criei `UsersController` para a ação `create` (signup) com retorno `{ data: { token, exp, user } }` e status 201.
 - [x] Adicionei a rota `POST /api/v1/signup`.
 - [x] Completei `AulasController` com `update` e `destroy` (staff via Pundit) e respostas padronizadas.
 - [x] Atualizei as rotas de `aulas` para incluir `update` e `destroy`.

### Fase 6: Testes e Documentação
 - [ ] (Diferencial) Vou escrever testes de requisição (request specs) com RSpec para os principais endpoints, cobrindo:
     - [x] Casos de sucesso (status 200, 201) para login, me, signup, aulas update e destroy.
     - [x] Erros de autenticação (status 401) para rotas protegidas.
     - [x] Erros de autorização (status 403) para aluno em ações restritas (ex.: aulas update/destroy).
     - [x] Erros de validação (status 422) em signup e atualização de recursos.
 - [x] Criei uma coleção no Postman para documentar e testar a API manualmente (arquivo `postman/fit_dreams_api.postman_collection.json`).

### Fase 7: Deploy
 
### Fase 6.5: Preparação para Deploy (pendências)

- Padrão de respostas e recursos de listagem
    - Confirmei o uso consistente do formato `{ data }` e `{ errors }` em todos os endpoints.
    - Incluí paginação nos endpoints de listagem (categories e aulas) e filtros nas aulas (por `category_id` e `start_time`), com `meta.pagination` no payload.

- Segurança e configuração
    - [x] Configurei CORS via `rack-cors`, controlado pela variável de ambiente `ALLOWED_ORIGINS`.
    - [x] Adicionei rate limiting com `rack-attack` (limites básicos por IP e reforço para login/signup).
    - Garanti `lib/` em autoload/eager-load em produção (uso de `JsonWebToken`).
    - Validei variáveis obrigatórias: `SECRET_KEY_BASE` ou `RAILS_MASTER_KEY`, `DATABASE_URL`; opcionais: `JWT_EXP`, `ALLOWED_ORIGINS`.

- Operação e dados
    - [x] Adicionei tarefa Rake idempotente de bootstrap (criação de usuários `admin`, `professor`, `aluno` e categorias iniciais).
    - Conferi índices/constraints no banco em produção: índice único em `LOWER(email)` e índice único composto em `enrollments(user_id,aula_id)`; garanti a aplicação das migrations.

- Documentação e ferramentas
    - Vou atualizar este documento com: endpoints finais (incluindo `aulas` update/destroy), exemplos `curl` por perfil com header `Authorization`, tabela de variáveis de ambiente e passos de deploy; e inserir a URL final do deploy.
    - Vou atualizar a coleção Postman/Insomnia com `baseUrl`, `token` e requisições de `signup`, `login`, `me`, `categories` CRUD e `aulas` CRUD + `enroll`, com observações por perfil.

- Execução em produção
    - [x] Adicionei `Procfile` (`web: bundle exec puma -C config/puma.rb`) e validei `config/puma.rb`.
    - Vou definir variáveis de ambiente, executar `db:migrate` e (opcional) a tarefa de bootstrap; e validar saúde via `/api/v1/me` e fluxo de `login`.

> Observação Heroku/DB: No momento, eu não provisionei banco de dados no Heroku, pois não há camada gratuita do Postgres. Para prosseguir com endpoints que dependem de banco (signup/login/CRUDs) eu precisaria de um plano pago — o que não me interessa agora. Para testes possíveis sem banco e detalhes do ambiente de produção, consulte `docs/heroku_testes.md`.

#### Variáveis de ambiente relevantes

- `ALLOWED_ORIGINS` (CORS): lista separada por vírgula das origens permitidas (ex.: `https://app.exemplo.com,https://admin.exemplo.com`). Padrão: `*`.
- `RACK_ATTACK_REQ_LIMIT_PER_MIN` (rate limit geral): padrão `60` req/min por IP.
- `RACK_ATTACK_LOGIN_LIMIT` (rate limit login): padrão `5` req/20s por IP.
- `RACK_ATTACK_SIGNUP_LIMIT` (rate limit signup): padrão `5` req/min por IP.
- `ADMIN_EMAIL`, `ADMIN_PASSWORD`, `PROFESSOR_EMAIL`, `PROFESSOR_PASSWORD`, `ALUNO_EMAIL`, `ALUNO_PASSWORD` (bootstrap): credenciais usadas pela tarefa `rails bootstrap:setup`.

- [x] Criei uma nova aplicação no Heroku.
- [ ] Vou garantir que a gem `pg` está no grupo principal do `Gemfile`.
- [x] Fiz o deploy da branch `main` para o Heroku (`git push heroku main`).
- [ ] Vou executar as migrations no ambiente de produção (`heroku run rails db:migrate`).
- [ ] Vou testar os endpoints da API em produção.
- [ ] Vou atualizar este `README.md` com a URL final da API.

---

## 🌍 Como usar a API no Heroku (produção)

Base da API (produção): https://backend-challange-49e1fdfd811c.herokuapp.com

- Sem banco configurado no Heroku, apenas verificações simples funcionam (ex.: rotas protegidas retornam 401). Para usar login/signup/CRUD é necessário configurar um Postgres e rodar as migrations.

### 1) Teste rápido sem banco (só para validar o servidor)

- Verificar que o app está de pé (deve retornar 404):
    - GET https://backend-challange-49e1fdfd811c.herokuapp.com/
- Rota protegida sem token (retorna 401):
    - GET https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/me

### 2) Habilitar banco de dados (opções)

- Opção A: usar Postgres externo gratuito (ex.: Neon, ElephantSQL)
    - Criar uma database e obter a URL de conexão (ex.: `postgres://USER:PASSWORD@HOST:PORT/DBNAME`).
    - Definir no Heroku: `DATABASE_URL` com essa URL.
    - Rodar migrations e (opcional) bootstrap.

- Opção B: usar Postgres do Heroku (pago)
    - Provisionar o add-on Postgres.
    - Heroku define `DATABASE_URL` automaticamente.
    - Rodar migrations e (opcional) bootstrap.

Exemplos de comandos (via Heroku CLI):

```bash
# Definir variável de ambiente (se usar DB externo)
heroku config:set DATABASE_URL="postgres://USER:PASSWORD@HOST:PORT/DBNAME" -a backend-challange-49e1fdfd811c

# (Opcional) CORS
heroku config:set ALLOWED_ORIGINS="*" -a backend-challange-49e1fdfd811c

# Rodar migrations
heroku run rails db:migrate -a backend-challange-49e1fdfd811c

# (Opcional) Popular usuários/categorias de exemplo
heroku run rails bootstrap:setup -a backend-challange-49e1fdfd811c
```

Bootstrap cria usuários padrão (pode personalizar via env):
- admin: `admin@example.com` / `Password!23`
- professor: `prof@example.com` / `Password!23`
- aluno: `aluno@example.com` / `Password!23`

### 3) Autenticação e chamadas na produção

1. Login (recebo `token`):

```bash
curl -s -X POST \
    https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/login \
    -H 'Content-Type: application/json' \
    -d '{"email":"admin@example.com","password":"Password!23"}'
```

2. Uso o token no header `Authorization` (Bearer):

```bash
TOKEN="<cole-o-token-aqui>"

# Meu usuário logado
curl -s https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/me \
    -H "Authorization: Bearer $TOKEN"

# Listar categorias
curl -s https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/categories \
    -H "Authorization: Bearer $TOKEN"
```

3. Exemplo (professor/admin) criar categoria:

```bash
curl -s -X POST \
    https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/categories \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"category": {"name":"Cardio","description":"Aulas de alta intensidade"}}'
```

4. Exemplo filtros/paginação (aulas):

```bash
curl -s "https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/aulas?page=1&per_page=10" \
    -H "Authorization: Bearer $TOKEN"
```

Observações:
- As respostas seguem o padrão `{ data: ... }` em sucesso e `{ errors: [...] }` em erro.
- Para front-ends, configure `ALLOWED_ORIGINS` conforme os domínios da aplicação para liberar CORS.
- `SECRET_KEY_BASE` deve estar definido (o Heroku já costuma gerenciar isso quando uso credenciais/keys); se necessário, seto manualmente via `heroku config:set`.

### 4) Postman/Insomnia (opcional)

- Posso incluir uma nova coleção Postman na raiz do projeto com os endpoints (signup, login, me, categories, aulas, enroll) pronta para uso com variável `baseUrl` e `token`. Se você preferir Insomnia, posso incluir também.