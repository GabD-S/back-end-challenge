# Switch Dreams Challenge - Fit Dreams API

Este repositório contém a solução para o desafio de backend da **Switch Dreams**, que consiste na criação de uma API RESTful para gerenciar as aulas da academia Fit Dreams.

A aplicação foi desenvolvida utilizando Ruby on Rails no modo API, com foco em boas práticas, código limpo e organização.

**URL da API (Deploy):** `[AINDA A SER INSERIDO - LINK DO HEROKU AQUI]`

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
- [ ] Em `User`, adicionar `has_secure_password`, `enum role`, e as associações `has_many :aulas, through: :enrollments`.
- [ ] Em `Aula`, adicionar as associações `belongs_to :category` e `has_many :alunos, through: :enrollments`.
- [ ] Em `Enrollment`, adicionar validação de unicidade para o par `user_id` e `aula_id`.
- [ ] Adicionar validações de presença (`presence: true`) e formato nos campos necessários.

### Fase 3: Autenticação (JWT)
- [ ] Adicionar a gem `jwt`.
- [ ] Criar uma classe de serviço em `lib/json_web_token.rb` para `encode` e `decode`.
- [ ] Criar o `AuthenticationController` com a ação `create` para o endpoint de login.
- [ ] Configurar um `before_action` no `ApplicationController` para verificar o token em todas as requisições protegidas.

### Fase 4: Autorização (Pundit)
- [ ] Adicionar e instalar a gem `Pundit`.
- [ ] Incluir `Pundit::Authorization` no `ApplicationController` e tratar `Pundit::NotAuthorizedError`.
- [ ] Gerar e implementar a `CategoryPolicy` (permitir `create?`, `update?`, `destroy?` para admin/professor).
- [ ] Gerar e implementar a `AulaPolicy` (mesmas permissões da `CategoryPolicy`).

### Fase 5: API Endpoints (Controllers e Rotas)
- [ ] Estruturar as rotas dentro de um `namespace :api, :v1`.
- [ ] Criar `UsersController` para a ação `create` (signup).
- [ ] Criar `CategoriesController` com as ações CRUD, protegidas pelo Pundit.
- [ ] Criar `AulasController` com as ações CRUD, protegidas pelo Pundit.
- [ ] Adicionar uma rota e ação para permitir que alunos se matriculem (`POST /aulas/:id/enroll`).

### Fase 6: Testes e Documentação
- [ ] (Diferencial) Escrever testes de requisição (request specs) com RSpec para os principais endpoints, cobrindo:
    - [ ] Casos de sucesso (status 200, 201).
    - [ ] Erros de autenticação (status 401).
    - [ ] Erros de autorização (status 403).
    - [ ] Erros de validação (status 422).
- [ ] Criar uma coleção no Postman ou Insomnia para documentar e testar a API manualmente.

### Fase 7: Deploy
- [ ] Criar uma nova aplicação no Heroku.
- [ ] Garantir que a gem `pg` está no grupo principal do `Gemfile`.
- [ ] Fazer o deploy da branch `main` para o Heroku (`git push heroku main`).
- [ ] Executar as migrations no ambiente de produção (`heroku run rails db:migrate`).
- [ ] Testar os endpoints da API em produção.
- [ ] Atualizar este `README.md` com a URL final da API.