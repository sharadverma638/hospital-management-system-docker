# Backend — Hospital Management System

This is the **backend (API server)** of the Hospital Management System, built with **Node.js** and **Express**. It handles authentication, and all data operations for patients, doctors, and admin.

## Tech Stack
- Node.js + Express
- MongoDB (via Mongoose & MongoDB Driver)
- JWT — authentication
- bcrypt — password hashing
- dotenv — environment variable support

## Folder Structure
```
backend/
├── models/          # Mongoose schemas (Patient, Doctor, Admin, Appointment, etc.)
├── routes/          # API route handlers
├── server.js         # Main entry point — starts the Express server
├── createAdmin.js    # One-time script to create the first Admin account
├── package.json
├── Dockerfile         # Containerizes this backend service
└── .dockerignore
```

## Entry Point
```json
"main": "server.js"
```
Server runs on:
```js
const PORT = process.env.PORT || 5000;
```

## Database Connection
Originally, `server.js` and `createAdmin.js` had a hardcoded placeholder for the MongoDB connection string. This was changed to use an environment variable instead:
```js
mongoose.connect(process.env.MONGO_URI, {...})
```
`MONGO_URI` is supplied securely via `docker-compose.yml` at runtime — it is never hardcoded in the source code.

## Docker Setup
- Multi-stage build using `node:18-alpine` (small, lightweight base image)
- Runs as a **non-root user** inside the container for better security
- `.dockerignore` excludes `node_modules`, `.env`, and other unnecessary files
- Final image size: **~207MB**

## Running Standalone (Without Docker)
```bash
npm install
# Create a .env file with:
# MONGO_URI=your_mongodb_connection_string
# PORT=5000
node server.js
```

## Creating the First Admin Account
This must be run once, manually (not automatic on container start):
```bash
node createAdmin.js
```
When running via Docker:
```bash
docker exec -it hospital-backend node createAdmin.js
```

## API Routes (Examples)
- `/api/login` — login for Admin, Doctor, Patient
- `/api/signup` — patient registration
- `/api/patient/*` — patient profile, appointments, prescriptions, care team
- `/api/doctor/*` — doctor profile, appointments, prescriptions

## Notes
- Backend port `5000` is exposed publicly (via Docker Compose and AWS Security Group), since the frontend (running in the user's browser) calls these API endpoints directly.
- This backend connects to MongoDB using the Docker service name `mongo` (e.g., `mongodb://mongo:27017/hospital`) — not a hardcoded IP.
