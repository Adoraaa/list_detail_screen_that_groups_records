# 🚀 Sprint Task Manager (Flutter Todo App)

Modern, kullanıcı dostu ve pürüzsüz animasyonlara sahip bir görev yönetim uygulaması. Bu proje, Flutter ile tek bir ekranda zengin bir UI/UX deneyimi sunmak amacıyla geliştirilmiştir. 

Sprint takibi yapan ekiplerin veya bireylerin günlük görevlerini organize etmesini, önceliklendirmesini ve ilerlemesini görsel olarak takip etmesini sağlar.

## ✨ Özellikler

* **📊 Dinamik İlerleme Çubuğu (Progress Bar):** Tamamlanan ve aktif görevlerin oranına göre eş zamanlı güncellenen, yüzdelik dilim hesaplamalı üst bilgi alanı.
* **📅 Gerçek Zamanlı Tarih:** Uygulamanın her açılışında günün tarihini otomatik olarak gösteren dinamik başlık yapısı.
* **📂 Akıllı Gruplama (Accordion List):** Görevlerin "Aktif" ve "Tamamlanan" olarak iki farklı genişletilebilir (ExpansionTile) listede tutulması.
* **🎛️ Modal Bottom Sheet ile Hızlı İşlemler:** Klavyeye duyarlı olarak aşağıdan yukarı açılan şık bir pencere üzerinden hem **Yeni Görev Ekleme** hem de var olan **Görevi Düzenleme** imkanı.
* **🎨 Öncelik Seviyeleri:** Görevlere Düşük (Yeşil), Orta (Turuncu) ve Yüksek (Kırmızı) öncelikler atayabilme ve bunları renk kodlarıyla listede görebilme.
* **👆 Kaydırarak Silme (Swipe-to-Delete):** Görev kartlarını sağdan sola kaydırarak pürüzsüz bir animasyonla (`Dismissible`) listeden çıkarma.
* **✅ Tek Tıkla Durum Değiştirme:** Görevleri aktiften tamamlananlara (veya tam tersi) anında taşıyan state yönetimi.

## 📱 Ekran Görüntüleri

*(Buraya projenin ekran görüntülerini veya bir GIF'ini ekleyebilirsin)*

| Ana Ekran | Görev Ekleme/Düzenleme |
|:---:|:---:|
| <img src="'/Users/samedbucakli/Desktop/Mobile App Task/List Detail Screen That Groups Records/ScreenShot/Ekran Resmi 2026-05-02 14.28.02.png'" width="250"> | <img src="'/Users/samedbucakli/Desktop/Mobile App Task/List Detail Screen That Groups Records/ScreenShot/Ekran Resmi 2026-05-02 14.28.18.png'" width="250"> |

## 🛠️ Kullanılan Teknolojiler

* **Dil:** Dart
* **Framework:** Flutter (Material Design)
* **Mimari:** Tek Dosya (Single-file) Stateful Widget Yönetimi (Geliştirilmeye ve farklı state management çözümlerine entegre edilmeye uygun bir temel).

## 🚀 Kurulum

Projeyi yerel ortamında çalıştırmak için aşağıdaki adımları izleyebilirsin:

1. Repoyu bilgisayarına klonla:
   ```bash
   git clone [https://github.com/](https://github.com/)<senin-kullanici-adin>/sprint-task-manager.git
