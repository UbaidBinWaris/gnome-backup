# Database Backup & Restore Guide

## 📊 Overview

Your GNOME backup now includes **complete database backup and restoration** for all major database systems.

## Supported Databases

### ✅ MySQL / MariaDB
- **What's backed up:**
  - All user databases (excludes system DBs)
  - Database schemas and data
  - Stored procedures, triggers, and routines
  - User list
  
- **Format:** SQL dump files (.sql)
- **Requires:** `mysqldump` command and running MySQL/MariaDB service

### ✅ PostgreSQL
- **What's backed up:**
  - All user databases
  - Global objects (roles, tablespaces)
  - Schemas, data, and functions
  
- **Format:** SQL dump files (.sql)
- **Requires:** `pg_dump` command and running PostgreSQL service

### ✅ MongoDB
- **What's backed up:**
  - All databases and collections
  - Indexes and metadata
  
- **Format:** BSON dump (MongoDB native format)
- **Requires:** `mongodump` command and running MongoDB service

### ✅ Redis
- **What's backed up:**
  - Complete Redis data snapshot
  - Redis configuration
  
- **Format:** RDB dump or AOF file
- **Requires:** `redis-cli` command and running Redis service

### ✅ SQLite
- **What's backed up:**
  - All .db, .sqlite, .sqlite3 files in home directory
  - Limited to files under 100MB
  - Maximum 50 databases
  
- **Format:** Native SQLite files (direct copy)
- **Requires:** SQLite files present in `$HOME`

---

## 🔄 Usage

### Automatic Backup

Database backup is **automatically included** when you run:

```bash
./backup-gnome.sh
```

This will:
1. Detect running database services
2. Export all databases to `databases/` directory
3. Create restore script
4. Show summary of backed up databases

### Manual Database Restore

After running `./restore-gnome.sh`, you can restore databases:

```bash
./databases/restore-databases.sh
```

**⚠️ WARNING:** This will restore database backups. Existing data may be overwritten!

---

## 📁 Directory Structure

```
databases/
├── mysql/
│   ├── database-list.txt        # List of backed up databases
│   ├── users-list.txt           # MySQL users
│   ├── database1.sql            # Database dump
│   ├── database2.sql
│   └── ...
├── postgresql/
│   ├── database-list.txt        # List of backed up databases
│   ├── globals.sql              # Roles and tablespaces
│   ├── database1.sql
│   ├── database2.sql
│   └── ...
├── mongodb/
│   ├── database-list.txt
│   ├── database1/               # BSON dump per database
│   ├── database2/
│   └── ...
├── redis/
│   ├── dump.rdb                 # Redis snapshot
│   ├── appendonly.aof           # Redis AOF (if enabled)
│   └── redis-config.txt         # Redis configuration
├── sqlite/
│   ├── database-paths.txt       # Original paths
│   ├── database1.db
│   ├── database2.sqlite3
│   └── ...
└── restore-databases.sh         # Automated restore script
```

---

## 🛠️ Requirements

### For Backup

Each database backup requires:

| Database | Required Tools | Service Name |
|----------|---------------|--------------|
| MySQL/MariaDB | `mysqldump`, `mysql` | `mysqld`, `mariadb`, or `mysql` |
| PostgreSQL | `pg_dump`, `psql` | `postgresql` |
| MongoDB | `mongodump` | `mongod` or `mongodb` |
| Redis | `redis-cli` | `redis` |
| SQLite | `sqlite3` (optional) | N/A |

### For Restore

Same tools plus:
- **Sudo access** for PostgreSQL and Redis restoration
- **Running services** for target databases
- **Sufficient disk space** for restored data

---

## 🔐 Security Considerations

### Credentials

Database backups may contain sensitive data. Consider:

1. **Don't commit to public repos** - Add to `.gitignore`:
   ```bash
   echo "databases/" >> .gitignore
   ```

2. **Use private repositories** for backups with databases

3. **Encrypt sensitive backups:**
   ```bash
   tar -czf databases.tar.gz databases/
   gpg -c databases.tar.gz  # Creates encrypted archive
   rm databases.tar.gz
   ```

### Permissions

- MySQL/MariaDB: Uses current user credentials
- PostgreSQL: Runs as `postgres` user (requires sudo)
- MongoDB: Uses default connection (no auth by default)
- Redis: Uses local socket/default config

