# FastLocation

App Flutter (Android e iOS) para entregadores da **FastDelivery** consultarem endereços por CEP e buscarem CEPs por endereço completo ou parcial.
Desafio 2 – Desenvolvimento de Sistemas Móveis.

## Funcionalidades

- Consulta de endereço por **CEP** e busca de CEP por **UF + cidade + logradouro (parcial)** na API pública [ViaCEP](https://viacep.com.br/ws)
- Tela de **abertura animada** com redirecionamento automático
- **Loading** durante a consulta externa
- Componente de **busca sem resultado**
- **Armazenamento local** (Hive): histórico de consultas e consulta de CEP sem internet quando já consultado antes
- Tela de **histórico** de endereços consultados (carrega automaticamente)
- **Traçar rota** da localização atual até o último endereço consultado (geocoding + app de mapas instalado)
- Gerenciamento de estado reativo com **MobX** (`Observer` e `reaction` para erros)

## Estrutura

```
lib/
├── main.dart
└── src/
    ├── app.dart
    ├── http/        # Dio (HttpClient) e AppException
    ├── routes/      # nomes das rotas
    ├── shared/
    │   ├── colors/ components/ metrics/ storage/
    └── modules/
        ├── initial/page/
        ├── home/    # components, controller, model, page, repositories, service
        └── history/ # controller, page
```

## Como executar

Pré-requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install) e um emulador ou celular Android/iOS.

```bash
# 1) gerar as pastas android/ e ios/ (somente essas plataformas)
flutter create --platforms=android,ios --project-name fastlocation .

# 2) instalar dependências
flutter pub get

# 3) (opcional) regenerar os arquivos *.g.dart do MobX e do Hive
dart run build_runner build --delete-conflicting-outputs

# 4) executar
flutter run
```

Os arquivos `*.g.dart` já estão no repositório; o passo 3 só é necessário se você alterar os models/controllers.
Se o `flutter create` gerar `test/widget_test.dart` referenciando `MyApp`, apague esse arquivo.

### Configurações de plataforma (necessárias)

**Android** – `android/app/src/main/AndroidManifest.xml`, dentro de `<manifest>` e antes de `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>

<queries>
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="geo" />
    </intent>
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="https" />
    </intent>
</queries>
```

**iOS** – `ios/Runner/Info.plist`, dentro de `<dict>`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>comgooglemaps</string>
    <string>waze</string>
    <string>citymapper</string>
</array>
```

## Dependências

dio, flutter_mobx, mobx, hive, hive_flutter, path, path_provider, path_provider_android, path_provider_ios, map_launcher, geocoding.
Dev: mobx_codegen, build_runner, hive_generator.
