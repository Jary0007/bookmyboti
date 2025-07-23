# Book My Boti – Business Plan & MVP Feature List

## Project Goal
A light-tech mobile app that connects customers with traditional Pahadi cooks (botis) for special events like Dhaam.

---

## User Roles
- **Customer**
- **Boti (Cook)**

---

## Platform
- **Frontend:** Flutter (Android + iOS)
- **Backend:** Firebase (Firestore DB, Auth, Storage, Notifications)

---

## Core Features (MVP)

### 1. Authentication
- Google Sign-In for both Customers and Botis
- Role-based user flow (choose "Customer" or "Boti" at signup)

### 2. For Customers
- Book a Boti for:
  - Wedding
  - Festive Event
  - Pahadi Dham
  - Others
- Select event date, location, expected guests
- Filter by region, Dham type, and Boti availability
- Pay commitment fee
- View & rate previous bookings

### 3. For Botis
- Register and provide:
  - Service region (mapped to nodes on Google Maps)
  - Types of events they serve
  - Max capacity (people they can cook for)
  - Base charges
- Accept/Reject bookings
- Upload food pics, rating history
- Incentive system based on commitment and reliability

### 4. Admin/Workflow Rules
- Admin-controlled logic for:
  - Zones (Node-based matching)
  - Auto-allocation fallback
  - Commitment Fee handling
  - Booking deadlines

---

## Design Principles
- Simple UI with basic navigation
- Firebase used as "manual + smart assistant" backend
- MVP-focused (manual verification of botis and bookings at first)
- Future-proofing: Add support for in-app chat, wallet, GPS tracking

---

## Revenue Model Ideas
- Commission per booking
- Service fees
- Premium listing for botis
- Event packages and add-ons
- Advertising

---

*This document will be updated as the project evolves.* 