---

## 💡 Best Practices

### 1. Regular Backups
```bash
# Daily backup with date
./backup-gnome.sh
git add .
git commit -m "Backup $(date +%Y-%m-%d)"
git push
```

### 2. Test Restores
Always test database restoration on a non-production system first:
```bash
# On test machine
./databases/restore-databases.sh
```

### 3. Selective Backup

To backup only specific databases, edit the backup script or manually run:

**MySQL:**
```bash
mysqldump mydb > mydb.sql
```

**PostgreSQL:**
```bash
sudo -u postgres pg_dump mydb > mydb.sql
```

**MongoDB:**
```bash
mongodump --db=mydb --out=./dump
```

### 4. Large Databases

For very large databases (>1GB):
- Consider using compressed dumps
- Use streaming backups
- Exclude from git and use external storage

Example with compression:
```bash
mysqldump mydb | gzip > mydb.sql.gz
```

---

## 🚨 Troubleshooting

### MySQL: "Access denied"
```bash
# Configure MySQL credentials
mysql_config_editor set --login-path=backup --user=root --password
# Enter your password when prompted
```

### PostgreSQL: "Permission denied"
```bash
# Grant privileges to current user
sudo -u postgres createuser -s $USER
```

### MongoDB: "Connection refused"
```bash
# Start MongoDB service
sudo systemctl start mongod
```

### Redis: "Could not connect"
```bash
# Start Redis service
sudo systemctl start redis
```

### SQLite: "Database is locked"
Close all applications using the SQLite database before backup.

---

## 📋 Manual Commands

### Check Running Databases

```bash
# MySQL/MariaDB
systemctl status mysqld mariadb mysql

# PostgreSQL
systemctl status postgresql

# MongoDB
systemctl status mongod

# Redis
systemctl status redis
```

### List Databases

**MySQL:**
```bash
mysql -e "SHOW DATABASES;"
```

**PostgreSQL:**
```bash
sudo -u postgres psql -l
```

**MongoDB:**
```bash
mongo --eval "db.adminCommand('listDatabases')"
```

**Redis:**
```bash
redis-cli DBSIZE
```

---

## 🔄 Automated Backup Schedule

Add to crontab for automated daily backups:

```bash
crontab -e
```

Add line:
```bash
0 2 * * * cd ~/gnome-backup && ./backup-gnome.sh && git add . && git commit -m "Auto backup $(date +\%Y-\%m-\%d)" && git push
```

This runs daily at 2 AM.

---

## ⚙️ Customization

### Exclude System Databases

Edit `backup-gnome.sh` to exclude specific databases:

```bash
# MySQL - add to exclusion list
grep -Ev "^(Database|information_schema|performance_schema|mysql|sys|mydb_to_exclude)$"
```

### Compress Backups

Modify the backup commands:

```bash
mysqldump mydb | gzip > mydb.sql.gz
pg_dump mydb | gzip > mydb.sql.gz
```

### Backup to External Storage

```bash
# Sync to external drive
rsync -av ~/gnome-backup/databases/ /mnt/backup/databases/

# Or cloud storage
rclone sync ~/gnome-backup/databases/ remote:backup/databases/
```

---

## 📊 Storage Requirements

Typical database backup sizes:

| Database Type | Compression | Size Estimate |
|--------------|-------------|---------------|
| MySQL | Text (SQL) | ~70% of data size |
| PostgreSQL | Text (SQL) | ~70% of data size |
| MongoDB | BSON | ~90% of data size |
| Redis | RDB | Variable (depends on data) |
| SQLite | Binary | 100% (direct copy) |

**Tip:** Use gzip compression to reduce backup sizes by ~70-80%.

---

## 🎯 Quick Reference

```bash
# Full backup (settings + packages + databases)
./backup-gnome.sh

# Restore everything
./restore-gnome.sh

# Restore only databases
./databases/restore-databases.sh

# View database backup summary
ls -lh databases/*/

# Check what databases were backed up
cat databases/mysql/database-list.txt
cat databases/postgresql/database-list.txt
cat databases/mongodb/database-list.txt
```

---

**Last Updated:** December 10, 2025  
**Version:** 2.1 (with database backup)
