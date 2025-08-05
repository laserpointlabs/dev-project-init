# MCP Memory Infrastructure

**Centralized Neo4j memory service for all development projects**

This repository provides a **centralized MCP (Model Context Protocol) memory infrastructure** that serves as the persistent memory system for all your development projects. Instead of each project having its own memory database, this centralized service allows DADMS, ProcOS, and future projects to share and access development context through Cursor's MCP integration.

## 🎯 **What This Provides**

### **Centralized Memory**
- **Single Neo4j instance** serves all projects
- **Project-specific metadata** keeps memories organized
- **Cross-project knowledge** sharing and references
- **Unified backup/restore** system for all development context

### **Easy Project Integration**
- **One-command setup** for new projects
- **Automatic Cursor configuration** for MCP integration
- **Standardized memory patterns** across all projects
- **Cursor rules** for consistent memory usage

### **Robust Data Management**
- **Automated backups** with timestamp and compression
- **Easy restore** from any backup point
- **Health monitoring** and diagnostics
- **Production-ready** container configuration

## 🚀 **Quick Start**

### **1. Start the Memory Service**
```bash
cd /path/to/mcp-memory-infrastructure
docker-compose up -d
```

### **2. Initialize a Project**
```bash
# For ProcOS project
./scripts/init-project.sh procos /home/user/procos

# For DADMS project  
./scripts/init-project.sh dadms /home/user/dadms

# For any new project
./scripts/init-project.sh my-project /path/to/my-project
```

### **3. Use in Cursor**
1. Restart Cursor to load the new MCP configuration
2. Ask the AI to remember something about your project
3. Memories will be automatically stored in the centralized service

## 🏗️ **Architecture**

```
┌─────────────────────────────────────────┐
│         MCP Memory Infrastructure        │
├─────────────────────────────────────────┤
│  🐳 Neo4j Container (mcp-neo4j-memory)  │
│     • Port 7475: Web UI                 │
│     • Port 7688: Bolt (MCP connection)  │
│     • Persistent volumes for data       │
│     • APOC plugins enabled              │
└─────────────────────────────────────────┘
                        │
              ┌─────────┼─────────┐
              │         │         │
         ┌────▼───┐ ┌───▼───┐ ┌───▼─────┐
         │ DADMS  │ │ProcOS │ │Future   │
         │Project │ │Project│ │Projects │
         └────────┘ └───────┘ └─────────┘
         
    Each project connects via Cursor MCP:
    • .cursor/settings.json → MCP config
    • .cursorrules → Memory guidelines  
    • Automatic memory creation/retrieval
```

## 📋 **Repository Structure**

```
mcp-memory-infrastructure/
├── docker-compose.yml              # Neo4j memory service
├── README.md                       # This file
├── 
├── scripts/                        # Management utilities
│   ├── init-project.sh            # Setup new projects
│   ├── backup-memory.sh            # Create memory backups
│   ├── restore-memory.sh           # Restore from backups
│   └── check_memory.sh             # Health diagnostics
├── 
├── backups/                        # Backup storage
│   └── mcp-memory/                # Timestamped backup files
├── 
├── config/                         # Configuration templates
└── docs/                          # Additional documentation
```

## 🔧 **Management Commands**

### **Service Management**
```bash
# Start memory service
docker-compose up -d

# Stop memory service  
docker-compose down

# View logs
docker-compose logs -f neo4j-memory

# Check service status
docker-compose ps
```

### **Project Setup**
```bash
# Initialize new project
./scripts/init-project.sh <project-name> <project-path>

# Example: Setup ProcOS
./scripts/init-project.sh procos /home/user/procos
```

### **Backup & Restore**
```bash
# Create backup
./scripts/backup-memory.sh

# List available backups
ls -la backups/mcp-memory/

# Restore latest backup
./scripts/restore-memory.sh latest

# Restore specific backup
./scripts/restore-memory.sh mcp-memory-backup-20240101_120000.cypher.gz
```

### **Health Monitoring**
```bash
# Check memory service health
./scripts/check_memory.sh

# Access Neo4j web interface
open http://localhost:7475
```

## 🔗 **Service Access**

| Service | URL | Purpose |
|---------|-----|---------|
| **Neo4j Web UI** | http://localhost:7475 | Visual database interface |
| **Bolt Connection** | bolt://localhost:7688 | MCP protocol connection |
| **Authentication** | neo4j / memorypassword | Database credentials |

## 🎓 **How Projects Use This**

