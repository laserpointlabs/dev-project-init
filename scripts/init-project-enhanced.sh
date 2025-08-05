#!/bin/bash

# Enhanced MCP Memory Infrastructure - Project Initialization Script
# Sets up a new project with comprehensive DADMS-derived configurations and rules

set -e

PROJECT_NAME=""
PROJECT_DIR=""
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")/config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║          Enhanced Universal Project Initializer             ║"
    echo "║       Advanced Development Infrastructure Setup              ║"
    echo "║          With DADMS-Derived Configurations                  ║"
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
    echo "  $0 my-ai-project ./my-ai-project"
    echo "  $0 backend-service /workspace/services/backend"
    echo ""
    echo "This enhanced script will:"
    echo "  1. Check that MCP memory service is running"
    echo "  2. Create comprehensive .cursor/mcp.json with all MCP servers"
    echo "  3. Copy all DADMS-derived cursor rules (7 advanced .mdc files)"
    echo "  4. Create adaptive .cursorrules with project-specific context"
    echo "  5. Test all connections and validate setup"
    echo ""
    echo "Features included:"
    echo "  • Neo4j Memory integration (automatic memory storage)"
    echo "  • Neo4j Cypher server (graph database queries)"
    echo "  • HuggingFace MCP (ML model access)"
    echo "  • Advanced development standards and quality rules"
    echo "  • Comprehensive testing standards"
    echo "  • Architecture maintenance guidelines"
    echo "  • Automatic memory management"
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

substitute_templates() {
    local file_path="$1"
    local project_name="$2"
    
    # Use sed to replace template placeholders
    sed -i "s/{{PROJECT_NAME}}/$project_name/g" "$file_path"
}

create_enhanced_cursor_config() {
    print_step "Creating enhanced Cursor MCP configuration..."
    
    local cursor_dir="$PROJECT_DIR/.cursor"
    local mcp_file="$cursor_dir/mcp.json"
    local template_file="$CONFIG_DIR/cursor/mcp-template.json"
    
    # Create .cursor directory
    mkdir -p "$cursor_dir"
    
    # Check if mcp.json already exists
    if [ -f "$mcp_file" ]; then
        print_step "Backing up existing mcp.json configuration..."
        cp "$mcp_file" "$mcp_file.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Copy and customize the enhanced template
    print_step "Installing enhanced MCP configuration with all servers..."
    cp "$template_file" "$mcp_file"
    substitute_templates "$mcp_file" "$PROJECT_NAME"
    
    print_success "Enhanced Cursor MCP configuration ready: $mcp_file"
    echo "  • neo4j-memory: Automatic memory storage and retrieval"
    echo "  • neo4j-cypher: Graph database queries and operations"
    echo "  • huggingface-mcp: ML model access and inference"
}

copy_cursor_rules() {
    print_step "Installing comprehensive Cursor rules from DADMS..."
    
    local cursor_dir="$PROJECT_DIR/.cursor"
    local rules_dir="$cursor_dir/rules"
    local template_rules_dir="$CONFIG_DIR/cursor/rules"
    
    # Create rules directory
    mkdir -p "$rules_dir"
    
    # Copy all .mdc rule files
    if [ -d "$template_rules_dir" ]; then
        print_step "Copying advanced development rules..."
        cp "$template_rules_dir"/*.mdc "$rules_dir/"
        
        # Substitute project name in all rule files
        for rule_file in "$rules_dir"/*.mdc; do
            if [ -f "$rule_file" ]; then
                substitute_templates "$rule_file" "$PROJECT_NAME"
            fi
        done
        
        print_success "Installed $(ls "$rules_dir"/*.mdc | wc -l) advanced cursor rules:"
        ls "$rules_dir"/*.mdc | sed 's|.*/||' | sed 's/^/  • /'
    else
        print_warning "Template rules directory not found: $template_rules_dir"
    fi
}

