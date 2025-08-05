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

### **Centralized MCP Memory Solution**

```mermaid
graph TB
    subgraph "Centralized MCP Memory Solution"
        subgraph "🐳 Infrastructure Repository"
            REPO[mcp-memory-infrastructure]
            REPO --> DOCKER[Docker Compose<br/>Neo4j Container]
            REPO --> SCRIPTS[Management Scripts]
            REPO --> INIT[Project Initialization]
        end
        
        subgraph "📱 Cursor MCP Integration"
            CURSOR[Cursor IDE] --> MCP[MCP Server]
            MCP --> NEO[(Neo4j Memory<br/>Port 7688)]
        end
        
        subgraph "🔗 Project Usage"
            DADMS[DADMS Project]
            PROCOS[ProcOS Project]
            FUTURE[Future Projects]
            
            DADMS --> CONFIG1[.cursor/mcp.json]
            PROCOS --> CONFIG2[.cursor/mcp.json]
            FUTURE --> CONFIG3[.cursor/mcp.json]
            
            CONFIG1 -.->|points to| NEO
            CONFIG2 -.->|points to| NEO
            CONFIG3 -.->|points to| NEO
        end
        
        subgraph "⚙️ One-Command Setup"
            SETUP[./scripts/init-project.sh]
            SETUP --> CONFIG1
            SETUP --> CONFIG2
            SETUP --> CONFIG3
        end
    end
    
    classDef infra fill:#e3f2fd,stroke:#1976d2,stroke-width:3px
    classDef mcp fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    classDef projects fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef setup fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    
    class REPO,DOCKER,SCRIPTS,INIT infra
    class CURSOR,MCP,NEO mcp
    class DADMS,PROCOS,FUTURE,CONFIG1,CONFIG2,CONFIG3 projects
    class SETUP setup
```

### **Memory Data Organization**

```mermaid
graph LR
    subgraph "Neo4j Memory Database"
        subgraph "Project Separation"
            P1[DADMS Memories<br/>project_id: 'dadms']
            P2[ProcOS Memories<br/>project_id: 'procos']
            P3[Future Memories<br/>project_id: 'future-x']
        end
        
        subgraph "Memory Categories"
            ARCH[Architecture Decisions]
            BUGS[Bug Solutions]
            PATTERNS[Design Patterns]
            CONFIGS[Configuration Notes]
        end
        
        subgraph "Cross-Project Links"
            P1 -.->|references| P2
            P2 -.->|shares solution| P3
            P1 -.->|common pattern| P3
        end
    end
    
    subgraph "Memory Metadata"
        META[Each Memory Node]
        META --> PROJ[project_id]
        META --> CAT[category]
        META --> TIME[timestamps]
        META --> TAGS[tags]
        META --> CONTENT[content]
    end
    
    classDef project fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef category fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    classDef metadata fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    
    class P1,P2,P3 project
    class ARCH,BUGS,PATTERNS,CONFIGS category
    class META,PROJ,CAT,TIME,TAGS,CONTENT metadata
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

The initialization script handles all configuration automatically:

```mermaid
flowchart TD
    START([Run init-project.sh]) --> CHECK{Memory Service Running?}
    CHECK -->|No| ERROR[❌ Error: Start service first]
    CHECK -->|Yes| BACKUP[📋 Backup existing mcp.json]
    
    BACKUP --> EXISTS{mcp.json exists?}
    EXISTS -->|Yes| HASNEO{Has neo4j-memory config?}
    EXISTS -->|No| CREATE[📝 Create new mcp.json]
    
    HASNEO -->|Yes| VERIFY{Correct URL?}
    HASNEO -->|No| ADD[➕ Add neo4j-memory config]
    
    VERIFY -->|Yes| SKIP[✅ Skip - already configured]
    VERIFY -->|No| UPDATE[🔄 Update URL to localhost:7688]
    
    CREATE --> RULES[📋 Create .cursorrules]
    ADD --> RULES
    UPDATE --> RULES
    SKIP --> RULES
    
    RULES --> TEST[🧪 Test connection]
    TEST --> SUCCESS[🎉 Setup complete!]
    
    classDef start fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    classDef process fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef decision fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef error fill:#ffebee,stroke:#d32f2f,stroke-width:2px
    classDef success fill:#e8f5e8,stroke:#4caf50,stroke-width:3px
    
    class START,SUCCESS start
    class BACKUP,CREATE,ADD,UPDATE,RULES,TEST process
    class CHECK,EXISTS,HASNEO,VERIFY decision
    class ERROR error
    class SKIP success
```

**Usage Examples:**
```bash
# Initialize new project
./scripts/init-project.sh <project-name> <project-path>

# Setup ProcOS
./scripts/init-project.sh procos /home/user/procos

# Setup DADMS  
./scripts/init-project.sh dadms /home/user/dadms
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