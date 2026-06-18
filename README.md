# Como rodar


## Em ordem
`python3 venv venv`
`source venv/bin/activate`
`pip install pandas scikit-learn`
`python3 random_forest.py`

Oque fizemos
O projeto desenvolvido tem como objetivo prever o desempenho escolar dos alunos utilizando técnicas de Machine Learning. A proposta surgiu da necessidade de identificar, de forma antecipada, quais estudantes podem apresentar dificuldades ou alcançar um bom rendimento acadêmico, permitindo que escolas e professores tomem decisões mais rápidas e eficientes para auxiliar no processo de aprendizagem.

Para realizar essa previsão, foi criado um banco de dados fictício contendo informações relevantes sobre os alunos, como horas de estudo, quantidade de faltas e nível de participação em sala de aula. Com base nesses dados, cada aluno foi classificado em uma das categorias de desempenho: Baixo, Médio ou Alto.

O algoritmo escolhido para o projeto foi o Random Forest, um dos métodos mais utilizados em Machine Learning para tarefas de classificação. Esse algoritmo funciona através da criação de várias árvores de decisão, onde cada árvore realiza uma previsão individual. Ao final do processo, a classificação mais votada entre todas as árvores é escolhida como resultado final, tornando a previsão mais confiável e precisa.

A implementação foi realizada em Python utilizando bibliotecas voltadas para ciência de dados e aprendizado de máquina. Primeiramente, os dados foram organizados em uma tabela, depois separados em conjuntos de treinamento e teste. Em seguida, o modelo Random Forest foi treinado para aprender os padrões presentes nos dados e, posteriormente, foi avaliado por meio de testes.

Os resultados obtidos demonstraram um excelente desempenho do modelo, alcançando uma acurácia de 100% no conjunto de testes utilizado. Além disso, foi possível realizar previsões para novos alunos. Por exemplo, um estudante com cinco horas de estudo, três faltas e alta participação em aula foi classificado pelo sistema como um aluno de alto desempenho.

Esse tipo de solução pode ser aplicado em escolas, universidades, cursos profissionalizantes e plataformas de ensino online, contribuindo para o acompanhamento do desenvolvimento dos estudantes. Dessa forma, conclui-se que o Machine Learning pode ser uma ferramenta importante para a área da educação, auxiliando na identificação de padrões de aprendizagem e apoiando a tomada de decisões de forma mais eficiente.
