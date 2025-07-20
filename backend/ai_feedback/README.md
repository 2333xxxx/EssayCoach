# AI Feedback App Documentation

## Overview

The AI Feedback app provides intelligent essay analysis and feedback generation using agentic workflows and prompt engineering. This app serves as the core intelligence layer of the EssayCoach platform, orchestrating AI agents to analyze student essays and provide detailed, actionable feedback to improve writing skills.

## Features

### Agentic Workflow Engine
- **Multi-Agent System**: Specialized agents for different aspects of essay analysis
- **Prompt Engineering**: Advanced prompt templates and context management
- **Workflow Orchestration**: Coordinated agent interactions for comprehensive analysis
- **DIFY Integration**: Early-stage integration with DIFY platform for workflow management
- **LangChain Migration Path**: Future migration to LangChain for complex workflows

### Essay Analysis
- **Structure Analysis**: Organization, flow, and coherence evaluation
- **Content Assessment**: Argument strength, evidence quality, and thesis clarity
- **Writing Style**: Tone, voice, and stylistic appropriateness
- **Grammar & Mechanics**: Language mechanics and clarity improvements
- **Context-Aware Feedback**: Personalized feedback based on essay type and level

### Feedback Generation
- **Actionable Suggestions**: Specific, implementable improvement recommendations
- **Progressive Guidance**: Step-by-step improvement pathways
- **Example Integration**: Relevant examples and templates for learning
- **Multi-format Output**: Structured feedback for reports and notifications

### Integration & Extensibility
- **API-First Design**: RESTful APIs for integration with other apps
- **Plugin Architecture**: Extensible system for new analysis types
- **Configuration Management**: Flexible prompt and workflow configuration
- **Performance Monitoring**: Track analysis quality and response times

## Models

### EssayAnalysis
Core analysis results for submitted essays:
- `essay_id`: Foreign key to EssaySubmission
- `overall_score`: Composite evaluation score
- `structure_analysis`: JSON analysis of organization and flow
- `content_analysis`: JSON analysis of arguments and evidence
- `style_analysis`: JSON analysis of writing style and tone
- `grammar_notes`: JSON array of language mechanics issues
- `feedback_summary`: Generated feedback overview
- `agent_workflow_id`: Reference to workflow used
- `processing_metadata`: JSON metadata about analysis process

### AnalysisWorkflow
Workflow configuration and tracking:
- `workflow_name`: Human-readable workflow name
- `workflow_type`: Type of analysis workflow
- `prompt_templates`: JSON configuration of prompts used
- `agent_config`: JSON agent configuration
- `is_active`: Whether workflow is currently active
- `performance_metrics`: JSON performance tracking data

### FeedbackTemplate
Reusable feedback templates:
- `template_name`: Template identifier
- `template_type`: Type of feedback template
- `prompt_structure`: JSON prompt template structure
- `variables`: JSON schema for template variables
- `use_case`: Target use case description

## API Endpoints

### Essay Analysis
```
POST /ai-feedback/analyze/          # Submit essay for AI analysis
GET  /ai-feedback/analysis/{id}/    # Get analysis results
PUT  /ai-feedback/regenerate/{id}/  # Regenerate feedback with new workflow
```

### Workflow Management
```
GET  /ai-feedback/workflows/        # List available workflows
POST /ai-feedback/workflows/        # Create new workflow configuration
PUT  /ai-feedback/workflows/{id}/   # Update workflow configuration
```

### Feedback Management
```
GET  /ai-feedback/feedback/{id}/    # Get detailed feedback
PUT  /ai-feedback/feedback/{id}/    # Update feedback (human correction)
```

## Configuration

### Settings Required
Add to your Django settings:

```python
INSTALLED_APPS = [
    # ... other apps
    'ai_feedback',
]

# AI Service Configuration
AI_SERVICE_CONFIG = {
    'DIFY_API_KEY': 'your-dify-api-key',
    'DIFY_BASE_URL': 'https://api.dify.ai',
    'WORKFLOW_TIMEOUT': 300,  # seconds
    'MAX_RETRIES': 3,
}

# Analysis Settings
ESSAY_ANALYSIS_CONFIG = {
    'MAX_ESSAY_LENGTH': 10000,  # characters
    'SUPPORTED_LANGUAGES': ['en', 'es', 'fr', 'de'],
    'ENABLE_CACHE': True,
    'CACHE_TTL': 3600,  # seconds
}

# Future Migration Settings
LANGCHAIN_CONFIG = {
    'ENABLE_LANGCHAIN': False,  # Set to True for future migration
    'OPENAI_API_KEY': 'your-openai-key',  # For future use
    'ANTHROPIC_API_KEY': 'your-anthropic-key',  # For future use
}
```

## Testing

Run tests for the AI feedback app:

```bash
python manage.py test ai_feedback
```

### Test Coverage
- Agent workflow execution
- Prompt template rendering
- API integration tests
- Feedback quality validation
- Error handling and edge cases
- Performance testing

## Security Considerations

1. **API Key Security**: Store API keys securely using environment variables
2. **Rate Limiting**: Implement rate limiting for AI service calls
3. **Data Privacy**: Ensure essay content is handled securely
4. **Content Filtering**: Filter inappropriate content before analysis
5. **Access Control**: Restrict access to analysis endpoints
6. **Audit Logging**: Log all analysis requests for compliance

## Development

### Adding New Analysis Types
1. Define new workflow configuration
2. Create prompt templates
3. Configure agent interactions
4. Test with sample essays
5. Update documentation

### Workflow Enhancements
1. Design new agent workflows
2. Optimize prompt effectiveness
3. Add new feedback categories
4. Improve response quality

### Migration Planning
1. Plan DIFY to LangChain migration
2. Design extensible architecture
3. Maintain backward compatibility
4. Document migration steps

## Dependencies

- Django >= 4.2
- djangorestframework
- requests (for API calls)
- celery (for async processing)
- redis (for caching)

## Contributing

When contributing to the AI feedback app:
1. Focus on prompt effectiveness over model details
2. Test workflows with diverse essay samples
3. Ensure feedback is constructive and educational
4. Document workflow changes clearly
5. Consider future migration paths
6. Maintain API stability
