# SAM+ | Material Administration System

<div align="center">

<img src="images/pole2.png" alt="SAM+ Logo" width="120"/>

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)

**Multi-platform enterprise system for comprehensive inventory management, logistics, and warehouse operations**

[Features](#-features) • [Technologies](#-tech-stack) • [Architecture](#-architecture) • [Installation](#-installation) • [Contact](#-contact)

</div>

---

## 📋 Description

**SAM+** is a comprehensive enterprise application developed in Flutter that enables comprehensive management of logistics and inventory operations. The system was designed to optimize material control processes, resource planning, and operation traceability in industrial environments.

<div align="center">
  <img src="images/example.gif" alt="SAM+ Demo" width="600"/>
</div>

### 🎯 Problems Solved

- **Real-time inventory control** with multi-platform synchronization
- **Complete traceability** of material movements (entries, transfers, consumptions)
- **SAP system integration** (MB51, MB52, MM60) for data reconciliation
- **Reverse logistics management** (scrap, returns, reels, transformers)
- **Resource planning** with technical data sheets and order management

---

## ✨ Features

### 📦 Inventory Management
- **New Entry/Transfer**: Material movement registration
- **Balance Report**: Consolidated stock visualization
- **Real-time inventory**: Synchronization with multiple data sources

### 🔄 Movement Control
- **Digital forms**: Movement form creation and management
- **Historical records**: Complete operation traceability
- **Reconciliations**: Accounting reconciliation tools
- **Balances**: Automatic material balance generation

<div align="center">
  <img src="images/exampleplanilla.gif" alt="Form Management" width="500"/>
</div>

### 📊 SAP Integration
- **MB51**: Material document visualization
- **MB52**: Stock by warehouse
- **MM60**: Movement analysis
- **LCL/DFLCL**: Location management

### 🔧 Planning
- **Technical data sheets**: Detailed specification management
- **Orders**: Material request control
- **FEM Dates**: Delivery planning
- **Contributions and Substitutes**: Material alternatives management

### ♻️ Reverse Logistics
- **Scrap**: Disposal material control
- **Reels and Transformers**: Returnable asset management
- **Barcode Traceability**: Barcode tracking
- **Homologation**: Homologated material control

---

## 🛠 Tech Stack

### Frontend
| Technology | Usage |
|------------|-------|
| **Flutter 3.7+** | Multi-platform UI framework |
| **Dart** | Programming language |
| **flutter_bloc** | State management (BLoC Pattern) |
| **Material Design 3** | Design system |

### Backend & Services
| Technology | Usage |
|------------|-------|
| **Firebase Auth** | User authentication |
| **Cloud Firestore** | Real-time database |
| **Supabase** | Backend as a Service (PostgreSQL) |
| **Google Apps Script** | Custom APIs |

### Tools
| Technology | Usage |
|------------|-------|
| **fl_chart** | Data visualization |
| **pdf** | Report generation |
| **file_picker** | File management |
| **csv** | Data processing |

---

## 🏗 Architecture

The project implements a clean architecture based on the **BLoC** (Business Logic Component) pattern with feature-based separation:

```
lib/
├── bloc/                    # Global application state
│   ├── main_bloc.dart       # Main BLoC
│   ├── main_state.dart      # States
│   └── main_event.dart      # Events
├── config.dart              # Centralized configuration
├── resources/               # Shared resources
│   └── constant/
│       └── apis.dart        # API endpoints
├── [feature]/               # Modules by functionality
│   ├── controller/          # Business logic
│   ├── model/               # Data models
│   └── view/                # Widgets and screens
├── login/                   # Authentication
├── home/                    # Main dashboard
├── inventario/              # Inventory management
├── planilla/                # Movement forms
├── ficha/                   # Technical data sheets
├── chatarra/                # Reverse logistics
└── ...                      # More modules
```

### Design Patterns
- **BLoC Pattern**: UI and business logic separation
- **Repository Pattern**: Data source abstraction
- **Feature-First Structure**: Functional module organization
- **Dependency Injection**: Centralized configuration

---

## 🚀 Installation

### Prerequisites
- Flutter SDK 3.7 or higher
- Dart SDK 3.0 or higher
- Firebase account
- Supabase account (optional)

### Steps

1. **Clone the repository**
```bash
git clone https://github.com/your-username/sam-inventory-management.git
cd sam-inventory-management
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure environment variables**
```bash
# Copy example file
cp .env.example .env

# Edit with your credentials
# See .env.example for required variables
```

4. **Configure Firebase**
```bash
# Option 1: Use FlutterFire CLI
dart pub global activate flutterfire_cli
flutterfire configure

# Option 2: Copy example files
cp lib/firebase_options.example.dart lib/firebase_options.dart
cp android/app/google-services.example.json android/app/google-services.json
cp ios/Runner/GoogleService-Info.example.plist ios/Runner/GoogleService-Info.plist
# Then edit with your credentials
```

5. **Run the application**
```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

---

## 📁 Environment Variables

The project uses `flutter_dotenv` to manage environment variables. See `.env.example`:

```env
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key

# Google Apps Script APIs
API_SAM=https://script.google.com/macros/s/YOUR_SCRIPT_ID/exec
API_FEM=https://script.google.com/macros/s/YOUR_SCRIPT_ID/exec
```

---

## 📸 Screenshots

<div align="center">
<table>
  <tr>
    <td align="center"><img src="images/pole.png" alt="Logo" width="100"/></td>
    <td align="center"><img src="images/truck.png" alt="Logistics" width="100"/></td>
    <td align="center"><img src="images/transformer.png" alt="Transformers" width="100"/></td>
  </tr>
</table>
</div>

---

## 🔒 Security

- Firebase Auth authentication
- Mandatory email verification
- Role-based permission management
- Environment variables for sensitive credentials
- HTTPS connections for all APIs

---

## 📈 Project Metrics

- **40+ functional modules**
- **200+ Dart files**
- Multi-platform support (Web, Android, iOS, Windows)
- Integration with 3+ external systems
- Reactive state management with BLoC

---

## 🤝 Contributing

Contributions are welcome. Please:

1. Fork the project
2. Create a branch for your feature (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is under the MIT License. See the `LICENSE` file for more details.

---

## 📬 Contact

**José Zarabanda**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/zarabandajose/)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/jozzer182)
[![Website](https://img.shields.io/badge/Website-FF7139?style=for-the-badge&logo=firefox&logoColor=white)](https://zarabanda-dev.web.app/)

---

<div align="center">

**⭐ If you find this project useful, please consider giving it a star ⭐**

Developed with ❤️ using Flutter

</div>
