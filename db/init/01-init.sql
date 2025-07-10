-- PostgresAI initialization script
-- Creates necessary extensions, schemas, and initial data

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "hstore";

-- Create schemas
CREATE SCHEMA IF NOT EXISTS ai_data;
CREATE SCHEMA IF NOT EXISTS ai_models;

-- Create AI configuration table
CREATE TABLE IF NOT EXISTS ai_models.model_config (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    model_name VARCHAR(100) NOT NULL UNIQUE,
    model_type VARCHAR(50) NOT NULL,
    model_params JSONB NOT NULL DEFAULT '{}',
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create sample data
INSERT INTO ai_models.model_config (model_name, model_type, model_params)
VALUES 
('default-model', 'text-embedding', '{"dimensions": 768, "context_length": 4096}')
ON CONFLICT (model_name) DO NOTHING;

-- Set up permissions
GRANT USAGE ON SCHEMA ai_data TO ${POSTGRES_USER:-postgres_admin};
GRANT USAGE ON SCHEMA ai_models TO ${POSTGRES_USER:-postgres_admin};
GRANT ALL ON ALL TABLES IN SCHEMA ai_data TO ${POSTGRES_USER:-postgres_admin};
GRANT ALL ON ALL TABLES IN SCHEMA ai_models TO ${POSTGRES_USER:-postgres_admin};
GRANT ALL ON ALL SEQUENCES IN SCHEMA ai_data TO ${POSTGRES_USER:-postgres_admin};
GRANT ALL ON ALL SEQUENCES IN SCHEMA ai_models TO ${POSTGRES_USER:-postgres_admin};

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- Apply trigger to configuration table
CREATE TRIGGER update_model_config_timestamp
BEFORE UPDATE ON ai_models.model_config
FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
