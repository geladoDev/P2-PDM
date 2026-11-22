# Gerenciador de Tarefas Pessoais — P2 Programação Mobile

Aplicativo desenvolvido em **Flutter** integrado ao **Firebase Authentication**, **Firebase Realtime Database** e **SharedPreferences** para gerenciamento de tarefas pessoais.

## 1. Funcionalidades Implementadas (RF01 a RF09)
- **RF01 (Firebase Auth):** Cadastro de usuário (nome, e-mail e senha), login, logout, validação de formulários e persistência automática de sessão.
- **RF02 (Tela Inicial):** Saudação com o nome do usuário autenticado e painel em tempo real com total de tarefas cadastradas, pendentes e concluídas.
- **RF03 (Drawer Menu):** Menu lateral contendo nome e e-mail do usuário e atalhos para *Início*, *Minhas tarefas*, *Configurações*, *Sobre o aplicativo* e *Sair*.
- **RF04 a RF06 (CRUD de Tarefas e ListView):** Cadastro, listagem com `ListView.builder`, visualização de detalhes em modal, edição, exclusão e alternância rápida de situação (*Pendente* / *Concluída*), com cores e ícones por prioridade (*Baixa*, *Média*, *Alta*).
- **RF07 (Firebase Realtime Database):** Sincronização em tempo real via `StreamBuilder` (`onValue`), isolando os dados de cada usuário no nó `tarefas/{uid}`.
- **RF08 e RF09 (SharedPreferences e Temas):** Alternância entre `lightTheme` e `darkTheme` refletindo em todas as telas e persistindo localmente ao fechar e reabrir o aplicativo.

## 2. Estrutura do Projeto (`lib/`)
```text
lib/
├── main.dart
├── models/
│   ├── usuario.dart
│   └── tarefa.dart
├── screens/
│   ├── login_screen.dart
│   ├── cadastro_usuario_screen.dart
│   ├── home_screen.dart
│   ├── tarefas_screen.dart
│   ├── cadastro_tarefa_screen.dart
│   └── configuracoes_screen.dart
├── services/
│   ├── auth_service.dart
│   ├── firebase_service.dart
│   └── preferences_service.dart
├── widgets/
│   └── drawer_menu.dart
└── themes/
    └── app_theme.dart
```

## 3. Como Configurar o Firebase e Executar o Projeto

1. **Instale as dependências:**
   ```bash
   flutter pub get
   ```
2. **Configure o projeto no Firebase Console:**
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/).
   - Em **Authentication** > *Sign-in method*, ative o provedor **E-mail/senha**.
   - Em **Realtime Database**, crie um banco de dados e configure as regras de segurança para garantir que cada usuário acesse apenas suas próprias tarefas:
     ```json
     {
       "rules": {
         "usuarios": {
           "$uid": {
             ".read": "$uid === auth.uid",
             ".write": "$uid === auth.uid"
           }
         },
         "tarefas": {
           "$uid": {
             ".read": "$uid === auth.uid",
             ".write": "$uid === auth.uid"
           }
         }
       }
     }
     ```
3. **Vincule ao aplicativo Flutter:**
   - Utilize o FlutterFire CLI (`flutterfire configure`) ou adicione o arquivo `google-services.json` na pasta `android/app/`.
4. **Execute o aplicativo:**
   ```bash
   flutter run
   ```
