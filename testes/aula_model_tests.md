# Testes do Model Aula

## Cobertura
- Associações: `belongs_to :category`, `has_many :enrollments, dependent: :destroy`, `has_many :alunos, through: :enrollments`.
- Validações: presença de `name`, `start_time`, `duration`, `teacher_name`, `category`; `duration` inteiro e > 0.

## Arquivo de teste
- `fit_dreams_api/spec/models/aula_spec.rb`

## Como executar
```bash
cd fit_dreams_api
bundle exec rspec spec/models/aula_spec.rb --format documentation --no-profile --force-color
```
