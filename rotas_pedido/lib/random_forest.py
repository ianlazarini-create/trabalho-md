import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

# Banco de dados fictício
dados = {
    'horas_estudo': [1, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 1, 2, 4, 5, 6, 3, 2, 5, 4],
    'faltas': [15, 12, 8, 6, 4, 2, 14, 10, 7, 5, 1, 16, 13, 6, 3, 2, 9, 11, 4, 5],
    'participacao': [1, 1, 2, 2, 3, 3, 1, 2, 2, 3, 3, 1, 1, 2, 3, 3, 2, 1, 3, 2],
    'desempenho': [
        'Baixo', 'Baixo', 'Medio', 'Medio', 'Alto',
        'Alto', 'Baixo', 'Medio', 'Medio', 'Alto',
        'Alto', 'Baixo', 'Baixo', 'Medio', 'Alto',
        'Alto', 'Medio', 'Baixo', 'Alto', 'Medio'
    ]
}

# Transformar em tabela
df = pd.DataFrame(dados)

print("Banco de Dados:")
print(df)

# Separar dados de entrada e saída
X = df[['horas_estudo', 'faltas', 'participacao']]
y = df['desempenho']

# Separar treino e teste
X_treino, X_teste, y_treino, y_teste = train_test_split(
    X,
    y,
    test_size=0.3,
    random_state=42
)

# Criar modelo Random Forest
modelo = RandomForestClassifier(
    n_estimators=100,
    random_state=42
)

# Treinar modelo
modelo.fit(X_treino, y_treino)

# Fazer previsões
previsoes = modelo.predict(X_teste)

# Calcular acurácia
acuracia = accuracy_score(y_teste, previsoes)

print("\nAcurácia do modelo:")
print(f"{acuracia * 100:.2f}%")

# Teste com um novo aluno
novo_aluno = pd.DataFrame({
    'horas_estudo': [5],
    'faltas': [3],
    'participacao': [3]
})

resultado = modelo.predict(novo_aluno)

resultado = modelo.predict(novo_aluno)

print("\nNovo aluno:")
print("Horas de estudo: 5")
print("Faltas: 3")
print("Participação: Alta")

print("\nPrevisão do modelo:")
print(resultado[0])