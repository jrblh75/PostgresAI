# Moving PostgresAI Directory - GitHub Link Maintenance

## Current Setup
✅ **Git repository initialized**  
✅ **All files committed to local git**  
✅ **Remote origin set to: https://github.com/jrblh75/PostgresAI.git**  
✅ **Ready to push to GitHub**

---

## Step 1: Push to GitHub (Do this NOW)
```bash
# From current location: /Users/jrhollisbl75/PostgresAI
git push -u origin main
```

---

## Step 2: If You Move the Directory Later

### Option A: Move and Reconnect (Recommended)
```bash
# 1. Stop Docker containers first
docker-compose down

# 2. Move directory to new location
mv /Users/jrhollisbl75/PostgresAI /new/path/PostgresAI

# 3. Navigate to new location
cd /new/path/PostgresAI

# 4. Verify git connection is intact
git status
git remote -v

# 5. Continue working normally
docker-compose up -d
```

### Option B: Fresh Clone (If git gets broken)
```bash
# 1. Stop containers and backup any local changes
docker-compose down

# 2. Clone fresh from GitHub to new location
git clone https://github.com/jrblh75/PostgresAI.git /new/path/PostgresAI

# 3. Copy any custom .env files or local changes
cp /old/path/PostgresAI/.env /new/path/PostgresAI/.env

# 4. Navigate and start
cd /new/path/PostgresAI
docker-compose up -d
```

---

## Step 3: Docker Volume Considerations

### ✅ **Good News**: Docker volumes are persistent by name
Your data will remain intact because volumes are named:
- `postgres_data`
- `ollama_data` 
- `open-webui-data`
- etc.

### 📋 **After Moving Directory**:
```bash
# Check volumes still exist
docker volume ls | grep postgres

# Verify containers can access data
docker-compose up -d
docker-compose ps
```

---

## Step 4: Update Local Development

### If you work from multiple locations:
```bash
# Keep repository in sync
git pull origin main          # Get latest changes
git add .                     # Stage local changes
git commit -m "Update config" # Commit changes  
git push origin main          # Push to GitHub
```

---

## Step 5: Troubleshooting Moving Issues

### If git connection breaks:
```bash
# Check current remote
git remote -v

# Re-add remote if missing
git remote add origin https://github.com/jrblh75/PostgresAI.git

# Force push if needed
git push -f origin main
```

### If Docker volumes don't reconnect:
```bash
# List all volumes
docker volume ls

# Inspect specific volume
docker volume inspect postgres_data

# If volume is missing, restore from backup
# (Use your backup archive: PostgresAI_Complete_Documentation_*.tar.gz)
```

---

## Step 6: Best Practices When Moving

### ✅ **Always Do Before Moving**:
1. `git add . && git commit -m "Save before move"`
2. `git push origin main`
3. `docker-compose down`
4. Create backup: `./create_docs_archive.sh`

### ✅ **After Moving**:
1. `cd /new/path/PostgresAI`
2. `git status` (verify git working)
3. `docker-compose up -d`
4. `git pull origin main` (get any remote changes)

---

## Quick Reference Commands

```bash
# Check git status
git status && git remote -v

# Full backup before move
git add . && git commit -m "Backup" && git push origin main
docker-compose down
./create_docs_archive.sh

# After move - verify everything
git status
docker volume ls | grep postgres
docker-compose up -d
docker-compose ps

# Sync with GitHub
git pull origin main
git push origin main
```

---

## Emergency Recovery

If everything breaks after moving:
```bash
# 1. Stop everything
docker-compose down

# 2. Fresh clone
git clone https://github.com/jrblh75/PostgresAI.git

# 3. Copy your custom .env files
cp /backup/.env ./PostgresAI/.env

# 4. Start fresh
cd PostgresAI
docker-compose up -d
```

**Note**: Docker volumes persist by name, so your data should survive directory moves!
