# App de Dicionário de Palavras

O App de Dicionário de Palavras é uma aplicação móvel desenvolvida em Flutter que permite aos usuários consultar detalhes sobre palavras, incluindo fonética, significados e opção de favoritar palavras para acesso rápido.

## Funcionalidades Principais

- **Consulta de Palavras**: Permite aos usuários buscar por palavras para obter detalhes como fonética e significados.
- **Fonética**: Possibilidade de ouvir a pronúncia da fonética das palavras.
- **Significados**: Exibe definições e contextos de uso das palavras consultadas.
- **Favoritos**: Opção para adicionar palavras aos favoritos para acesso rápido posteriormente.
- **Integração com Firebase**: Armazena favoritos dos usuários no Firebase Firestore para sincronização entre dispositivos.

## Arquitetura

O aplicativo segue uma arquitetura simples e modular, organizada principalmente em três telas principais:

- **Tela de Busca**: Permite aos usuários buscar palavras e exibe detalhes como fonética e significados.
- **Tela de Detalhes da Palavra**: Mostra informações detalhadas de uma palavra específica, incluindo a opção de ouvir a fonética.
- **Tela de Favoritos**: Lista todas as palavras favoritadas pelo usuário, permitindo gerenciamento fácil.

O código é estruturado seguindo boas práticas de desenvolvimento em Flutter, com separação clara de lógica de apresentação (UI) e lógica de negócios, utilizando widgets reutilizáveis e gerenciamento de estado eficiente.

## Configuração

Para executar o aplicativo localmente:

1. **Pré-requisitos**: Certifique-se de ter o ambiente Flutter configurado corretamente.
2. **Dependências**: Execute `flutter pub get` para instalar todas as dependências necessárias.
3. **Firebase**: Configure suas credenciais Firebase no arquivo `google-services.json` para a integração correta com o Firestore.
4. **acesso**: usuario: teste@gmail.com, senha: 123456

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para enviar pull requests para melhorias, correções de bugs ou adição de novas funcionalidades.

## Autor

Esdras Soares de Oliveira
