#  MyService (docker startup)

This repo runs:
- **Backend API** (Express) on **port 5000**
- **Frontend (Flutter web)** served by **Nginx** on **port 8080**

> The frontend is a static site served on **8080**. It calls the backend API on **5000** using `API_BASE_URL` that is baked into the Flutter web build at **build-time**.

---

## 1) Start both backend + frontend
From the repo root:

### Determine your API URL (important for Tailscale)
The Flutter web app calls the backend using `API_BASE_URL` that is **baked at build-time**.

If you are using Tailscale, use the **Tailscale IP** that your browser/device can reach.

Get Tailscale IP:
```bash
TS_IP=$(tailscale ip -4)
```

### Build and start containers
```bash
sudo API_BASE_URL=http://$TS_IP:5000 docker-compose up -d --build
```

### Check containers
```bash
sudo docker-compose ps
```


---

## 2) Open the app
- Frontend (web UI):
  - `http://<VM-IP>:8080`
- Backend API base URL (used by frontend):
  - `http://<VM-IP>:5000`

---

## 3) Useful commands
View logs:
```bash
sudo docker-compose logs -f --tail=100
```

Restart:
```bash
sudo docker-compose restart
```

Stop:
```bash
sudo docker-compose down
```

---

## Notes / common issues
1. If the frontend shows an error like **API_BASE_URL is not set**, you must rebuild the Flutter web container with the correct `API_BASE_URL` (as shown above).
2. Don’t use `localhost` in `API_BASE_URL` when accessing from another machine/browser. Use `http://<VM-IP>:5000`.

