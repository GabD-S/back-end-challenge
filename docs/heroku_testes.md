# Fit Dreams API – Testes em Produção (Heroku)

URL da API (Heroku): https://backend-challange-49e1fdfd811c.herokuapp.com

## Minhas observações sobre banco de dados (Heroku)

- Eu não provisionei banco de dados no Heroku, pois atualmente não há camada gratuita do Heroku Postgres.
- Para avançar com dados persistentes (login, signup, CRUDs), eu precisaria habilitar um add-on de Postgres pago, o que não me interessa neste momento.
- Consequência: endpoints que dependem de banco vão falhar em produção até que eu configure um `DATABASE_URL`.

Alternativas gratuitas que eu posso usar futuramente (sem custo no Heroku):
- Apontar para um Postgres gratuito externo (p.ex. Neon, ElephantSQL free) e configurar `DATABASE_URL` manualmente no Heroku.
- Migrar o deploy para outro provedor com camada gratuita (Render + Neon, Fly.io, Railway), se eu preferir.

## O que eu posso testar agora (sem banco)

Com estes testes eu confirmo que o servidor está online, com SSL, CORS e middleware carregados:

1) Eu verifico o servidor online via recurso público

```bash
curl -i https://backend-challange-49e1fdfd811c.herokuapp.com/robots.txt
```

Eu espero receber: HTTP 200 e conteúdo do `public/robots.txt`.

2) Eu checo a proteção de rotas autenticadas

```bash
curl -i https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/me
```

Eu espero receber: HTTP 401 Unauthorized e body `{ "errors": ["Unauthorized"] }` (ou mensagem equivalente).

3) (Opcional) Eu verifico CORS (preflight)

```bash
curl -i -X OPTIONS \
  -H 'Origin: https://exemplo.com' \
  -H 'Access-Control-Request-Method: GET' \
  https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/me
```

Eu espero ver cabeçalhos CORS presentes conforme a configuração (`ALLOWED_ORIGINS`).

4) (Opcional) Eu valido o rate limiting

- O rate limit geral (Rack::Attack) está ativo para rotas `/api/` e retorna HTTP 429 quando o limite é excedido. Eu não preciso testar agora; em produção, isso protege login/signup contra brute-force.

## Testes que eu deixo pendentes até ter banco

- `POST /api/v1/signup`, `POST /api/v1/login`, CRUD de categorias e aulas e `POST /api/v1/aulas/:id/enroll` exigem banco. Sem Postgres, esses endpoints não vão funcionar em produção.

Quando (e se) eu disponibilizar um Postgres (pago ou externo gratuito):

```bash
# 1) Configurar DATABASE_URL (caso Postgres externo)
heroku config:set -a backend-challange DATABASE_URL='<sua_string_de_conexao>'

# 2) Executar migrations
heroku run -a backend-challange rails db:migrate

# 3) Opcional: popular dados básicos
heroku run -a backend-challange rails bootstrap:setup
```

## Variáveis de ambiente relevantes (que eu já usei)

- `SECRET_KEY_BASE`: eu defini (necessária para criptografia e JWT).
- `ALLOWED_ORIGINS`: eu defini (CORS). Vou ajustar para o domínio do front quando disponível.
- `RACK_ATTACK_REQ_LIMIT_PER_MIN`, `RACK_ATTACK_LOGIN_LIMIT`, `RACK_ATTACK_SIGNUP_LIMIT`: eu posso ajustar conforme necessidade.

---

Se eu preferir, eu posso apontar o banco para um serviço gratuito externo (sem custo), mantendo o app no plano gratuito do Heroku.
