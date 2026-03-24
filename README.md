# Found You AI 🚀

**Found You AI** is an enterprise-grade Attendance Management System powered by Artificial Intelligence. It leverages Face Detection to automate employee attendance, providing real-time analytics, daily payout tracking, and worker management in a sleek, premium interface.

---

## 🌟 Features

### 1. **AI Face Detection Attendance**
*   Powered by **Google ML Kit** for high-accuracy face recognition.
*   Seamless, one-tap scanning process for workers.
*   Automated attendance logging with precise timestamps.

### 2. **Advanced Analytics Dashboard**
*   **Today's Overview**: Live stats showing "Present vs. Total" workers.
*   **Weekly Trends**: Interactive line charts visualizing attendance patterns over the last 7 days.
*   **Daily Wage Tracker**: Real-time calculation of total estimated wages based on attendance.

### 3. **Worker Management Pro**
*   Complete worker lifecycle management (Register, View, Update, Delete).
*   Detailed profiles including Job Roles, Locations, and Daily Wages.
*   Direct call/message actions for absent workers.

### 4. **Professional Reporting**
*   Searchable attendance logs.
*   Export logic for daily and monthly reports (Coming Soon).

### 5. **Security & Authentication**
*   Secure Admin OTP-based login and profile setup.
*   JWT-secured backend communication.
*   Admin-only access to worker data and management tools.

---

## 🛠️ Tech Stack

### **Frontend (Mobile App)**
- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Face Detection**: [google_mlkit_face_detection](https://pub.dev/packages/google_mlkit_face_detection)
- **Analytics**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **Typography**: [Google Fonts](https://pub.dev/packages/google_fonts) (Syne, Outfit, Inter)

### **Backend (API)**
- **Environment**: [Node.js](https://nodejs.org/) & [Express](https://expressjs.com/)
- **Database**: [MongoDB Atlas](https://www.mongodb.com/atlas/database)
- **Image Storage**: [Cloudinary](https://cloudinary.com/) (for worker photos)
- **Authentication**: JWT (JSON Web Tokens)
- **Deployment**: [Vercel](https://vercel.com/) / [Render](https://render.com/)

---

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (Latest Stable)
- Node.js & npm
- MongoDB Atlas account (for backend)

### **1. Backend Setup**
1. Navigate to your backend directory.
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file and add:
   ```env
   PORT=5000
   MONGO_URI=your_mongodb_connection_string
   JWT_SECRET=your_secret_key
   CLOUDINARY_NAME=your_name
   CLOUDINARY_API_KEY=your_key
   CLOUDINARY_API_SECRET=your_secret
   ```
4. Start the server:
   ```bash
   npm start
   ```

### **2. Frontend Setup**
1. Navigate to the project directory.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Update `ApiConstants.dart` with your backend URL.
4. Run the app:
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```text
lib/
├── core/               # App-wide constants, themes, and network layers
├── features/
│   ├── attendance/     # AI Scanning, Charts, and Logs
│   ├── auth/           # OTP, Profile, and Login Flow
│   ├── workers/        # Worker Registration and CRUD
│   └── home/           # Main Dashboard
├── injection_container.dart # Dependency Injection setup
└── main.dart           # Entry point
```

---

## 🔮 Roadmap
- [ ] Export reports to PDF/Excel.
- [ ] Group/Department categorization for workers.
- [ ] GPS Geofencing for "on-site" scanning only.
- [ ] Push notifications for attendance reminders.

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

### **Made with ❤️ by Sreejesh**
If you like this project, feel free to give it a ⭐ on GitHub!
