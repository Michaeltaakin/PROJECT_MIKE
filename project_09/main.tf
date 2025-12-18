#######################################
# 1️⃣ Create Multiple EC2 Instances
#######################################
resource "aws_instance" "app" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name   = "BackupRecoveryDemo-${count.index + 1}"
    Backup = "true" # this key/value must match aws_backup_selection
  }
}

#######################################
# 2️⃣ IAM Role for AWS Backup
#######################################
data "aws_iam_policy_document" "assume_backup_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "backup_role" {
  name               = "aws-backup-role"
  assume_role_policy = data.aws_iam_policy_document.assume_backup_role.json
}

resource "aws_iam_role_policy_attachment" "backup_role_attach" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}


#######################################
# 3️⃣ Create Backup Vault
#######################################
resource "aws_backup_vault" "vault" {
  name = "ec2-backup-vault"
}

#######################################
# 4️⃣ Backup Plan (daily)
#######################################
resource "aws_backup_plan" "plan" {
  name = "daily-ec2-backup"

  rule {
    rule_name         = "daily-backup-rule"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = "cron(0 5 ? * * *)" # daily at 5 AM UTC

    lifecycle {
      delete_after = 30
    }
  }
}


#######################################
# 5️⃣ Select EC2 Instances by Tag (v5+ syntax)
#######################################
resource "aws_backup_selection" "select_ec2" {
  name         = "select-ec2-by-tag"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.plan.id
  resources    = [] # required, even when selecting by tag

  selection_tag {
    type  = "STRINGEQUALS" # required in provider v5+
    key   = "Backup"       # must match EC2 tag key
    value = "true"         # must match EC2 tag value
  }
}

#######################################
# 6️⃣ CloudWatch Alarms for Auto-Recovery
#######################################
data "aws_region" "current" {}

resource "aws_cloudwatch_metric_alarm" "auto_recovery" {
  count               = var.instance_count
  alarm_name          = "ec2-auto-recover-${aws_instance.app[count.index].id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    InstanceId = aws_instance.app[count.index].id
  }

  alarm_actions = [
    "arn:aws:automate:${data.aws_region.current.name}:ec2:recover"
  ]

  tags = {
    Name = "EC2AutoRecoveryAlarm-${count.index + 1}"
  }
}
