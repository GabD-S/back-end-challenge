# Testes de Autenticação (Fase 3)

Este documento descreve os testes de autenticação via JWT adicionados nesta fase.

## Cenários cobertos

- Login com credenciais válidas retorna token JWT, data de expiração e dados básicos do usuário.
- E-mail é tratado sem diferenciar maiúsculas/minúsculas.
- Senha inválida retorna 401 Unauthorized.
- E-mail inexistente retorna 401 Unauthorized.

## Como rodar

Execute a suíte de testes:

```bash
bundle exec rspec spec/requests/authentication_spec.rb
```

O endpoint exposto é `POST /api/v1/login` com body `email` e `password`.
