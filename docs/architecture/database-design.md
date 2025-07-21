# Database Design

## 🏗️ Database Architecture Overview

The EssayCoach database follows a normalized PostgreSQL design optimized for educational analytics and AI feedback processing. The schema balances data integrity with query performance for complex educational workflows.

## 📊 Design Principles

### 1. Normalization Strategy
- **3NF Compliance**: All tables achieve Third Normal Form to eliminate data redundancy
- **Selective Denormalization**: Strategic denormalization for performance-critical queries
- **Flexible Schema**: Django ORM provides migration-friendly schema evolution

### 2. Educational Domain Modeling
- **User-Centric**: Every entity relates to the educational workflow
- **Audit Trail**: Complete history tracking for compliance and analytics
- **Multi-tenancy Ready**: Schema supports future multi-institution deployment

## 🔍 Entity Relationships

### Core Entity Categories

#### User Management
```
Users (Django Auth)
├── UserProfiles (Extended user information)
├── Roles (Student, Educator, Admin)
└── Permissions (Granular access control)
```

#### Essay Workflow
```
Essays
├── EssayVersions (Version control for submissions)
├── EssayCategories (Academic subject classification)
└── EssayMetadata (Additional submission details)
```

#### AI Feedback System
```
AIResponses
├── Feedback (Processed AI feedback)
├── FeedbackTypes (Grammar, Structure, Content, Style)
└── FeedbackScores (Quantitative assessments)
```

#### Analytics & Reporting
```
Analytics
├── UsageMetrics (System usage patterns)
├── PerformanceData (Student improvement tracking)
└── Reports (Generated educator insights)
```

## 🗝️ Primary Key Strategy

### UUID vs Serial
- **Primary Keys**: Sequential IDs for performance
- **Public APIs**: UUIDs for external reference security
- **Foreign Keys**: Optimized integer references

### Index Strategy
```sql
-- High-frequency query indexes
CREATE INDEX CONCURRENTLY idx_essays_user_created 
ON essays(user_id, created_at DESC);

-- AI processing optimization
CREATE INDEX CONCURRENTLY idx_feedback_pending 
ON feedback(essay_id, status) WHERE status = 'pending';

-- Analytics performance
CREATE INDEX CONCURRENTLY idx_analytics_date_range 
ON analytics(created_at DESC, user_id);
```

## 🔐 Security Design

### Row-Level Security (RLS)
```sql
-- Enable RLS on sensitive tables
ALTER TABLE essays ENABLE ROW LEVEL SECURITY;
ALTER TABLE feedback ENABLE ROW LEVEL SECURITY;

-- Student access policy
CREATE POLICY student_access ON essays
FOR ALL TO app_user
USING (user_id = current_user_id());
```

### Data Encryption
- **At Rest**: PostgreSQL native encryption for sensitive fields
- **In Transit**: SSL/TLS for all database connections
- **PII Protection**: Email and personal information encrypted

## 📈 Performance Optimization

### Partitioning Strategy
```sql
-- Time-based partitioning for large tables
CREATE TABLE essays_2024 PARTITION OF essays
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Size-based partitioning for analytics
CREATE TABLE analytics_large PARTITION OF analytics
FOR VALUES WITH (modulus 4, remainder 0);
```

### Materialized Views
```sql
-- Pre-computed analytics for dashboard
CREATE MATERIALIZED VIEW student_progress_summary AS
SELECT 
    user_id,
    COUNT(*) as total_essays,
    AVG(overall_score) as avg_score,
    MAX(created_at) as last_submission
FROM essays 
WHERE status = 'completed'
GROUP BY user_id;
```

## 🔄 Migration Management

### Schema Evolution Process
1. **Design Review**: Architectural review of schema changes
2. **Backward Compatibility**: Ensure existing APIs remain functional
3. **Data Migration**: Scripts for complex data transformations
4. **Rollback Plan**: Revert procedures for failed migrations

### Django Migration Best Practices
```python
# Example migration with data transformation
class Migration(migrations.Migration):
    dependencies = [('essay', '0005_auto_20240101_1200')]
    
    operations = [
        migrations.AddField(
            model_name='essay',
            name='processing_status',
            field=models.CharField(max_length=20, default='pending'),
        ),
        migrations.RunPython(migrate_processing_status),
    ]
```

## 🧪 Testing Strategy

### Database Testing
- **Unit Tests**: Model validation and business rules
- **Integration Tests**: Migration testing with production data
- **Performance Tests**: Query optimization with realistic datasets
- **Security Tests**: RLS policy validation

### Test Data Management
```python
# Factory pattern for test data
class EssayFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Essay
    
    title = factory.Faker('sentence')
    content = factory.Faker('text', max_nb_chars=2000)
    user = factory.SubFactory(UserFactory)
```

## 📊 Monitoring & Maintenance

### Health Checks
- **Connection Pooling**: PgBouncer for connection management
- **Query Performance**: pg_stat_statements for slow query detection
- **Disk Usage**: Automated alerts for table bloat
- **Replication Lag**: Master-replica synchronization monitoring

### Maintenance Procedures
```sql
-- Regular maintenance tasks
VACUUM ANALYZE essays;
REINDEX INDEX CONCURRENTLY idx_essays_user_created;
REFRESH MATERIALIZED VIEW CONCURRENTLY student_progress_summary;
```

## 🔍 Query Examples

### Educational Analytics
```sql
-- Student improvement tracking
SELECT 
    u.username,
    DATE_TRUNC('week', e.created_at) as week,
    AVG(f.overall_score) as avg_weekly_score,
    COUNT(e.id) as essays_submitted
FROM users u
JOIN essays e ON u.id = e.user_id
JOIN feedback f ON e.id = f.essay_id
WHERE e.created_at >= NOW() - INTERVAL '3 months'
GROUP BY u.username, DATE_TRUNC('week', e.created_at)
ORDER BY u.username, week;
```

### AI Processing Optimization
```sql
-- Pending feedback queue
SELECT 
    e.id,
    e.title,
    e.content_length,
    u.email,
    e.created_at
FROM essays e
JOIN users u ON e.user_id = u.id
WHERE e.ai_processing_status = 'pending'
ORDER BY e.created_at ASC
LIMIT 100;
```