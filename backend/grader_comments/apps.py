from django.apps import AppConfig


class GraderCommentsConfig(AppConfig):
    """
    Grader Comments App Configuration
    
    This app provides a comprehensive system for human graders to add detailed
    comments, annotations, and feedback to student essays. It supports collaborative
    grading, rubric-based evaluation, and rich text annotations to complement
    AI-generated feedback with expert human insights.
    
    Key Responsibilities:
    - Rich text comments and inline annotations
    - Visual annotation tools (highlighting, drawing, multimedia)
    - Rubric-based grading and scoring
    - Collaborative grading workflows
    - Comment templates and reusable feedback
    - Grading session tracking and analytics
    
    Integration Points:
    - Works with essay_submission app for essay access
    - Integrates with feedback_report app for report generation
    - Provides grading data to analytics app
    - Uses notification app for grader assignments
    
    Future Enhancements:
    - AI-assisted grading suggestions
    - Real-time collaboration features
    - Mobile grading applications
    - Advanced annotation tools
    - Peer review capabilities
    """
    default_auto_field = "django.db.models.BigAutoField"
    name = "grader_comments"
    verbose_name = "Grader Comments"
    
    def ready(self):
        """Initialize grader comments app components when Django starts."""
        # Import grading utilities and annotation handlers
        from . import grading
        from . import annotations
