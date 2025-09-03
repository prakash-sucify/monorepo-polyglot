# 🐳 Single Docker Compose Configuration

This project uses a **single Docker Compose file** that supports both development and production environments through environment variables and profiles.

## 📁 **File Structure**

```
docker-compose.yml              # Single configuration for all environments
```

## 🚀 **Usage**

### **Development (Default)**
```bash
# Start development environment
docker-compose up --build

# Access services directly
http://localhost:3000  # Web app
http://localhost:3001  # Admin panel
http://localhost:3002  # Auth service
http://localhost:8080  # Payment service
http://localhost:8081  # Analytics service
http://localhost:8082  # AI service
http://localhost:8083  # PDF service
```

### **Production**
```bash
# Deploy production environment
docker-compose --profile production up --build -d

# Access through domain
https://monorepo.sucify.com        # Web app
https://admin.monorepo.sucify.com  # Admin panel
https://api.monorepo.sucify.com    # API gateway
```

## 🔧 **Key Features**

### **Single Configuration (`docker-compose.yml`)**
- ✅ All services defined with environment-based configuration
- ✅ Environment variables with fallback values
- ✅ Nginx service with production profile
- ✅ Volume mounts for development
- ✅ Port exposure for direct access
- ✅ Production profile for nginx and domain routing

## 🎯 **Environment Variables**

The configuration uses environment variables with sensible defaults:

| Variable | Development Default | Production |
|----------|-------------------|------------|
| `NODE_ENV` | `development` | `production` |
| `WEB_PORT` | `3000` | `3000` |
| `ADMIN_PORT` | `3001` | `3001` |
| `AUTH_PORT` | `3002` | `3002` |
| `JWT_SECRET` | `dev_jwt_secret...` | `${JWT_SECRET}` |
| `DATABASE_URL` | `postgresql://...` | `postgresql://...` |
| `NEXT_PUBLIC_WEB_APP_URL` | `http://localhost:3000` | `https://monorepo.sucify.com` |

## 📊 **Service Comparison**

| Service | Development | Production |
|---------|-------------|------------|
| **Web App** | `localhost:3000` | `monorepo.sucify.com` |
| **Admin** | `localhost:3001` | `admin.monorepo.sucify.com` |
| **Auth** | `localhost:3002` | `api.monorepo.sucify.com/auth` |
| **Payment** | `localhost:8080` | `api.monorepo.sucify.com/payment` |
| **Analytics** | `localhost:8081` | `api.monorepo.sucify.com/analytics` |
| **AI** | `localhost:8082` | `api.monorepo.sucify.com/ai` |
| **PDF** | `localhost:8083` | `api.monorepo.sucify.com/pdf` |

## 🛠️ **Management Commands**

### **Development**
```bash
# Start all services
docker-compose up --build

# Start specific services
docker-compose up web admin

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### **Production**
```bash
# Start production
docker-compose --profile production up --build -d

# View logs
docker-compose --profile production logs -f

# Stop production
docker-compose --profile production down

# Restart services
docker-compose --profile production restart
```

## 🎉 **Benefits of Single File Approach**

1. **Simplicity**: One file to maintain
2. **Environment Flexibility**: Easy switching between dev/prod
3. **Maintainability**: No duplicate configurations
4. **Consistency**: Same service definitions across environments
5. **Docker Profiles**: Uses Docker Compose profiles for environment separation

## 🔄 **How It Works**

1. **Base Configuration**: `docker-compose.yml` contains all services
2. **Environment Variables**: Different values for dev/prod via `.env` files
3. **Production Profile**: Nginx service only runs with `--profile production`
4. **Default Behavior**: Without profile, runs in development mode

## 📝 **Environment Files**

Create environment files for different configurations:

### **Development (`.env`)**
```env
NODE_ENV=development
NEXT_PUBLIC_WEB_APP_URL=http://localhost:3000
NEXT_PUBLIC_ADMIN_APP_URL=http://localhost:3001
JWT_SECRET=dev_jwt_secret_key_change_in_production
```

### **Production (`.env.production`)**
```env
NODE_ENV=production
NEXT_PUBLIC_WEB_APP_URL=https://monorepo.sucify.com
NEXT_PUBLIC_ADMIN_APP_URL=https://admin.monorepo.sucify.com
JWT_SECRET=your_production_jwt_secret
STRIPE_SECRET_KEY=sk_live_your_stripe_secret_key
OPENAI_API_KEY=sk-your_openai_api_key
```

This provides maximum simplicity while maintaining environment flexibility!