create_adaptive_cursorrules() {
    print_step "Creating adaptive project-specific cursor rules..."
    
    local rules_file="$PROJECT_DIR/.cursorrules"
    local template_file="$CONFIG_DIR/cursor/cursorrules-template"
    
    if [ -f "$template_file" ]; then
        # Copy and customize the template
        cp "$template_file" "$rules_file"
        substitute_templates "$rules_file" "$PROJECT_NAME"
        
        print_success "Created adaptive cursor rules: $rules_file"
    else
        print_warning "Template cursorrules not found, creating basic rules..."
        
        cat > "$rules_file" << EOF
# ${PROJECT_NAME} Project Rules - Enhanced MCP Memory Integration

## Memory System Integration
This project uses a centralized MCP (Model Context Protocol) memory system powered by Neo4j.

### Memory Service Configuration
- **Service**: Centralized MCP Neo4j Memory 
- **Web UI**: http://localhost:9475
- **Bolt Connection**: bolt://localhost:9688
- **Project ID**: ${PROJECT_NAME}

### Advanced MCP Integration
- **Neo4j Memory**: Automatic storage and retrieval
- **Neo4j Cypher**: Graph database operations
- **HuggingFace MCP**: ML model access

### Development Standards
Follow the comprehensive development standards defined in .cursor/rules/ for:
- Code quality and architecture maintenance
- Testing standards and best practices
- Memory management and storage patterns
- Development workflow and standards

### Memory Best Practices
1. **Automatic Storage**: Memory is stored automatically during development
2. **Clear Context**: Provide clear project context in all interactions
3. **Pattern Recognition**: Leverage cross-project knowledge patterns
4. **Decision Tracking**: All architectural decisions are preserved
EOF
        
        print_success "Created basic cursor rules: $rules_file"
    fi
}

validate_setup() {
    print_step "Validating enhanced setup..."
    
    local cursor_dir="$PROJECT_DIR/.cursor"
    local issues=0
    
    # Check MCP configuration
    if [ ! -f "$cursor_dir/mcp.json" ]; then
        print_error "MCP configuration missing"
        ((issues++))
    else
        print_success "MCP configuration ✓"
    fi
    
    # Check cursor rules
    if [ ! -f "$PROJECT_DIR/.cursorrules" ]; then
        print_error "Main cursor rules missing"
        ((issues++))
    else
        print_success "Main cursor rules ✓"
    fi
    
    # Check advanced rules
    local rules_count=$(ls "$cursor_dir/rules"/*.mdc 2>/dev/null | wc -l)
    if [ "$rules_count" -eq 0 ]; then
        print_warning "No advanced .mdc rules found"
    else
        print_success "Advanced rules ✓ ($rules_count files)"
    fi
    
    return $issues
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
    echo "Config Directory: $CONFIG_DIR"
    echo ""
    
    # Execute enhanced setup steps
    check_memory_service
    create_enhanced_cursor_config
    copy_cursor_rules
    create_adaptive_cursorrules
    validate_setup
    test_connection
    
    print_success "Enhanced project initialization complete!"
    echo ""
    echo "✅ Configuration files installed:"
    echo "   • .cursor/mcp.json - Enhanced MCP server configuration (3 servers)"
    echo "   • .cursor/rules/*.mdc - Advanced development rules (DADMS-derived)"
    echo "   • .cursorrules - Adaptive project-specific guidelines"
    echo ""
    echo "🚀 Enhanced features available:"
    echo "   • Automatic memory storage during development"
    echo "   • Advanced code quality and testing standards"
    echo "   • Architecture maintenance guidelines"
    echo "   • Cross-project knowledge sharing"
    echo "   • ML model access via HuggingFace MCP"
    echo "   • Graph database queries via Neo4j Cypher"
    echo ""
    echo "📋 Next steps:"
    echo "1. 🔄 Restart Cursor to load the enhanced MCP configuration"
    echo "2. 🧠 Test memory by asking the AI to remember something about ${PROJECT_NAME}"
    echo "3. 🔍 Check memory status: cd dev-project-init && ./scripts/check_memory.sh"
    echo "4. 📊 View memories: http://localhost:9475 (neo4j/devmemorypass)"
    echo "5. 🎯 Start development - all advanced rules are now active!"
    echo ""
    echo "🌐 Development memory service URLs:"
    echo "   • Neo4j Web UI: http://localhost:9475 (unusual port)"
    echo "   • Bolt API: neo4j://localhost:9688 (unusual port)"
    echo "   • Project ID: ${PROJECT_NAME}"
    echo ""
    echo "💡 Note: Using unusual ports (9xxx) to avoid conflicts with application ports"
    echo "🎉 Your project now has enterprise-grade development standards!"
}

# Run main function
main "$@"