locals {
  backups = {
    schedule  = "cron(15 02 ? * MON-FRI *)" /* UTC Time */
    retention = 7 // days
  }
}

resource "aws_backup_vault" "hclpocvault" {
  name = "hclpocvault"
  #tags = {
    #Project = var.project
    #Role    = "backup-vault"
  #}
}

resource "aws_backup_plan" "hclpoc-backup-plan" {
  name = "hclpoc-backup-plan"

  rule {
    rule_name         = "hclpoc-backup-plan"
    target_vault_name = aws_backup_vault.hclpocvault.name
    schedule          = local.backups.schedule
    start_window      = 60
    completion_window = 300

    lifecycle {
      delete_after = local.backups.retention
    }

    recovery_point_tags = {
      #Project = var.project
      Role    = "backup"
      Creator = "aws-backups"
    }
  }

  tags = {
    #Project = var.project
    Role    = "backup"
  }
}

resource "aws_backup_selection" "hclpoc-backup-selection" {
  iam_role_arn = aws_iam_role.hcliamrole.arn
  name         = "hclpoc-server-resources"
  plan_id      = aws_backup_plan.hclpoc-backup-plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}