### **Automatic Integration**
When you run `./scripts/init-project.sh`, it creates:

1. **`.cursor/settings.json`** - MCP server configuration
2. **`.cursorrules`** - Memory usage guidelines for the project
3. **Connection test** - Verifies the memory service is accessible

### **Memory Organization**
Each memory entry includes:
- **Project ID**: `dadms`, `procos`, `my-project`
- **Category**: `architecture`, `bug`, `decision`, `pattern`
- **Content**: The actual knowledge/solution
- **Relationships**: Links to related memories
- **Timestamps**: Creation and update times

### **Cross-Project Benefits**
- **Shared Solutions**: Bug fixes discovered in one project help others
- **Architecture Patterns**: Design decisions can be referenced across projects
- **Team Knowledge**: Institutional knowledge persists across project boundaries
- **Context Preservation**: Development history maintains continuity

## 🔄 **Migration from Project-Specific Memory**

### **From DADMS Memory**
If you currently have DADMS-specific memory:

1. **Create backup** of existing DADMS memory
2. **Start centralized service** with this infrastructure
3. **Restore DADMS backup** to centralized service
4. **Update DADMS** MCP configuration to point to centralized service

### **Backup Migration Commands**
```bash
# From DADMS project directory
cd /path/to/dadms
./scripts/backup-memory.sh

# Copy backup to centralized infrastructure
cp backups/mcp-memory/mcp-memory-backup-*.cypher.gz \
   /path/to/mcp-memory-infrastructure/backups/mcp-memory/

# Start centralized service
cd /path/to/mcp-memory-infrastructure
docker-compose up -d

# Restore migrated backup
./scripts/restore-memory.sh mcp-memory-backup-*.cypher.gz
```

## 📊 **Backup Strategy**

### **Automatic Backup Management**
- **Timestamped backups**: Each backup includes date/time
- **Compressed storage**: All backups are gzipped to save space
- **Retention policy**: Automatically keeps last 7 backups
- **Easy restore**: Simple commands to restore any backup point

### **Backup File Format**
```
backups/mcp-memory/
├── mcp-memory-backup-20240101_120000.cypher.gz
├── mcp-memory-backup-20240101_180000.cypher.gz
└── mcp-memory-backup-20240102_090000.cypher.gz
```

## 🛡️ **Security & Production**

### **Development Setup**
- **Default credentials**: `neo4j/memorypassword` (change for production)
- **Local network**: Service bound to localhost only
- **No external access**: Firewall-friendly configuration

### **Production Considerations**
- **Change passwords**: Update `NEO4J_AUTH` in docker-compose.yml
- **Persistent volumes**: Data survives container restarts
- **Health checks**: Automatic service monitoring
- **Resource limits**: Uncomment memory settings for production loads

## 🔧 **Troubleshooting**

### **Common Issues**

#### **Service Won't Start**
```bash
# Check if ports are available
lsof -i :7475 -i :7688

# Check Docker is running
docker ps

# View service logs
docker-compose logs neo4j-memory
```

#### **Connection Failed**
```bash
# Test network connectivity
nc -z localhost 7688

# Check MCP configuration
cat .cursor/settings.json

# Restart Cursor to reload MCP config
```

#### **Backup/Restore Issues**
```bash
# Verify container is running
docker ps | grep mcp-neo4j-memory

# Check container logs
docker logs mcp-neo4j-memory

# Test APOC is available
docker exec mcp-neo4j-memory cypher-shell -u neo4j -p memorypassword \
  "RETURN apoc.version() AS version"
```

## 🤝 **Team Usage**

### **Multi-Developer Setup**
- **Shared service**: One memory service per team/environment
- **Project isolation**: Memories tagged by project for organization
- **Collaborative knowledge**: Team members share discovered solutions
- **Consistent setup**: Same initialization process for all team members

### **Development Workflow**
1. **Start memory service** (once per development session)
2. **Work on any project** (DADMS, ProcOS, etc.)
3. **Memories automatically stored** in centralized service
4. **Knowledge shared** across all projects and team members
5. **Regular backups** preserve all development context

---

## 🎯 **Next Steps**

1. **Start the service**: `docker-compose up -d`
2. **Initialize your projects**: `./scripts/init-project.sh <project> <path>`
3. **Test memory creation**: Ask Cursor AI to remember something
4. **Setup backups**: Schedule regular `./scripts/backup-memory.sh` runs
5. **Share with team**: Point team members to this repository

**Your centralized development memory service is ready! All projects can now share knowledge and development context seamlessly.**