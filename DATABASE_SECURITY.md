# Database Backup Security & Privacy

## ⚠️ Important Security Notice

Your database backups may contain **sensitive information** including:
- User credentials and passwords
- Personal data
- API keys and secrets
- Financial information
- Private communications

## 🔒 Recommendations

### Option 1: Exclude Databases from Git (Recommended for Public Repos)

Add to your `.gitignore`:

```bash
# Exclude all database backups
databases/

# Keep the restore script
!databases/restore-databases.sh
!databases/README.md
```

Apply it:
```bash
echo "databases/" >> .gitignore
echo "!databases/restore-databases.sh" >> .gitignore
git add .gitignore
git commit -m "Exclude database backups from version control"
```

### Option 2: Use Private Repository

If you want to backup databases to Git:
1. Ensure your repository is **private**
2. Never share clone URLs publicly
3. Use SSH keys for authentication
4. Regularly audit repository access

### Option 3: Encrypt Database Backups

Encrypt before committing:

```bash
# Create encrypted archive
tar -czf databases.tar.gz databases/
gpg --symmetric --cipher-algo AES256 databases.tar.gz
rm databases.tar.gz

# Add to git
git add databases.tar.gz.gpg
git commit -m "Encrypted database backup"
```

Decrypt when needed:
```bash
gpg -d databases.tar.gz.gpg | tar -xz
```

### Option 4: External Backup Storage

Store databases separately from Git:

**Local External Drive:**
```bash
rsync -av ~/gnome-backup/databases/ /mnt/external/db-backup/
```

**Network Storage (NAS):**
```bash
rsync -av ~/gnome-backup/databases/ user@nas:/backup/databases/
```

**Cloud Storage (with encryption):**
```bash
# Using rclone with encryption
rclone sync ~/gnome-backup/databases/ crypted-remote:databases/
```

## 🛡️ Security Best Practices

### 1. Review Data Before Committing
```bash
# Check what's in your backups
ls -lh databases/
cat databases/mysql/database-list.txt
```

### 2. Sanitize Test Databases
For test/development databases, consider:
- Using dummy data
- Anonymizing sensitive fields
- Excluding sensitive tables

### 3. Use Database-Specific Security
- MySQL: Use `.my.cnf` for credentials
- PostgreSQL: Use `.pgpass` for passwords
- MongoDB: Use authentication and TLS
- Redis: Use password protection

### 4. Regular Security Audits
```bash
# Check repository history for sensitive data
git log --all --full-history --source -- databases/

# Check remote repository access
git remote -v
```

## 📋 Recommended .gitignore

For most users, use this `.gitignore`:

```gitignore
# Sensitive database backups
databases/mysql/*.sql
databases/postgresql/*.sql
databases/mongodb/*/
databases/redis/*.rdb
databases/redis/*.aof
databases/sqlite/*.db
databases/sqlite/*.sqlite*

# Keep scripts and docs
!databases/*.sh
!databases/*.md
!databases/*.txt
```

## 🔑 Alternative: Separate Repositories

Consider splitting into two repositories:

**Public Repo:** Settings and configurations
- `backup-gnome.sh`
- `restore-gnome.sh`
- Extensions, themes, icons
- Package lists
- Documentation

**Private Repo:** Sensitive data
- Database backups
- Encrypted credentials
- Private configurations

## 📞 If Data Is Already Exposed

If you accidentally committed sensitive data:

1. **Remove from history:**
```bash
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch databases/*" \
  --prune-empty --tag-name-filter cat -- --all
```

2. **Force push:**
```bash
git push origin --force --all
```

3. **Rotate credentials:**
- Change database passwords
- Update API keys
- Notify affected parties

4. **Contact platform support:**
- GitHub: Use their sensitive data removal tool
- GitLab: Request data removal
- Bitbucket: Contact support

## 🎯 Quick Decision Guide

**Should I commit database backups to Git?**

| Scenario | Recommendation |
|----------|----------------|
| Public repository | ❌ Never commit databases |
| Private repository with team | ⚠️ Only if all members need access |
| Personal private repo | ⚠️ Consider encryption or external backup |
| Test/development data | ✅ OK if sanitized/anonymized |
| Production data | ❌ Use dedicated backup solution |

---

**Remember:** Git history is permanent. Think twice before committing sensitive data!

**Last Updated:** December 10, 2025
