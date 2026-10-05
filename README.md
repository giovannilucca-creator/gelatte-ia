# GELATTE IA — Sistema Mobile de Análise Financeira Inteligente

## Projeto Integrado — Desenvolvimento Mobile e Inteligência Artificial

Aplicativo mobile desenvolvido em Flutter com o objetivo de auxiliar a gestão financeira da Sorveteria Gelatte, permitindo o registro de vendas e despesas, acompanhamento de indicadores financeiros e geração de análises utilizando Inteligência Artificial.

## Autor

**Giovanni Lucca Ferreira Favaro**  
**RA: 26001342**

Curso: Análise e Desenvolvimento de Sistemas  
Instituição: UNIFEOB — Centro Universitário da Fundação de Ensino Octávio Bastos  
Ano: 2026

## Objetivo do projeto

O GELATTE IA foi desenvolvido para facilitar o acompanhamento financeiro da empresa, centralizando informações de vendas e despesas e apresentando indicadores que auxiliam na tomada de decisões.

Além do controle financeiro, o aplicativo utiliza Inteligência Artificial para interpretar os indicadores e apresentar diagnósticos, pontos de atenção e sugestões de ações para a gestão.

## Principais funcionalidades

- Login de acesso ao aplicativo;
- Dashboard com indicadores financeiros;
- Cadastro e visualização de vendas;
- Cadastro e visualização de despesas;
- Cálculo de receita, despesas, lucro e margem;
- Persistência local de dados utilizando SQLite;
- Integração com serviço de Inteligência Artificial;
- Análise inteligente dos indicadores financeiros.

## Tecnologias utilizadas

- Flutter
- Dart
- SQLite
- SQFlite
- HTTP
- API de Inteligência Artificial Gemini
- Google AI Studio
- Git e GitHub
- Visual Studio Code
- Android

## Estrutura principal

```text
lib/
├── database/
│   └── database_helper.dart
├── services/
│   └── ai_service.dart
└── main.dart