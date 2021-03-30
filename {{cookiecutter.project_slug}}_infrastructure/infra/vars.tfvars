aws_region = "{{cookiecutter.aws_region}}"

### DEV VARS ###
db_name_dev               = "test_changeme"
db_username_dev           = "test_changeme"
db_password_dev           = "test_changeme"
cache_policy_dev          = "test_changeme"
origin_request_policy_dev = "test_changeme"
kms_key_id_dev            = "arn:aws:kms:{{cookiecutter.aws_region}}:153270690925:key/279ddf2d-de19-4594-809c-7552a41ffb40"

### PROD VARS ###
db_name_prd               = "test_changeme"
db_username_prd           = "test_changeme"
db_password_prd           = "test_changeme"
cache_policy_prd          = "test_changeme"
origin_request_policy_prd = "test_changeme"
kms_key_id_prd            = "arn:aws:kms:{{cookiecutter.aws_region}}:153270690925:key/279ddf2d-de19-4594-809c-7552a41ffb40"

### CICD VARS ###
repoUrl    = "https://{{cookiecutter.repository}}"
repoId     = "{{cookiecutter.repo_id}}"
branch     = "main"
buildImage = "{{cookiecutter.aws_account}}.dkr.ecr.{{cookiecutter.aws_region}}.amazonaws.com/zappa_build_image:latest"