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
    echo "║             Universal Project Initializer                   ║"
    echo "║           Development Infrastructure Setup                   ║"
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
    print_step "Checking development memory service..."
    
    # Check if container is running
    if ! docker ps | grep -q "dev-project-memory"; then
        print_error "Development memory service is not running"
        echo "Please start it first:"
        echo "  cd /path/to/dev-project-init"
        echo "  docker-compose up -d"
        exit 1
    fi
    
    # Check if service is responding
    if ! curl -s http://localhost:9475 > /dev/null; then
        print_error "Development memory service is not responding on port 9475"
        exit 1
    fi
    
    print_success "Development memory service is running and accessible"
}

create_cursor_config() {
    print_step "Creating Cursor MCP configuration..."
    
    local cursor_dir="$PROJECT_DIR/.cursor"
    local mcp_file="$cursor_dir/mcp.json"
    
    # Create .cursor directory
    mkdir -p "$cursor_dir"
    
    # Check if mcp.json already exists
    if [ -f "$mcp_file" ]; then
        print_step "Updating existing mcp.json configuration..."
        
        # Backup existing config
        cp "$mcp_file" "$mcp_file.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Check if neo4j-memory is already configured
        if grep -q '"neo4j-memory"' "$mcp_file"; then
            print_success "neo4j-memory already configured in mcp.json"
            print_step "Verifying configuration points to centralized service..."
            
            # Verify the URL points to localhost:9688 (unusual port)
            if grep -q 'neo4j://localhost:9688' "$mcp_file"; then
                print_success "Configuration correctly points to development memory service"
            else
                print_warning "Updating neo4j-memory URL to point to development service (port 9688)"
                # Update the URL using sed
                sed -i 's|"neo4j://[^"]*"|"neo4j://localhost:9688"|g' "$mcp_file"
            fi
        else
            print_step "Adding neo4j-memory configuration to existing mcp.json"
            
            # Use jq to add the neo4j-memory configuration if available
            if command -v jq >/dev/null 2>&1; then
                # Add neo4j-memory to existing mcpServers
                jq '.mcpServers["neo4j-memory"] = {
                    "command": "uvx",
                    "args": [
                        "mcp-neo4j-memory",
                        "--db-url",
                        "neo4j://localhost:9688",
                        "--username",
                        "neo4j",
                        "--password",
                        "devmemorypass"
                    ]
                }' "$mcp_file" > "$mcp_file.tmp" && mv "$mcp_file.tmp" "$mcp_file"
            else
                print_warning "jq not available - manual configuration update needed"
                echo "Please add the following to your mcp.json mcpServers section:"
                echo '"neo4j-memory": {'
                echo '    "command": "uvx",'
                echo '    "args": ['
                echo '        "mcp-neo4j-memory",'
                echo '        "--db-url",'
                echo '        "neo4j://localhost:9688",'
                echo '        "--username",'
                echo '        "neo4j",'
                echo '        "--password",'
                echo '        "devmemorypass"'
                echo '    ]'
                echo '}'
            fi
        fi
    else
        # Create new mcp.json file
        print_step "Creating new mcp.json configuration..."
        cat > "$mcp_file" << EOF
{
    "\$schema": "https://json.schemastore.org/mcp.json",
    "description": "${PROJECT_NAME} Development MCP Server Configuration with Dev Project Initializer",
    "mcpServers": {
        "neo4j-memory": {
            "command": "uvx",
            "args": [
                "mcp-neo4j-memory",
                "--db-url",
                "neo4j://localhost:9688",
                "--username",
                "neo4j",
                "--password",
                "devmemorypass"
            ]
        }
    }
}
EOF
    fi
    
    print_success "Cursor MCP configuration ready: $mcp_file"
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
    print_step "Testing development memory connection..."
    
    # Simple connection test
    if nc -z localhost 9688 2>/dev/null; then
        print_success "Successfully connected to development memory service (port 9688)"
    else
        print_warning "Could not connect to development memory service"
        echo "This may be normal - the connection will be established when Cursor starts"
    fi
}

main() {
    print_header
    
    # Parse arguments
    if [ $# -lt 1 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        usage
        exit 0
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
    echo "✅ Configuration files updated:"
    echo "   • .cursor/mcp.json - MCP server configuration"
    echo "   • .cursorrules - Memory usage guidelines"
    echo ""
    echo "📋 Next steps:"
    echo "1. 🔄 Restart Cursor to load the new MCP configuration"
    echo "2. 🧠 Test memory by asking the AI to remember something about ${PROJECT_NAME}"
    echo "3. 🔍 Check memory status: cd /path/to/dev-project-init && ./scripts/check_memory.sh"
    echo "4. 📊 View memories: http://localhost:9475 (neo4j/devmemorypass)"
    echo ""
    echo "🌐 Development memory service URLs:"
    echo "   • Neo4j Web UI: http://localhost:9475 (unusual port)"
    echo "   • Bolt API: neo4j://localhost:9688 (unusual port)"
    echo "   • Project ID: ${PROJECT_NAME}"
    echo ""
    echo "💡 Note: Using unusual ports (9xxx) to avoid conflicts with application ports"
}

# Run main function
main "$@"