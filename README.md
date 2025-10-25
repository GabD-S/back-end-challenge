# Back-end Challenge: Fit Dreams API

Este repositório contém o roteiro completo (passo a passo) para configurar o ambiente do desafio Switch Dreams e iniciar uma API em Ruby on Rails 7 com Postgres.

Se você ainda não possui nada configurado, siga as etapas abaixo na ordem. Os comandos estão preparados para Linux (bash).

---

## 1) Pré-requisitos

- Git
- rbenv (ou asdf) para gerenciar versões do Ruby
- Ruby 3.2.x ou 3.3.x
- Node.js 18+ e Yarn (ou Bun)
- PostgreSQL 14+ (com usuário e senha locais)
- cURL, build-essential, libpq-dev

Dicas rápidas de instalação (Ubuntu/Debian):

```bash
sudo apt update
sudo apt install -y git curl build-essential libssl-dev libreadline-dev zlib1g-dev libpq-dev
```

### rbenv + Ruby
```bash
# Instalar rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
~/.rbenv/bin/rbenv init
# Adicionar ao shell
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
source ~/.bashrc

# Instalar ruby-build
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Instalar Ruby (ajuste a versão se preferir)
rbenv install 3.2.4
rbenv global 3.2.4
ruby -v
```

### Node.js + Yarn
```bash
# Node LTS via NodeSource (exemplo com 20.x)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
npm -v && node -v

# Yarn
sudo npm i -g yarn
```

### PostgreSQL
```bash
sudo apt install -y postgresql postgresql-contrib
sudo -u postgres createuser --superuser $USER || true
createdb $USER || true
# Opcional: configurar senha para seu usuário do Postgres
# psql -c "ALTER USER $USER WITH PASSWORD 'sua_senha';"
```

---

## 2) Criar projeto Rails API (Rails 7)

Instalar Rails e gerar app API:
```bash
gem install rails -v "~> 7.1"
rbenv rehash
rails -v

# Gerar projeto API (em pasta do seu repositório)
rails new fit_dreams_api \
  --api \
  --database=postgresql \
  --skip-javascript \
  --skip-hotwire \
  --skip-action-mailbox \
  --skip-action-text \
  --skip-active-storage
```

Entrar na pasta do projeto e configurar banco:
```bash
cd fit_dreams_api
cp config/database.yml config/database.yml.example
```

Edite `config/database.yml` (development/test) com seu usuário/senha Postgres se necessário, por exemplo:
```yml
development:
  <<: *default
  database: fit_dreams_api_development
  username: <%= ENV.fetch("PGUSER", ENV.fetch("USER")) %>
  password: <%= ENV["PGPASSWORD"] %>
```

Criar o banco:
```bash
bin/rails db:create
```

---

## 3) Modelagem inicial

Entidades e relações:
- User (nome, data_nascimento, email, senha, role: aluno|professor|admin)
- Category (nome, descrição)
- ClassSession (aula: nome, starts_at, duration_minutes, teacher_name, description, category_id)
- Enrollment (user_id, class_session_id) — muitos-para-muitos entre alunos e aulas

Gems úteis (adicionar ao Gemfile):
- devise (autenticação)
- pundit (autorização/roles)
- rspec-rails (testes)
- rubocop, rubocop-rails (linter)
- fast_jsonapi ou jbuilder/blueprinter (serialização)
- rack-cors (CORS)

Após editar o Gemfile:
```bash
bundle install
rails generate rspec:install
```

---

## 4) Autenticação e autorização

- Instalar Devise e gerar User com roles (enum):
```bash
rails generate devise:install
rails generate devise User name:string birthdate:date role:integer
# adicionar índices únicos para email e enum default
bin/rails db:migrate
```
- Definir enum role: `{ student: 0, teacher: 1, admin: 2 }`
- Pundit para políticas de acesso (admin/teacher podem CRUD, student só leitura)

---

## 5) Recursos principais

Gerar scaffolds/controllers API-only:
```bash
rails g model Category name:string description:text
rails g model ClassSession name:string starts_at:datetime duration_minutes:integer teacher_name:string description:text category:references
rails g model Enrollment user:references class_session:references
bin/rails db:migrate

rails g controller api/v1/categories --no-helper --no-assets
rails g controller api/v1/class_sessions --no-helper --no-assets
rails g controller api/v1/enrollments --no-helper --no-assets
```

- Configurar rotas em `config/routes.rb` com namespace `api/v1`.
- Usar serializers para resposta JSON padronizada.
- Em `Enrollment`, validar que apenas `students` podem se matricular.

