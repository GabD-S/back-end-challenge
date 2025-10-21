# Testes do Model Enrollment

## Cobertura
- Validação de unicidade: um `user` não pode se matricular duas vezes na mesma `aula` (escopo `aula_id`).

## Arquivo de teste
- `fit_dreams_api/spec/models/enrollment_spec.rb`

## Como executar
```bash
cd fit_dreams_api
bundle exec rspec spec/models/enrollment_spec.rb --format documentation --no-profile --force-color
```
