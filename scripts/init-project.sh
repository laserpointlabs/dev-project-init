#!/bin/bash

# MCP Memory Infrastructure - Project Initialization Script
# Sets up a new project to use the centralized MCP memory service

set -e

PROJECT_NAME=""
PROJECT_DIR=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║               MCP Memory Infrastructure                      ║"
    echo "║                Project Initialization                        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

usage() {
    echo "Usage: $0 <project-name> [project-directory]"
    echo ""
    echo "Examples:"
    echo "  $0 procos /home/user/procos"
    echo "  $0 dadms /home/user/dadms" 
    echo "  $0 my-project ./my-project"
    echo ""
    echo "This script will:"
    echo "  1. Check that MCP memory service is running"
    echo "  2. Create .cursor/settings.json with MCP configuration"
    echo "  3. Create cursor rules for memory integration"
    echo "  4. Test the connection"
}

check_memory_service() {
    print_step "Checking MCP memory service..."
    
    # Check if container is running
    if ! docker ps | grep -q "mcp-neo4j-memory"; then
        print_error "MCP memory service is not running"
        echo "Please start it first:"
        echo "  cd /path/to/mcp-memory-infrastructure"
        echo "  docker-compose up -d"
        exit 1
    fi
    
    # Check if service is responding
    if ! curl -s http://localhost:7475 > /dev/null; then
        print_error "MCP memory service is not responding on port 7475"
        exit 1
    fi
    
    print_success "MCP memory service is running and accessible"
}

create_cursor_config() {
    print_step "Creating Cursor MCP configuration..."
    
    local cursor_dir="$PROJECT_DIR/.cursor"
    local settings_file="$cursor_dir/settings.json"
    
    # Create .cursor directory
    mkdir -p "$cursor_dir"
    
    # Create or update settings.json
    cat > "$settings_file" << EOF
{
  "mcp.servers": {
    "neo4j-memory": {
      "command": "node",
      "args": [
        "/path/to/neo4j-mcp-server/dist/index.js"
      ],
      "env": {
        "NEO4J_URI": "bolt://localhost:7688",
        "NEO4J_USERNAME": "neo4j",
        "NEO4J_PASSWORD": "memorypassword"
      }
    }
  }
}
EOF
    
    print_success "Created Cursor MCP configuration: $settings_file"
}

create_cursor_rules() {
    print_step "Creating Cursor rules for memory integration..."
    
    local rules_file="$PROJECT_DIR/.cursorrules"
    
    cat > "$rules_file" << EOF
# ${PROJECT_NAME} Project Rules - MCP Memory Integration

## Memory System Integration

This project uses a centralized MCP (Model Context Protocol) memory system powered by Neo4j.

### Memory Service Configuration
- **Service**: Centralized MCP Neo4j Memory 
- **Web UI**: http://localhost:7475
- **Bolt Connection**: bolt://localhost:7688
- **Project ID**: ${PROJECT_NAME}

### When to Use Memory
- **Architecture Decisions**: Store important design choices
- **Problem Solutions**: Save debugging insights and fixes
- **Integration Patterns**: Remember how systems connect
- **Performance Optimizations**: Document what works
- **Team Knowledge**: Preserve institutional knowledge

### Memory Best Practices
1. **Clear Titles**: Use descriptive titles for easy recall
2. **Project Context**: Tag memories with project name
3. **Categories**: Use consistent categories (architecture, bug, decision, pattern)
4. **Relationships**: Connect related memories
5. **Updates**: Update memories when situations change

### Example Memory Usage
When you solve a complex problem or make an architectural decision, use the memory system:

\`\`\`
Remember this solution for ${PROJECT_NAME}: [title]
[Detailed explanation of the solution/decision]
Category: [architecture|bug|decision|pattern]
\`\`\`

### Memory Backup
The centralized memory system includes automated backups. Project-specific memories are preserved across development sessions and can be shared across team members.

For memory-related issues, check the MCP Memory Infrastructure repository.
EOF
    
    print_success "Created Cursor rules: $rules_file"
}

test_connection() {
    print_step "Testing MCP memory connection..."
    
    # Simple connection test
    if nc -z localhost 7688 2>/dev/null; then
        print_success "Successfully connected to MCP memory service (port 7688)"
    else
        print_warning "Could not connect to MCP memory service"
        echo "This may be normal - the connection will be established when Cursor starts"
    fi
}

main() {
    print_header
    
    # Parse arguments
    if [ $# -lt 1 ]; then
        usage
        exit 1
    fi
    
    PROJECT_NAME="$1"
    PROJECT_DIR="${2:-$(pwd)}"
    
    # Validate project directory
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Project directory does not exist: $PROJECT_DIR"
        exit 1
    fi
    
    PROJECT_DIR=$(realpath "$PROJECT_DIR")
    
    echo "Project Name: $PROJECT_NAME"
    echo "Project Directory: $PROJECT_DIR"
    echo ""
    
    # Execute setup steps
    check_memory_service
    create_cursor_config
    create_cursor_rules
    test_connection
    
    print_success "Project initialization complete!"
    echo ""
    echo "Next steps:"
    echo "1. Restart Cursor to load the new MCP configuration"
    echo "2. Test memory by asking the AI to remember something"
    echo "3. Check memory with: cd /path/to/mcp-memory-infrastructure && ./scripts/check_memory.sh"
    echo ""
    echo "Memory service URLs:"
    echo "  • Web UI: http://localhost:7475"
    echo "  • API: bolt://localhost:7688"
}

# Run main function
main "$@"