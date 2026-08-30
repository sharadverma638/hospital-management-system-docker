# Documentation & Proof — `/docs`

This folder contains all supporting proof and documentation for the Docker + AWS EC2 deployment of the Hospital Management System.

## Contents

| File | What It Shows |
|---|---|
| `Hospital Management System - Dockerized Deployment on AWS.pdf` | Documentation of the project done. |
| `System Design.png` | Full system design diagram — shows the 3-tier architecture (frontend, backend, database), Docker network, exposed vs internal ports, and data persistence setup. |
| `EC2 Instance.png` | AWS EC2 instance running (Ubuntu, Free Tier) — proof of cloud deployment. |
| `Inbound Rules.png` | AWS Security Group inbound rules — confirms only ports 22 (SSH), 3000 (frontend), and 5000 (backend) are open, while MongoDB's port 27017 stays closed. |
| `Git Commits.png` | Commit history on GitHub — shows step-by-step, meaningful commits (not one giant commit) as the project was built. |
| `Docker Images Sizes.png` | Output of `docker images` — shows final optimised image sizes for both backend and frontend containers. |
| `App (Admin).png` | Application running in browser — Admin login/dashboard view. |
| `App (doctor).png` | Application running in browser — Doctor login/dashboard view. |
| `App (patient).png` | Application running in browser — Patient login/dashboard view. |
| `Database (Running).png` | MongoDB container running with data present — used as the "before" proof for the persistence test. |
| `Database (Stopped).png` | MongoDB container stopped/removed — used as the "during" proof for the persistence test, showing the container was actually destroyed. |

## Persistence Test Proof
`Database (Running).png` and `Database (Stopped).png` together prove that:
1. Data existed in MongoDB while running.
2. The MongoDB container was stopped and removed.
3. After recreating the container (via `docker-compose up -d mongo`), the same data was still present — confirming the Docker volume (`mongo-data`) correctly persists data independent of the container's lifecycle.

## Related Files (Project Root)
- `docker-compose.yml` — orchestrates all 3 services (frontend, backend, MongoDB)
- `README.md` (project root) — full project documentation, architecture, changes made, and challenges faced
