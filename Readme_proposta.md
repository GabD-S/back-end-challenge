# Switch Dreams Challenge

O desafio proposto visa avaliar suas habilidades com o framework Ruby on Rails, sendo isso parte do processo seletivo para vaga de desenvolvedor backend da Switch Dreams.

Esperamos que você tenha uma boa noção nos seguintes tópicos:

- HTTP e estrutura básica da web
- Linguagem de programação Ruby
- Framework Ruby on Rails
- Banco de Dados relacional
- Modelo MVC
- API
- Documentação de API (Não necessário em caso de testes automatizados e bem escritos)
- Testes automatizados (opcional/diferencial e de preferência utilizando o RSPEC)
- Padronização de código (linter - opcional/diferencial)

Além disso é sempre interessante estar atento aos padrões usuais de qualidade de código.

## Problema

A academia Fit Dreams possui uma grande versatilidade de aulas em seu cronograma, sendo que as atividades variam a cada mês. A Fit Dreams acaba de te contratar para desenvolver um sistema que organizará a disponibilidade de cada aula. 

A aula poderá conter os campos: nome, horário de início, duração, nome do professor e descrição.

Como as aulas são variadas, decidiu-se inserir um sistema de **categorias** para melhor organização. Cada categoria terá um nome e descrição.

O administrador e o professor têm autorização total de criação, edição e deleção de qualquer categoria e aula, porém ambos os resursos não podem ser alteradas por um aluno da academia.

O sistema deve permitir também que exista um sistema de usuários, sendo que os usuários são divididos entre alunos, professores e administradores. O usuário deve ter nome, data de nascimento, email, senha e a sua respectiva role (aluno, professor ou admin).

Um usuário também pode estar matriculado em diversas aulas e uma aula pode ter diversos alunos matriculados.

## Requisitos

Para iniciar o desafio, crie um repositório pessoal e inicie seu projeto rails nele. Altera o readme com todas as informações que você julgar pertinente para o desafio. Para entregar a sua implementação, você deve criar um deploy no [heroku](https://www.heroku.com/) ou servidor de sua preferência (explicite no readme a url da deploy da API)

Para padronizar o desafio você deve usar o Postgres como banco de dados (exigido pelo heroku) e a versão do Rails pode ser a 6.x ou 7.x com preferência para a 7. Sugerimos também que utilize a versão 2.7.x ou 3.x do ruby, para que você possa usar as features mais novas da linguagem.

A aplicação deve ser em Rails API e deve-se utilizar postman, insomnia, swagger ou testes no rspec para documentá-la.

Diferenciais:
Para os testes automatizados recomenda-se a utilização do RSpec e para padronização de código (linter) é recomendável a utilização do rubocop.

## Entrega

Deve ser enviado um email constando o repositório github em que o projeto foi desenvolvido assim como o link do deploy feito no heroku

## Avaliação

Avaliaremos as seguintes habilidades

- Nível de conhecimento em Rails
- Nível de conhecimento em Ruby
- Nível de conhecimento em API
- Qualidade da documentação
- Utilização do github

Diferenciais:
- Qualidade dos testes
- Utilização de um linter
- Qualidade do código

## Observações
Ao enviar o desafio você declara que a solução implementada foi 100% feita por você, sem violar nenhuma licença de software de terceiros.