---

## 6) Documentação da API

Escolha um:
- Swagger (rswag)
- Postman/Insomnia (export JSON para `postman/`)
- Testes RSpec bem escritos cobrindo as rotas principais

---

## 7) Testes e qualidade

- RSpec: request specs para categories, class_sessions, enrollments e autenticação
- Rubocop: `bundle exec rubocop --auto-gen-config` e ajuste do estilo
- CI opcional (GitHub Actions) com `ruby/setup-ruby`

---

## 8) CORS e segurança

- Adicionar `rack-cors` e liberar origens necessárias
- Configurar `config.force_ssl = true` em produção

---

## 9) Deploy (Heroku ou Render/Fly.io)

Heroku (se disponível):
```bash
heroku create fit-dreams-api-<seu-sufixo>
heroku buildpacks:add heroku/ruby
heroku addons:create heroku-postgresql:hobby-dev
heroku config:set RAILS_ENV=production RACK_ENV=production
heroku config:set DEVISE_SECRET_KEY=$(rails secret)

# Banco e deploy
git push heroku main
heroku run rails db:migrate
```

Alternativas modernas:
- Render.com (Web Service + Postgres)
- Fly.io (Dockerfile + Postgres)

---

## 10) Convenções de commit e branches

- main estável
- feat/*, fix/*, chore/*
- Conventional Commits (ex.: `feat(api): cria endpoint de categorias`)

---

## 11) Como rodar localmente

```bash
# Dentro de fit_dreams_api
bundle install
bin/rails db:setup
bin/rails s
# API em http://localhost:3000
```

Observação: este repositório possui a app Rails dentro da pasta `fit_dreams_api/`. Use os comandos acima dentro dessa pasta.

---

## API status (Fase 4 concluída)

Implementado até aqui:

- Modelos e migrações: `User`, `Category`, `Aula` e `Enrollment` com constraints e índices (inclui índice único em LOWER(email)).
- Autenticação: JWT (HS256) com expiração 24h. Endpoint `POST /api/v1/login`.
- Autorização: Pundit com políticas para `Category` e `Aula`.
- Endpoints principais sob `/api/v1` protegidos por Bearer token.
- Formato de resposta padronizado: sucesso em `{ data: ... }` e erros em `{ errors: [ ... ] }`.
- Endpoint utilitário `GET /api/v1/me` para retornar o usuário autenticado.

### Formato de resposta

- Sucesso: `{ "data": <objeto|array> }`
- Erro: `{ "errors": ["Mensagem 1", "Mensagem 2"] }`

### Endpoints

- `POST /api/v1/login` → body: `{ email, password }` → `{ data: { token, exp, user } }`
- `GET /api/v1/me` → requer Bearer → `{ data: { id, name, email, role } }`
- `GET /api/v1/categories` → lista categorias `{ data: [ ... ] }`
- `GET /api/v1/categories/:id` → mostra categoria `{ data: { ... } }`
- `POST /api/v1/categories` (staff) → cria `{ data: { ... } }`
- `PATCH /api/v1/categories/:id` (staff) → atualiza `{ data: { ... } }`
- `DELETE /api/v1/categories/:id` (staff) → 204 no content
- `GET /api/v1/aulas` → lista aulas `{ data: [ ... ] }`
- `GET /api/v1/aulas/:id` → mostra aula `{ data: { ... } }`
- `POST /api/v1/aulas` (staff) → cria `{ data: { ... } }`
- `POST /api/v1/aulas/:id/enroll` (aluno) → matricula `{ data: { message, id } }`

Perfis:
- `admin`/`professor` podem criar/atualizar/excluir categorias e criar aulas.
- `aluno` pode listar/ver categorias/aulas e se matricular em aulas.

### Postman

Coleção pronta em `postman/fit_dreams_api.postman_collection.json` com variáveis `baseUrl`, `email`, `password` e `token`.
Fluxo sugerido:
1) Rodar "Auth: Login" → salva `token` automaticamente nas variáveis da coleção.
2) Usar `GET /api/v1/me` para validar o token.
3) Exercitar rotas de `Categories` e `Aulas` (respeitando o papel do usuário logado).

### Testes e qualidade

Dentro de `fit_dreams_api/`:

```bash
bundle exec rspec --format documentation
bundle exec rubocop
```

## 12) Próximos passos

- Iniciar Fase 5 (a combinar): possivelmente serializers/dry-types/paginação/ordenar/filtros, observabilidade, e2e, etc.
