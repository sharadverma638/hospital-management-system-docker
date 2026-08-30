# Hospital Management System — Dockerized Deployment

## Project Summary
An existing open-source 3-tier Hospital Management System (MERN stack) was containerized using Docker, connected with Docker Compose, and deployed on an AWS EC2 instance. The original app had no Docker setup — this project adds it, without changing app functionality.

Done for: **TrainWithShubham — DevOps Phase 1 Practical Exam**

## Objective
- Take an existing 3-tier app and deploy it using real DevOps practices.
- Apply Docker best practices (multi-stage builds, small images, non-root user).
- Set up container networking and persistent database storage.
- Deploy on AWS EC2.
- Keep clean Git history.

## Original Repo
[MKPTechnicals/Hospital-Management-System-MERN](https://github.com/MKPTechnicals/Hospital-Management-System-MERN) — not Dockerized originally.

## Tech Stack
| Layer | Tech |
|---|---|
| Frontend | React, Tailwind CSS, React Router |
| Backend | Node.js, Express, JWT, bcrypt |
| Database | MongoDB (Mongoose) |
| Container | Docker, Docker Compose |
| Web Server | Nginx (serves frontend) |
| Cloud | AWS EC2 (Ubuntu, Free Tier) |

## Architecture
```
Browser → Frontend (React+Nginx, port 3000, public)
              ↓
       Backend (Node+Express, port 5000, public)
              ↓
       MongoDB (port 27017, internal only)
              ↓
       Docker Volume (mongo-data) — persists DB data
```
All 3 containers run inside one EC2 instance, connected via custom Docker network `hospital-net`. Only frontend and backend ports are opened in AWS Security Group; MongoDB stays hidden.

*(Full hand-drawn system diagram included separately in submission.)*

## Folder Structure — Before Docker
```
backend/  → server.js, createAdmin.js, models/, routes/, package.json
frontend/ → src/components/, App.js, package.json
```
No Dockerfile, no compose file, no .dockerignore. DB connection was a hardcoded placeholder. Frontend API calls used `localhost`.

## Folder Structure — After Docker
```
backend/  → Dockerfile (added), .dockerignore (added), server.js (modified), createAdmin.js (modified)
frontend/ → Dockerfile (added), .dockerignore (added), src/components (modified)
docker-compose.yml (added)
update-ip.sh (added)
.gitignore (added)
```

## Changes Made To Original Code
1. **Backend (`server.js`, `createAdmin.js`)** — replaced hardcoded MongoDB connection string with `process.env.MONGO_URI`, so DB URL is passed securely via Docker Compose instead of hardcoded.
2. **Frontend (components)** — replaced ~20+ hardcoded `localhost:5000` API URLs with the EC2 public IP, since the browser (not Docker) makes these calls and can't resolve `localhost` or Docker service names.
3. **Added all Docker files** — Dockerfiles, `.dockerignore`, `docker-compose.yml`, `.gitignore` (none existed before).
4. **Added `update-ip.sh`** — automation script to update IP, rebuild frontend, and restart containers after every EC2 restart (since EC2 IP changes each time).

No core app logic or database schema was changed — only deployment-related config.

## Docker Optimisation
- Multi-stage builds for both backend and frontend.
- Alpine-based images (`node:18-alpine`, `nginx:alpine`) for smaller size.
- Non-root user in backend container.
- `.dockerignore` to skip `node_modules`, logs, git files.
- Nginx serves frontend (production-ready, lighter than `npm start`).
- `restart: unless-stopped` for auto-recovery.

**Final Image Sizes:** Backend — 207MB | Frontend — 95.7MB

## Networking & Security
- Custom Docker network: `hospital-net`
- Backend connects to DB via service name: `mongodb://mongo:27017/hospital`
- Security Group opens only ports: `22` (SSH), `3000` (frontend), `5000` (backend)
- MongoDB port `27017` is never exposed — no `ports:` mapping in compose file, not opened in Security Group.

## Persistent Data
MongoDB stores data at `/data/db`, mounted to a named volume `mongo-data`:
```yaml
volumes:
  - mongo-data:/data/db
```
**Tested:** MongoDB container was deleted and recreated — all existing data (patients, doctors, admin) stayed intact. Confirms persistence works correctly.

## How To Run
```bash
git clone https://github.com/<your-username>/hospital-management-system-docker.git
cd hospital-management-system-docker
docker-compose up -d --build
docker exec -it hospital-backend node createAdmin.js
```
Open `http://<ec2-public-ip>:3000` in browser.

Since EC2 IP changes after restart, run `./update-ip.sh` each time to auto-fix and redeploy.

## Challenges Faced
1. **Hardcoded `localhost` in frontend** — broke on EC2 since browser (not Docker) makes API calls. Fixed by switching to EC2 public IP.
2. **Docker Compose missing** — Snap-installed Docker conflicted with `apt` compose plugin. Fixed using standalone `docker-compose` binary.
3. **Stale frontend image** — manual `docker build` created an image separate from the one Compose used. Fixed by always rebuilding via `docker-compose build --no-cache`.
4. **EC2 IP changes on restart** — kept breaking frontend URLs. Solved with the `update-ip.sh` automation script.
5. **Hardcoded DB connection string** — switched to environment variable (`MONGO_URI`) passed via Compose.

## What I Learned
- Difference between container-to-container communication (Docker network) vs browser-to-server communication (needs real public IP).
- Why database ports must never be exposed publicly.
- How Docker volumes keep data safe independent of container lifecycle.
- Real AWS EC2 deployment, Security Groups, and handling dynamic public IPs.

## Project By
**Sharad Verma** — TrainWithShubham, DevOps Phase 1 Practical Exam
