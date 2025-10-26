# Switch Dreams Challenge - Fit Dreams API

Este repositório contém a solução para o desafio de backend da **Switch Dreams**, que consiste na criação de uma API RESTful para gerenciar as aulas da academia Fit Dreams.

A aplicação foi desenvolvida utilizando Ruby on Rails no modo API, com foco em boas práticas, código limpo e organização.

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

## 🌐 Estrutura da API

A API será versionada para garantir manutenibilidade. A estrutura base dos endpoints será:

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

## 💻 Como Executar o Projeto

Siga os passos abaixo para configurar e rodar a aplicação em seu ambiente local.

### Pré-requisitos

* Ruby (versão 3.x)
* Bundler (`gem install bundler`)
* PostgreSQL

### Passos

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/seu-usuario/switch_dreams_api.git](https://github.com/seu-usuario/switch_dreams_api.git)
    cd switch_dreams_api
    ```

2.  **Instale as dependências:**
    ```bash
    bundle install
    ```

3.  **Configure o banco de dados:**
    * Certifique-se de que seu PostgreSQL está rodando.
    * Se necessário, ajuste o arquivo `config/database.yml` com suas credenciais.
    * Crie e prepare o banco de dados:
    ```bash
    rails db:create
    rails db:migrate
    ```

4.  **Execute o servidor:**
    ```bash
    rails server
    ```
    A API estará disponível em `http://localhost:3000`.

5.  **(Opcional) Execute os testes:**
    ```bash
    rspec
    ```

---

## ✅ Plano de Ações e Desenvolvimento

Este é o checklist que guiará o desenvolvimento do projeto, dividido em fases para melhor organização.

### Fase 0: Configuração do Ambiente
- [x] Iniciar o projeto Rails 7 em modo API com PostgreSQL (`rails new ...`).
    - 20/10/2025: Gerado app Rails 7.2.2.2 (API-only) na pasta `fit_dreams_api/` com `--database=postgresql`. Bundler configurado para `vendor/bundle` e removido `.git` interno criado pelo `rails new` para evitar repositório aninhado.
- [x] Configurar o repositório Git e fazer o primeiro push no GitHub.
    - 20/10/2025: Repositório configurado com remoto via SSH. Criadas branches de trabalho e realizado o push da Fase 0 na branch `feat/rails-setup`.
- [x] Criar o banco de dados local com `rails db:create`.
    - 20/10/2025: Ajustado usuário do PostgreSQL e criado os bancos `fit_dreams_api_development` e `fit_dreams_api_test` com `bin/rails db:create`.
- [x] (Diferencial) Adicionar e configurar as gems `rspec-rails` e `rubocop`.
    - 20/10/2025: Adicionado `rspec-rails (~> 6.1)` e executado `rails generate rspec:install` (criados `.rspec`, `spec/spec_helper.rb` e `spec/rails_helper.rb`). Adicionado `rubocop-rails-omakase` e executado RuboCop com correção de trailing blank lines no `Gemfile` (commit "chore(lint)").
    - Extra: Executado Brakeman (baseline de segurança) sem alertas.

### Fase 1: Modelagem de Dados e Migrations
- [x] Gerar model `User` (`name`, `birth_date`, `email`, `password_digest`, `role`).
    - 21/10/2025: Gerado `User` com migração reforçada: `name/email/password_digest` com `null: false`, `role` com `default: 0` (aluno) e índice único em `email`.
- [x] Gerar model `Category` (`name`, `description`).
    - 21/10/2025: Gerado `Category` com `name` obrigatório e índice em `name`.
- [x] Gerar model `Aula` (`name`, `start_time`, `duration`, `teacher_name`, `description`, `category:references`).
    - 21/10/2025: Gerado `Aula` com campos obrigatórios, `category` como FK e índice em `start_time`.
- [x] Gerar model de junção `Enrollment` (`user:references`, `aula:references`).
    - 21/10/2025: Gerado `Enrollment` com FKs e índice único composto em `[user_id, aula_id]`.
- [x] Executar `rails db:migrate`.
    - 21/10/2025: Migrations aplicadas com sucesso; `db/schema.rb` atualizado.

### Fase 2: Configurar Models (Validações e Associações)
- [x] Em `User`, adicionar `has_secure_password`, `enum role`, e as associações `has_many :aulas, through: :enrollments`.
    - 21/10/2025: Implementado `has_secure_password`, `enum :role` (aluno/professor/admin), `has_many :enrollments` (com `dependent: :destroy`) e `has_many :aulas, through: :enrollments`. Validações de presença (name, email) e unicidade (email).
- [x] Em `Aula`, adicionar as associações `belongs_to :category` e `has_many :alunos, through: :enrollments`.
    - 21/10/2025: Implementado `belongs_to :category`, `has_many :enrollments` (com `dependent: :destroy`) e `has_many :alunos, through: :enrollments, source: :user`. Validações de presença (name, start_time, duration, teacher_name, category) e `duration` inteiro > 0.
- [x] Em `Enrollment`, adicionar validação de unicidade para o par `user_id` e `aula_id`.
    - 21/10/2025: Adicionada validação de unicidade de `user_id` com escopo em `aula_id` (além do índice único na migration).
- [x] Adicionar validações de presença (`presence: true`) e formato nos campos necessários.
    - 21/10/2025: Presença aplicada conforme descrito acima. Validação de formato de e-mail será tratada em melhorias complementares.

> Observação: Usei exemplos simples e apenas coloquei nomes aleatórios; ainda falta colocar links para usuário preencher nomes e criar e-mails por si só.

Observações desta etapa:
- Adicionados `FactoryBot` e `Faker` para geração de dados realistas em testes e seeds.
- Implementada normalização de e-mail (downcase + strip) e validação de formato; unicidade case-insensitive aplicada em validação e no banco (índice único em `LOWER(email)`).
- Criados seeds com usuários, categorias e aulas; executado `rails db:seed` e verificado conteúdo do banco (nomes/e-mails/roles e aulas com categorias).
- Refatorados testes de models para usar factories; todos os specs de models passando.
- Próximos: request specs de signup/login, documentação interativa (Swagger/rswag) e/ou front-end para entradas via formulário.

Objetivos complementares desta fase para atingir esse objetivo:
- [x] Introduzir `FactoryBot` e `Faker` para gerar dados realistas em testes (substituir nomes/e-mails fixos).
- [x] Adicionar validação de formato de e-mail (`URI::MailTo::EMAIL_REGEXP`) e normalização (`before_validation` para `email.downcase`).
- [x] Tornar a unicidade de e-mail case-insensitive (validação e índice único em `LOWER(email)` via migration).
- [x] Criar seeds (`db/seeds.rb`) com dados exemplo usando Faker para facilitar testes manuais.
- [ ] Adicionar request specs para fluxo de cadastro (signup) onde o usuário fornece `name/email/password` (prepara terreno para a Fase 3 - JWT).
- [ ] Atualizar documentação em `testes/` com exemplos de uso e como rodar os novos testes (incluindo uso de FactoryBot/Faker nos specs).

### Fase 3: Autenticação (JWT)
- [x] Adicionar a gem `jwt`.
- [x] Criar uma classe de serviço em `lib/json_web_token.rb` para `encode` e `decode`.
- [x] Criar o `AuthenticationController` com a ação `create` para o endpoint de login.
- [x] Configurar um `before_action` no `ApplicationController` para verificar o token em todas as requisições protegidas.

Observações desta etapa:
- Implementado fluxo de login via `POST /api/v1/login` retornando `{ token, exp, user }`.
- Serviço `JsonWebToken` (HS256) usando `secret_key_base`, com expiração padrão em 24h.
- `ApplicationController` passou a expor `authenticate_request!` e `current_user` para proteger futuras rotas.
- Criados request specs em `spec/requests/authentication_spec.rb` e documentação em `testes/auth_tests.md`.
- Lint aplicado (RuboCop sem offenses) após ajustes de estilo (tabs → spaces, aspas, espaçamento em arrays).

Como testar rapidamente o login:
```bash
cd fit_dreams_api
bundle exec rails db:prepare
bundle exec rails s
# Em outro terminal:
curl -i -X POST http://localhost:3000/api/v1/login \
    -H 'Content-Type: application/json' \
    -d '{"email":"<seu_email>","password":"<sua_senha>"}'
```
Use o token retornado no header `Authorization: Bearer <token>` nas rotas protegidas.

### Fase 4: Autorização (Pundit)
- [x] Adicionar e instalar a gem `Pundit`.
- [x] Incluir `Pundit::Authorization` no `ApplicationController` e tratar `Pundit::NotAuthorizedError`.
- [x] Gerar e implementar a `CategoryPolicy` (permitir `create?`, `update?`, `destroy?` para admin/professor; `index?`/`show?` para autenticados).
- [x] Gerar e implementar a `AulaPolicy` (`create?` para admin/professor; `index?`/`show?` para autenticados; `enroll?` apenas para aluno).

Observações desta etapa (o que já foi feito):
- Rotas e controllers protegidos com Pundit:
    - `CategoriesController`: `index` (policy_scope), `show`, `create` (staff), `update` (staff), `destroy` (staff).
    - `AulasController`: `index` (policy_scope), `show`, `create` (staff), `enroll` (apenas aluno) criando `Enrollment`.
- Autenticação obrigatória via `authenticate_request!` em todos os endpoints protegidos.
- Respostas em JSON com status adequados (200/201/204/401/403/422) e formato padronizado: sucesso `{ data: ... }`, erro `{ errors: [...] }`.
- Request specs cobrindo autorização e fluxo feliz/erro para `categories` e `aulas` (todos verdes).
- Endpoint utilitário `GET /api/v1/me` implementado para retornar o usuário autenticado.
- Coleção Postman adicionada em `postman/fit_dreams_api.postman_collection.json` com exemplos prontos de login, me, categories e aulas (inclui variável `token` populada automaticamente ao logar).

### Fase 5: API Endpoints (Controllers e Rotas)
 - [x] Estruturar as rotas dentro de um `namespace :api, :v1`.
 - [x] Criar `UsersController` para a ação `create` (signup) com retorno `{ data: { token, exp, user } }` e status 201.
 - [x] Adicionar rota `POST /api/v1/signup`.
 - [x] Completar `AulasController` com `update` e `destroy` (staff via Pundit) e respostas padronizadas.
 - [x] Atualizar rotas de `aulas` para incluir `update` e `destroy`.

### Fase 6: Testes e Documentação
 - [ ] (Diferencial) Escrever testes de requisição (request specs) com RSpec para os principais endpoints, cobrindo:
     - [x] Casos de sucesso (status 200, 201) para login, me, signup, aulas update e destroy.
     - [x] Erros de autenticação (status 401) para rotas protegidas.
     - [x] Erros de autorização (status 403) para aluno em ações restritas (ex.: aulas update/destroy).
     - [x] Erros de validação (status 422) em signup e atualização de recursos.
 - [x] Criar uma coleção no Postman para documentar e testar a API manualmente (arquivo `postman/fit_dreams_api.postman_collection.json`).

### Fase 7: Deploy
 
### Fase 6.5: Preparação para Deploy (pendências)

- Padrão de respostas e recursos de listagem
    - Confirmar o uso consistente do formato `{ data }` e `{ errors }` em todos os endpoints.
    - Incluir paginação nos endpoints de listagem (categories e aulas) e filtros nas aulas (por `category_id` e `start_time`). Sugerido incluir `meta.pagination` no payload.

- Segurança e configuração
    - [x] Configurar CORS via `rack-cors`, controlado pela variável de ambiente `ALLOWED_ORIGINS`.
    - [x] Adicionar rate limiting com `rack-attack` (limites básicos por IP e reforço para login/signup).
    - Garantir `lib/` em autoload/eager-load em produção (uso de `JsonWebToken`).
    - Validar variáveis obrigatórias: `SECRET_KEY_BASE` ou `RAILS_MASTER_KEY`, `DATABASE_URL`; opcionais: `JWT_EXP`, `ALLOWED_ORIGINS`.

- Operação e dados
    - [x] Adicionar tarefa Rake idempotente de bootstrap (criação de usuários `admin`, `professor`, `aluno` e categorias iniciais).
    - Conferir índices/constraints no banco em produção: índice único em `LOWER(email)` e índice único composto em `enrollments(user_id,aula_id)`; garantir aplicações de migrations.

- Documentação e ferramentas
    - Atualizar este documento com: endpoints finais (incluindo `aulas` update/destroy), exemplos `curl` por perfil com header `Authorization`, tabela de variáveis de ambiente e passos de deploy; inserir a URL final do deploy.
    - Atualizar a coleção Postman/Insomnia com `baseUrl`, `token` e requisições de `signup`, `login`, `me`, `categories` CRUD e `aulas` CRUD + `enroll`, com observações por perfil.

- Execução em produção
    - [x] Adicionar `Procfile` (`web: bundle exec puma -C config/puma.rb`) e validar `config/puma.rb`.
    - Definir variáveis de ambiente, executar `db:migrate` e (opcional) tarefa de bootstrap; validar saúde via `/api/v1/me` e fluxo de `login`.

> Observação Heroku/DB: No momento, não provisionamos banco de dados no Heroku, pois não há camada gratuita do Postgres. Para prosseguir com endpoints que dependem de banco (signup/login/CRUDs) seria necessário um plano pago — o que não nos interessa agora. Para testes possíveis sem banco e detalhes do ambiente de produção, consulte `docs/heroku_testes.md`.

#### Variáveis de ambiente relevantes

- `ALLOWED_ORIGINS` (CORS): lista separada por vírgula das origens permitidas (ex.: `https://app.exemplo.com,https://admin.exemplo.com`). Padrão: `*`.
- `RACK_ATTACK_REQ_LIMIT_PER_MIN` (rate limit geral): padrão `60` req/min por IP.
- `RACK_ATTACK_LOGIN_LIMIT` (rate limit login): padrão `5` req/20s por IP.
- `RACK_ATTACK_SIGNUP_LIMIT` (rate limit signup): padrão `5` req/min por IP.
- `ADMIN_EMAIL`, `ADMIN_PASSWORD`, `PROFESSOR_EMAIL`, `PROFESSOR_PASSWORD`, `ALUNO_EMAIL`, `ALUNO_PASSWORD` (bootstrap): credenciais usadas pela tarefa `rails bootstrap:setup`.

- [x] Criar uma nova aplicação no Heroku.
- [ ] Garantir que a gem `pg` está no grupo principal do `Gemfile`.
- [x] Fazer o deploy da branch `main` para o Heroku (`git push heroku main`).
- [ ] Executar as migrations no ambiente de produção (`heroku run rails db:migrate`).
- [ ] Testar os endpoints da API em produção.
- [ ] Atualizar este `README.md` com a URL final da API.