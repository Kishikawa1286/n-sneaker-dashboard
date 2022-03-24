# n_sneaker_dashboard

## デバッグ
```
fvm flutter run -d chrome --web-renderer html
```

## デプロイ
```
fvm flutter build web --web-renderer html --dart-define=FLAVOR=prod --release
firebase deploy
```
