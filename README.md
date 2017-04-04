# Setup_dev_env
Developmanet enviroment control System

#### Description
Based on bash script. system to manage Docker images and containers suitable for developmant process.

#### Usage
```bash
# Initialize Project
dev-project init

# Initialize Environment
dev-env init

# Invoking a flags
dev-env --<flagname>
```

#### Folder structure
```
-Project_folder (projectname)
    |- .project
    |- repo     (can have multiple such sub repo)
        |- .dev-env
            |- .global (required)
            |- config  (auto generated)
            |- flags
                |- <flagname>.sh
            |- Dockerfiles
                |- <imagename>.sh

```
