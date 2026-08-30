# Frontend — Hospital Management System

This is the **frontend (user interface)** of the Hospital Management System, built with **React** (Create React App) and styled using **Tailwind CSS**.

## Tech Stack
- React 18
- React Router DOM — page navigation
- Tailwind CSS — styling
- Lucide React — icons
- Create React App (`react-scripts`) — build tooling

## Folder Structure
```
frontend/
├── public/                # Static assets
├── src/
│   ├── components/         # Login, SignUp, Patient, Doctors, Admins pages
│   ├── App.js
│   └── index.js
├── package.json
├── tailwind.config.js
├── Dockerfile               # Containerizes this frontend service
└── .dockerignore
```

## Available Scripts
```json
"start": "react-scripts start",   // development server
"build": "react-scripts build",   // production build
"test": "react-scripts test"
```

## API Connection (Important Change Made)
All components originally called the backend using a **hardcoded local address**:
```js
fetch('http://localhost:5000/api/login', {...})
```
Since this frontend is served as a **static website** (built once, then hosted via Nginx), these calls happen directly from the **user's browser** — not from inside Docker. This means `localhost` and Docker service names (like `backend`) do not work once deployed.

**Fix applied:** All hardcoded URLs were updated to use the **AWS EC2 public IP** instead, e.g.:
```js
fetch('http://<ec2-public-ip>:5000/api/login', {...})
```

⚠️ Since the EC2 public IP changes every time the instance is stopped and restarted, an automation script (`update-ip.sh`, in the project root) updates these URLs and rebuilds this frontend image automatically after every restart.

## Docker Setup
- **Stage 1:** Uses `node:18-alpine` to install dependencies and run `npm run build`, producing an optimized static build (HTML/CSS/JS).
- **Stage 2:** Uses `nginx:alpine` to serve only the final built files — no Node.js, no source code, no `node_modules` in the final image.
- Final image size: **~95.7MB**
- Container listens on port `80` internally, mapped to port `3000` externally via Docker Compose.

## Running Standalone (Without Docker)
```bash
npm install
npm start
```
Runs on `http://localhost:3000` (development mode only — for production, use the Docker build).

## Pages / Components
- `Login.js` — Login for Admin, Doctor, Patient
- `SignUp.js` — Patient registration
- `Patient.js` — Patient dashboard (appointments, prescriptions, care team)
- `Doctors.js` — Doctor dashboard (patients, appointments, prescriptions)
- `Admins.js` — Admin dashboard

## Notes
- This is a pure static frontend — it has no server-side logic of its own; all data operations happen via API calls to the backend.
- Port `3000` is exposed publicly, since this is the entry point users access via browser.
