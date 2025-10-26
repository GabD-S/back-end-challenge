# Fit Dreams API – Testes em Produção (Heroku)

URL da API (Heroku): https://backend-challange-49e1fdfd811c.herokuapp.com

## Observações importantes sobre banco de dados (Heroku)

- Não provisionamos banco de dados no Heroku, pois atualmente não há camada gratuita do Heroku Postgres.
- Para avançar com dados persistentes (login, signup, CRUDs), seria necessário habilitar um add-on de Postgres pago, o que não nos interessa neste momento.
- Consequência: endpoints que dependem de banco irão falhar em produção até que um `DATABASE_URL` seja configurado.

Alternativas gratuitas (caso desejado futuramente, sem custo no Heroku):
- Usar um Postgres gratuito externo (p.ex. Neon, ElephantSQL free) e configurar `DATABASE_URL` manualmente no Heroku.
- Migrar o deploy para outro provedor com camada gratuita (Render + Neon, Fly.io, Railway), se necessário.

## O que é possível testar agora (sem banco)

Estes testes confirmam que o servidor está online, com SSL, CORS e middleware carregados:

1) Verificar servidor online via recurso público

```bash
curl -i https://backend-challange-49e1fdfd811c.herokuapp.com/robots.txt
```

Espera: HTTP 200 e conteúdo do `public/robots.txt`.

2) Checar proteção de rotas autenticadas

```bash
curl -i https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/me
```

Espera: HTTP 401 Unauthorized e body `{ "errors": ["Unauthorized"] }` (ou mensagem equivalente).

3) (Opcional) Verificar CORS (preflight)

```bash
curl -i -X OPTIONS \
  -H 'Origin: https://exemplo.com' \
  -H 'Access-Control-Request-Method: GET' \
  https://backend-challange-49e1fdfd811c.herokuapp.com/api/v1/me
```

Espera: Cabeçalhos CORS presentes conforme configuração (`ALLOWED_ORIGINS`).

4) (Opcional) Rate limiting

- O rate limit geral (Rack::Attack) está ativo para rotas `/api/`. Ele retorna HTTP 429 quando o limite é excedido. Não é necessário testar agora; em produção, isso protege login/signup contra brute-force.

## Testes que ficarão pendentes até ter banco

- `POST /api/v1/signup`, `POST /api/v1/login`, CRUD de categorias e aulas e `POST /api/v1/aulas/:id/enroll` exigem banco. Sem Postgres, esses endpoints não funcionarão em produção.

Quando (e se) for disponibilizado um Postgres (pago ou externo gratuito):

```bash
# 1) Configurar DATABASE_URL (caso Postgres externo)
heroku config:set -a backend-challange DATABASE_URL='<sua_string_de_conexao>'

# 2) Executar migrations
heroku run -a backend-challange rails db:migrate

# 3) Opcional: popular dados básicos
heroku run -a backend-challange rails bootstrap:setup
```

## Variáveis de ambiente relevantes (já usadas)

- `SECRET_KEY_BASE`: definida (necessária para criptografia e JWT).
- `ALLOWED_ORIGINS`: definida (CORS). Ajuste para o domínio do front quando disponível.
- `RACK_ATTACK_REQ_LIMIT_PER_MIN`, `RACK_ATTACK_LOGIN_LIMIT`, `RACK_ATTACK_SIGNUP_LIMIT`: podem ser ajustadas conforme necessidade.

---

Qualquer dúvida, podemos apontar o banco para um serviço gratuito externo (sem custo), mantendo o app no plano gratuito do Heroku.
