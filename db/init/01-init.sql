-- Initialize PostgresAI Database
-- This script runs when the PostgreSQL container starts

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "hstore";

-- Create schema for AI operations
CREATE SCHEMA IF NOT EXISTS ai_operations;

-- Create users table
CREATE TABLE IF NOT EXISTS ai_operations.users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create models table
CREATE TABLE IF NOT EXISTS ai_operations.models (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL,
    version VARCHAR(50),
    description TEXT,
    parameters JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create conversations table
CREATE TABLE IF NOT EXISTS ai_operations.conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES ai_operations.users(id),
    model_id UUID REFERENCES ai_operations.models(id),
    title VARCHAR(500),
    messages JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default models
INSERT INTO ai_operations.models (name, type, version, description) VALUES
('deepseek:latest', 'llm', 'latest', 'DeepSeek language model'),
('llama2:13b-chat-q4_0', 'llm', '13b-q4_0', 'Llama 2 13B chat model quantized'),
('distilbert-base-uncased', 'transformer', 'base', 'DistilBERT base model uncased')
ON CONFLICT DO NOTHING;

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_users_username ON ai_operations.users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON ai_operations.users(email);
CREATE INDEX IF NOT EXISTS idx_conversations_user_id ON ai_operations.conversations(user_id);
CREATE INDEX IF NOT EXISTS idx_conversations_created_at ON ai_operations.conversations(created_at);

-- Grant permissions
GRANT ALL PRIVILEGES ON SCHEMA ai_operations TO postgres_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ai_operations TO postgres_admin;
