# Fit Dreams API (Switch Dreams Challenge)

Este projeto é uma API RESTful em Ruby on Rails (API-only) para gerenciar aulas da academia Fit Dreams, com autenticação via JWT, autorização por perfis (aluno, professor, admin), respostas JSON padronizadas e boas práticas de segurança (CORS e rate limiting).

- Guia detalhado (mais completo): veja `Planejamento.md`.
- Produção (Heroku): https://backend-challange-49e1fdfd811c.herokuapp.com
- Desenvolvimento de talhado(Github):  https://github.com/GabD-S/back-end-challenge
## O que a API retorna (contrato de respostas)

- Respostas de sucesso seguem o padrão:
	- `{ "data": <payload> }`
- Respostas de erro seguem o padrão:
	- `{ "errors": ["mensagem 1", "mensagem 2", ...] }`

Exemplos:
- Login (POST /api/v1/login):
	- Sucesso: `{ "data": { "token": "...", "exp": 1730000000, "user": { "id": 1, "name": "...", "email": "...", "role": "admin" } } }`
	- Erro (401): `{ "errors": ["Invalid email or password"] }`
- Me (GET /api/v1/me):
	- Sem token: 401 com `{ "errors": ["Unauthorized"] }`
	- Com token válido: `{ "data": { "id": 1, "name": "...", "email": "...", "role": "admin" } }`
- Categorias/Aulas: listagens com paginação retornam `{ data: [...], meta: { pagination: { page, per_page, total, total_pages } } }`

Perfis e permissões:
- aluno: pode ver categorias/aulas e se matricular.
- professor/admin: podem criar/atualizar/deletar categorias e aulas.

## Por que a API está assim (decisões de arquitetura)

- Rails 7 API-only: leve para backends REST, sem assets/front.
- JWT para autenticação: stateless, simples de integrar com front-ends.
- Pundit para autorização: regras claras por perfil e por recurso.
- Respostas padronizadas: `{ data }` e `{ errors }` simplificam o consumo no front.
- Paginação e filtros: performance e UX em listagens grandes.
- CORS configurável (ALLOWED_ORIGINS) e rate limiting (rack-attack): segurança básica pronta para produção.
- Heroku: deploy simples. Observação: não há Postgres gratuito; portanto, em produção o app só funcionará plenamente configurar um banco (DATABASE_URL externo ou add-on pago) e rodar as migrations. Sem DB, endpoints protegidos respondem 401 (ok), mas signup/login/CRUD que gravam no banco irão falhar.

## Como rodar localmente (passo a passo)

# Fit Dreams API (Switch Dreams Challenge)

Este projeto é uma API RESTful em Ruby on Rails (API-only) para gerenciar aulas da academia Fit Dreams, com autenticação via JWT, autorização por perfis (aluno, professor, admin), respostas JSON padronizadas e boas práticas de segurança (CORS e rate limiting).

**URL da API (Deploy):** https://backend-challange-49e1fdfd811c.herokuapp.com
**Dashboard Heroku:** https://dashboard.heroku.com/apps/backend-challange

**Nota:** Não é possível acessar o banco de dados diretamente pelo Heroku, pois não foi provisionado Postgres (camada gratuita indisponível). Endpoints que dependem de banco (signup/login/CRUD) não funcionam em produção até configurar um banco externo ou add-on pago.

## O que a API retorna (contrato de respostas)

Todas as respostas seguem o padrão:
- Sucesso: `{ "data": <payload> }`
- Erro: `{ "errors": ["mensagem 1", "mensagem 2", ...] }`

Exemplos:
- Login (POST /api/v1/login):
	- Sucesso: `{ "data": { "token": "...", "exp": 1730000000, "user": { "id": 1, "name": "...", "email": "...", "role": "admin" } } }`
	- Erro (401): `{ "errors": ["Invalid email or password"] }`
- Me (GET /api/v1/me):
	- Sem token: 401 com `{ "errors": ["Unauthorized"] }`
	- Com token válido: `{ "data": { "id": 1, "name": "...", "email": "...", "role": "admin" } }`
- Categorias/Aulas: listagens com paginação retornam `{ data: [...], meta: { pagination: { page, per_page, total, total_pages } } }`

Perfis e permissões:
- aluno: pode ver categorias/aulas e se matricular.
- professor/admin: podem criar/atualizar/deletar categorias e aulas.

## Planejamento e execução do projeto

O projeto foi planejado e executado em etapas:

- Configuração do ambiente Rails 7 API-only com PostgreSQL.
- Modelagem dos dados e migrations para User, Category, Aula, Enrollment.
- Implementação de autenticação JWT e autorização por perfil (Pundit).
- Padronização das respostas JSON, paginação, filtros e testes automatizados (RSpec).
- Configuração de CORS, rate limiting, bootstrap de dados e deploy no Heroku.
- Documentação dos endpoints, exemplos de uso e instruções de deploy.

Todas as tarefas do planejamento foram concluídas.

## Como rodar localmente (passo a passo)

Pré-requisitos:
- Ruby 3.2.3
- Bundler
- PostgreSQL rodando

1) Clonar o repositório
```bash
git clone git@github.com:GabD-S/back-end-challenge.git
cd back-end-challenge
git checkout feat/api
```

2) Instalar dependências
```bash
bundle install
```

3) Configurar banco de dados
- O arquivo `config/database.yml` já aponta para os bancos locais `fit_dreams_api_development` e `fit_dreams_api_test`.
- Ajuste usuário/senha/host do Postgres se necessário.

4) Criar e migrar o banco
```bash
bundle exec rails db:prepare
bundle exec rails db:seed          # opcional
bundle exec rails bootstrap:setup  # opcional (cria admin/professor/aluno + categorias)
```

5) Subir o servidor
```bash
bundle exec rails s
```
- A API ficará em http://localhost:3000

6) Testes automatizados
```bash
bundle exec rspec
```

7) Exemplos de chamadas (curl)
- Signup:
```bash
curl -s -X POST http://localhost:3000/api/v1/signup \
	-H 'Content-Type: application/json' \
	-d '{"user": {"name":"Alice","email":"alice@example.com","password":"Password!23","password_confirmation":"Password!23"}}'
```

- Login (pegar token):
```bash
curl -s -X POST http://localhost:3000/api/v1/login \
	-H 'Content-Type: application/json' \
	-d '{"email":"admin@example.com","password":"Password!23"}'
```

- Usar token (ex.: /me):
```bash
TOKEN="<cole-o-token>"
curl -s http://localhost:3000/api/v1/me -H "Authorization: Bearer $TOKEN"
```

## Produção (Heroku)

- Base: https://backend-challange-49e1fdfd811c.herokuapp.com
- Dashboard: https://dashboard.heroku.com/apps/backend-challange
- **Nota:** Não é possível acessar o banco de dados diretamente pelo Heroku, pois não foi provisionado Postgres (camada gratuita indisponível). Endpoints que dependem de banco (signup/login/CRUD) não funcionam em produção até configurar um banco externo ou add-on pago.

Para detalhes adicionais (variáveis de ambiente, exemplos completos, Postman/Insomnia), veja `Planejamento.md`.
