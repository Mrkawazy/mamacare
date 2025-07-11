# MamaCare ZW – Maternal & Child Health Tracker (Zimbabwe)  

[![Flutter](https://img.shields.io/badge/Flutter-3.19-blue)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Free%20Tier-orange)](https://firebase.google.com)
[![SDG 3](https://img.shields.io/badge/SDG-3%20Health-green)](https://sdgs.un.org/goals/goal3)

A Flutter mobile app to **reduce maternal and child mortality** in Zimbabwe, starting with urban Harare.  
**Aligned with SDG 3** (Good Health & Well-Being).  

---

## 📱 Key Features  
✅ **Pregnancy Tracking**  
- Due date calculator with WHO-backed milestones.  
- Reminders for checkups, vaccinations, and nutrition tips.  

✅ **Child Growth Monitoring**  
- Track weight, height, and developmental milestones.  
- Offline data sync for low-connectivity areas.  

✅ **Emergency Clinic Finder**  
- GPS-powered map of nearby Harare clinics (Google Maps API).  

✅ **Built for Zimbabwe**  
- Works on 90% of Android/iOS devices in Harare.  
- Lightweight (optimized for low-RAM devices).  

---

## 🛠️ Tech Stack  
- **Frontend**: Flutter (Dart)  
- **Backend**: Firebase (Free Tier)  
  - **Firestore**: NoSQL database with offline persistence.  
  - **Auth**: Email/Phone sign-in.  
  - **Cloud Messaging**: Push notifications.  
- **APIs**:  
  - Google Maps (clinics).  
  - WHO health guidelines (vaccination schedules).  

---

## 🚀 Getting Started  

### Prerequisites  
- Flutter 3.19+  
- Firebase account (free tier)  
- Android Studio/Xcode (for emulators)  

### Installation  
1. Clone the repo:  
   ```bash
   git clone https://github.com/your-repo/mamacare-zw.git
   cd mamacare-zw