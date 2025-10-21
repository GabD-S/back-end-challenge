# Testes do Model User

Este documento descreve os testes criados para o model `User` (Fase 2).

## Cobertura
- Associações: `has_many :enrollments, dependent: :destroy` e `has_many :aulas, through: :enrollments`.
- Enum: `role` com valores `{ aluno: 0, professor: 1, admin: 2 }` e default `aluno`.
- Validações: presença de `name` e `email`; unicidade de `email`.
- Autenticação segura: `has_secure_password` (hash e autenticação).

## Arquivo de teste
- `fit_dreams_api/spec/models/user_spec.rb`

## Como executar
- Na pasta `fit_dreams_api/`, execute:

```bash
bundle exec rspec spec/models/user_spec.rb --format documentation --no-profile --force-color
```
