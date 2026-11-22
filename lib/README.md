# Gerenciador de Tarefas - Configuração e Execução

Este documento apresenta as orientações necessárias para configurar e executar o projeto Flutter localmente.

## Pré-requisitos

Antes de iniciar, certifique-se de ter os seguintes recursos instalados em sua máquina:

* [Flutter SDK](https://docs.flutter.dev/get-started/install)
* [Git](https://git-scm.com/)
* Android Studio ou VS Code (com as extensões do Flutter e Dart)
* Emulador Android/iOS configurado ou dispositivo físico conectado com a depuração USB ativada

## Passo a Passo para Configuração e Execução

### 1. Clonar o repositório

```bash
git clone https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
cd SEU_REPOSITORIO
```

### 2. Instalar as dependências

Na raiz do projeto, execute o comando abaixo para baixar os pacotes definidos no `pubspec.yaml`:

```bash
flutter pub get
```

### 3. Configuração do Firebase

As credenciais de inicialização (`FirebaseOptions`) já estão configuradas diretamente no arquivo `lib/main.dart`, conectando o aplicativo ao projeto Firebase (`prova-pdm-532ff`) e ao Realtime Database.

Caso deseje utilizar uma instância própria do Firebase:

1. Crie um projeto no [Console do Firebase](https://console.firebase.google.com/).
2. Ative o **Authentication** (método de login por E-mail/Senha) e o **Realtime Database**.
3. Atualize os parâmetros de `FirebaseOptions` no arquivo `lib/main.dart` e, caso utilize Android, substitua o arquivo `android/app/google-services.json`.

### 4. Executar o aplicativo

Verifique se o emulador ou dispositivo físico está sendo reconhecido pelo Flutter:

```bash
flutter devices
```

Em seguida, execute o aplicativo:

```bash
flutter run
```