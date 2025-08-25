# Sistema de Avaliação TCC

Um aplicativo Flutter para facilitar a avaliação de projetos de Trabalho de Conclusão de Curso (TCC) através de QR Codes.

## Funcionalidades

### 🏠 Tela Inicial (Home)
- **Informações sobre o projeto**: Descrição detalhada do sistema
- **Botão Login**: Acesso ao sistema para usuários cadastrados
- **Botão "Ler QR Code"**: Funcionalidade para escanear QR Codes de projetos

### 📱 Leitura de QR Code
- **Scanner de câmera**: Leitura direta via câmera do dispositivo
- **Upload de imagem**: Opção para enviar imagem contendo QR Code
- **Redirecionamento automático**: Após leitura, usuário é direcionado para formulário de avaliação

### 📝 Formulário de Avaliação
- **Matrícula** (campo obrigatório)
- **Nome** (campo obrigatório)
- **Nota** (escala de 0 a 10 com slider)
- **Feedback** (campo de texto opcional)
- **Botão "Enviar"** para salvar avaliação

### 🔐 Sistema de Login
- **Autenticação simples**: Login com matrícula e senha
- **Redirecionamento**: Após login, usuário acessa histórico de avaliações

### 📊 Histórico de Avaliações
- **Lista completa**: Todas as avaliações realizadas pelo usuário
- **Detalhes**: Nome do projeto, nota, feedback e data
- **Estatísticas**: Total de avaliações realizadas

## Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento mobile
- **Dart**: Linguagem de programação
- **SharedPreferences**: Armazenamento local de dados
- **QR Code Scanner**: Leitura de códigos QR
- **Image Picker**: Seleção de imagens da galeria
- **Camera**: Acesso à câmera do dispositivo

## Estrutura do Projeto

```
lib/
├── main.dart                 # Arquivo principal e configuração de rotas
├── home_page.dart           # Página inicial com botões principais
├── login_page.dart          # Página de login
├── models/
│   └── avaliacao.dart       # Modelos de dados (Avaliacao, Projeto)
├── services/
│   └── avaliacao_service.dart # Serviço para gerenciar avaliações
└── pages/
    ├── qr_scanner_page.dart # Página de leitura de QR Code
    ├── avaliacao_page.dart  # Formulário de avaliação
    └── historico_page.dart  # Histórico de avaliações
```

## Como Usar

### 1. Instalação
```bash
flutter pub get
```

### 2. Execução
```bash
flutter run
```

### 3. Fluxo de Uso
1. **Tela Inicial**: Escolha entre fazer login ou escanear QR Code
2. **Escanear QR Code**: Use a câmera ou faça upload de imagem
3. **Avaliar Projeto**: Preencha o formulário com suas observações
4. **Login**: Acesse seu histórico de avaliações
5. **Histórico**: Visualize todas as avaliações realizadas

## Projetos de Exemplo

O sistema inclui projetos de demonstração:
- Sistema de Gestão Escolar
- App de Delivery Sustentável
- Monitoramento de Saúde IoT
- Rede Social para Estudantes

## Configurações

### Dependências
- `qr_code_scanner: ^1.0.1`
- `camera: ^0.10.5+9`
- `image_picker: ^1.0.7`
- `shared_preferences: ^2.2.2`
- `http: ^1.1.2`
- `path_provider: ^2.1.2`

### Permissões
- **Android**: Câmera e armazenamento
- **iOS**: Câmera e galeria de fotos

## Desenvolvimento

### Adicionar Novos Projetos
Para adicionar novos projetos, edite o arquivo `lib/services/avaliacao_service.dart` e adicione na lista `_projetos`.

### Personalizar Interface
As cores e estilos podem ser personalizados no arquivo `lib/main.dart` através do `ThemeData`.

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## Suporte

Para dúvidas ou sugestões, abra uma issue no repositório do projeto.
