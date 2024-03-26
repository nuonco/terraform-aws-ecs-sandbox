# terraform-aws-ecs-sandbox

AWS ECS sandbox for Nuon apps.

## Usage

This module can be used via the [aws-ecs](github.com/nuonco/sandboxes/aws-ecs) project in [nuonco/sandboxes](github.com/nuonco/sandboxes).

```hcl
resource "nuon_app" "my_ecs_app" {
  name = "my_ecs_app"
}

resource "nuon_app_sandbox" "main" {
  app_id            = nuon_app.my_ecs_app.id
  terraform_version = "v1.6.3"
  public_repo = {
    repo      = "nuonco/sandboxes"
    branch    = "main"
    directory = "aws-ecs"
  }
}
```
