# Skill: Performance Optimization (/performance)

## Purpose
Guide agents in writing high-performance, resource-efficient code with minimal latency and memory overhead across any technology stack.

## Directives

### 1. Database & Queries
- Avoid N+1 query problems — use eager loading or batch fetching for relational queries.
- Ensure proper database indexing on foreign keys, search fields, and frequently filtered columns.
- Select only required fields rather than wildcard `SELECT *` on large data tables.

### 2. View / Resource Loading & Assets
- Implement lazy loading or asynchronous loading for non-critical dependencies and heavy modules.
- Memoize or cache expensive calculations in memory.
- Optimize media assets and network payloads for bandwidth efficiency.

### 3. Caching & Memory Management
- Cache static or infrequently changing data using appropriate caching stores or HTTP headers.
- Clean up side effects, background listeners, or unmanaged resources to prevent memory leaks.
