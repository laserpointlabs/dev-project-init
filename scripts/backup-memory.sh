#!/bin/bash

# Dev Project Initializer - Memory Backup Script
# Backs up Neo4j development memory database with timestamps

set -e

BACKUP_DIR="./backups/dev-memory"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="dev-memory-backup-${TIMESTAMP}.cypher"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "🔄 Starting MCP memory backup..."

# Check if dev memory container is running  
if ! docker ps | grep -q "dev-project-memory"; then
    echo "❌ Error: dev-project-memory container is not running"
    echo "   Start it with: docker-compose up -d"
    exit 1
fi

# Create backup directory inside container (in the import directory where APOC can write)
docker exec dev-project-memory mkdir -p /var/lib/neo4j/import

# Export all data from Neo4j memory instance
docker exec dev-project-memory cypher-shell -u neo4j -p devmemorypass \
    "CALL apoc.export.cypher.all('backup.cypher', {})" || {
    echo "❌ Failed to create backup"
    exit 1
}

# Copy backup file from container
docker cp dev-project-memory:/var/lib/neo4j/import/backup.cypher "${BACKUP_DIR}/${BACKUP_FILE}"

# Compress the backup
gzip "${BACKUP_DIR}/${BACKUP_FILE}"

echo "✅ Memory backup completed: ${BACKUP_DIR}/${BACKUP_FILE}.gz"
echo "📊 Backup size: $(du -h "${BACKUP_DIR}/${BACKUP_FILE}.gz" | cut -f1)"

# Keep only last 7 backups
echo "🧹 Cleaning old backups (keeping last 7)..."
cd "$BACKUP_DIR"
ls -t dev-memory-backup-*.cypher.gz 2>/dev/null | tail -n +8 | xargs -r rm
echo "📁 Total backups: $(ls -1 dev-memory-backup-*.cypher.gz 2>/dev/null | wc -l)"

echo "🎉 Dev memory backup process completed successfully!"